import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../providers/fullstack_providers.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P32: Food List - Real-time search + data flow to P28
class P32FoodList extends StatefulWidget {
  final VoidCallback onNext;
  
  const P32FoodList({super.key, required this.onNext});

  @override
  State<P32FoodList> createState() => _P32FoodListState();
}

class _P32FoodListState extends State<P32FoodList> {
  final _searchController = TextEditingController();
  final _selectedFoods = <_FoodItem>[];
  
  // Food database (simulated - in production, this comes from API)
  final List<_FoodItem> _foodDatabase = [
    _FoodItem(name: 'Pizza Slice', calories: 285, protein: 12, carbs: 36, fat: 10),
    _FoodItem(name: 'Apple', calories: 95, protein: 0, carbs: 25, fat: 0),
    _FoodItem(name: 'Chicken Breast (grilled)', calories: 165, protein: 31, carbs: 0, fat: 4),
    _FoodItem(name: 'Brown Rice', calories: 215, protein: 5, carbs: 45, fat: 2),
    _FoodItem(name: 'Greek Yogurt', calories: 100, protein: 17, carbs: 6, fat: 0),
    _FoodItem(name: 'Avocado', calories: 160, protein: 2, carbs: 9, fat: 15),
    _FoodItem(name: 'Sweet Potato', calories: 103, protein: 2, carbs: 24, fat: 0),
    _FoodItem(name: 'Salmon Fillet', calories: 208, protein: 20, carbs: 0, fat: 13),
    _FoodItem(name: 'Egg (boiled)', calories: 78, protein: 6, carbs: 1, fat: 5),
    _FoodItem(name: 'Banana', calories: 105, protein: 1, carbs: 27, fat: 0),
    _FoodItem(name: 'Oatmeal', calories: 150, protein: 5, carbs: 27, fat: 3),
    _FoodItem(name: 'Almonds (30g)', calories: 170, protein: 6, carbs: 6, fat: 15),
    _FoodItem(name: 'Broccoli', calories: 55, protein: 4, carbs: 11, fat: 1),
    _FoodItem(name: 'Quinoa', calories: 222, protein: 8, carbs: 39, fat: 4),
    _FoodItem(name: 'Tuna (canned)', calories: 116, protein: 26, carbs: 0, fat: 1),
  ];
  
  List<_FoodItem> _searchResults = [];
  
  @override
  void initState() {
    super.initState();
    _searchResults = List.from(_foodDatabase);
    
    // Real-time search listener
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 【CORE】Real-time fuzzy search
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    
    setState(() {
      if (query.isEmpty) {
        _searchResults = List.from(_foodDatabase);
      } else {
        _searchResults = _foodDatabase.where((food) {
          // Fuzzy match: name contains query OR first letters match
          return food.name.toLowerCase().contains(query) ||
                 _fuzzyMatch(food.name.toLowerCase(), query);
        }).toList();
      }
    });
  }
  
  // Simple fuzzy matching
  bool _fuzzyMatch(String text, String query) {
    int textIndex = 0;
    for (int i = 0; i < query.length && textIndex < text.length; i++) {
      if (text[textIndex] == query[i]) {
        textIndex++;
      }
    }
    return textIndex >= query.length;
  }

  // 【CORE】Add food → Flow to P28 Calories
  void _addFood(_FoodItem food) {
    setState(() {
      _selectedFoods.add(food);
    });
    
    // 【DATA FLOW】Sync to OnboardingState
    final state = Provider.of<OnboardingState>(context, listen: false);
    state.addFood({
      'name': food.name,
      'calories': food.calories,
      'protein': food.protein,
      'carbs': food.carbs,
      'fat': food.fat,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // 【QUOTE】Precise feeding based on calorie level
    _triggerQuote(food.calories);
  }
  
  void _triggerQuote(int calories) {
    String quote;
    
    if (calories > 400) {
      // High calorie - tough love quote
      quote = QuoteEngine.instance.getQuote(
        context: 'food',
        allowedCategories: ['tough'],
      );
    } else if (calories > 200) {
      // Medium - professional quote
      quote = QuoteEngine.instance.getQuote(
        context: 'food',
        allowedCategories: ['professional'],
      );
    } else {
      // Low - praise quote
      quote = QuoteEngine.instance.getQuote(
        context: 'food',
        allowedCategories: ['praise'],
      );
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(quote)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _removeFood(int index) {
    final food = _selectedFoods[index];
    setState(() {
      _selectedFoods.removeAt(index);
    });
    
    // Update state (subtract calories)
    final state = Provider.of<OnboardingState>(context, listen: false);
    state.todayCalories -= food.calories;
    if (state.todayCalories < 0) state.todayCalories = 0;
  }

  int get _totalCalories => _selectedFoods.fold(0, (sum, f) => sum + f.calories);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onNext,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Text(
                    'Add Food',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // Live calorie total
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$_totalCalories kcal',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 【CORE】Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  hintStyle: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade400),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search Results
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No foods found',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchResults.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final food = _searchResults[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          food.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          'P: ${food.protein}g • C: ${food.carbs}g • F: ${food.fat}g',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${food.calories}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(' kcal', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _addFood(food),
                              child: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          // Selected Foods Summary
          if (_selectedFoods.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Quick remove chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedFoods.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(
                          '${entry.value.name} (${entry.value.calories})',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _removeFood(entry.key),
                        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: $_totalCalories kcal',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Remaining: ${state.dailyCalorieGoal - _totalCalories} kcal',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CapsuleButton(
                        text: 'Add to Diary',
                        onPressed: widget.onNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FoodItem {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  
  _FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
