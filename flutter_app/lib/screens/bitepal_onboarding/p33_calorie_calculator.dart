import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P33: Calorie Calculator - Advanced Sliding Grams Logic
/// Precise macro calculation with visual portion guide
class P33CalorieCalculator extends StatefulWidget {
  final VoidCallback onNext;
  
  const P33CalorieCalculator({super.key, required this.onNext});

  @override
  State<P33CalorieCalculator> createState() => _P33CalorieCalculatorState();
}

class _P33CalorieCalculatorState extends State<P33CalorieCalculator> {
  // Selected food (default: sweet potato)
  final Map<String, dynamic> _selectedFood = {
    'name': 'Sweet Potato',
    'caloriesPer100g': 86,
    'proteinPer100g': 1.6,
    'carbsPer100g': 20.1,
    'fatPer100g': 0.1,
    'emoji': '🍠',
  };
  
  double _grams = 100;
  
  // Calculate macros based on grams
  int get _totalCalories => (_grams * _selectedFood['caloriesPer100g'] / 100).round();
  double get _protein => (_grams * _selectedFood['proteinPer100g'] / 100 * 10).round() / 10;
  double get _carbs => (_grams * _selectedFood['carbsPer100g'] / 100 * 10).round() / 10;
  double get _fat => (_grams * _selectedFood['fatPer100g'] / 100 * 10).round() / 10;

  // Quick portion buttons
  final List<Map<String, dynamic>> _portions = [
    {'label': 'Small', 'grams': 50, 'icon': Icons.lunch_dining},
    {'label': 'Medium', 'grams': 100, 'icon': Icons.dinner_dining},
    {'label': 'Large', 'grams': 200, 'icon': Icons.restaurant},
    {'label': 'Extra', 'grams': 300, 'icon': Icons.fastfood},
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEDF6FA), Colors.white],
        ),
      ),
      child: SafeArea(
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
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          _selectedFood['emoji'],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedFood['name'],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // 【CORE】Visual portion display
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background plate
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              border: Border.all(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                width: 3,
                              ),
                            ),
                          ),
                          // Food icon with size based on grams
                          Transform.scale(
                            scale: 0.5 + (_grams / 400).clamp(0.0, 1.0) * 1.0,
                            child: Text(
                              _selectedFood['emoji'],
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                          // Portion indicator
                          Positioned(
                            bottom: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${_grams.round()}g',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 【CORE】Large calorie display
                    Text(
                      '$_totalCalories',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 72,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Macro breakdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _MacroCard(
                          label: 'Protein',
                          value: '${_protein}g',
                          color: const Color(0xFFFF6B6B),
                          icon: Icons.fitness_center,
                        ),
                        _MacroCard(
                          label: 'Carbs',
                          value: '${_carbs}g',
                          color: const Color(0xFF4ECDC4),
                          icon: Icons.grain,
                        ),
                        _MacroCard(
                          label: 'Fat',
                          value: '${_fat}g',
                          color: const Color(0xFFFFE66D),
                          icon: Icons.opacity,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick portion buttons
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick Select',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: _portions.map((portion) {
                        final isSelected = _grams == portion['grams'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _grams = portion['grams'].toDouble()),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF4CAF50) 
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    portion['icon'],
                                    color: isSelected ? Colors.white : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    portion['label'],
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${portion['grams']}g',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                      color: isSelected ? Colors.white70 : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 【CORE】Precise gram slider
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Custom Amount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 8,
                        activeTrackColor: const Color(0xFF4CAF50),
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: const Color(0xFF4CAF50),
                        overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                        trackShape: const RoundedRectSliderTrackShape(),
                      ),
                      child: Slider(
                        value: _grams,
                        min: 10,
                        max: 500,
                        divisions: 49,
                        onChanged: (value) => setState(() => _grams = value),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                        Text('500g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Calorie comparison
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFF4CAF50), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${_grams.round()}g of ${_selectedFood['name']} = $_totalCalories kcal (${state.dailyCalorieGoal - state.todayCalories - _totalCalories} remaining)',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Bottom section with bear and add button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CanvasBear(
                    mood: BearMood.heartEyes,
                    size: 50,
                    animate: false,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _grams > 200 
                            ? "That's a big portion! 🍽️ Make sure it fits your goals!"
                            : "Good portion size! 👍 Perfect for tracking!",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Add to diary button
            Padding(
              padding: const EdgeInsets.all(16),
              child: CapsuleButton(
                text: 'Add $_totalCalories kcal to Diary',
                onPressed: () {
                  state.addFood({
                    'name': _selectedFood['name'],
                    'calories': _totalCalories,
                    'protein': _protein,
                    'carbs': _carbs,
                    'fat': _fat,
                    'timestamp': DateTime.now().toIso8601String(),
                  });
                  widget.onNext();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  
  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
