import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';

/// P30: Mood Check
/// "How are you feeling today?"
class P30MoodCheck extends StatefulWidget {
  final VoidCallback onNext;
  
  const P30MoodCheck({super.key, required this.onNext});
  
  @override
  State<P30MoodCheck> createState() => _P30MoodCheckState();
}

class _P30MoodCheckState extends State<P30MoodCheck> {
  String? _selectedMood;
  
  final _moods = [
    {'emoji': '😊', 'label': 'Great', 'mood': BearMood.heartEyes},
    {'emoji': '🙂', 'label': 'Good', 'mood': BearMood.defaultMood},
    {'emoji': '😐', 'label': 'Okay', 'mood': BearMood.curious},
    {'emoji': '😔', 'label': 'Low', 'mood': BearMood.sleeping},
    {'emoji': '😤', 'label': 'Stressed', 'mood': BearMood.defaultMood},
  ];
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'How are you\nfeeling today?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const Spacer(),
            // Bear reacts to mood
            CanvasBear(
              mood: _selectedMood != null 
                  ? _moods.firstWhere((m) => m['label'] == _selectedMood)['mood'] as BearMood
                  : BearMood.curious,
              size: 150,
            ),
            const SizedBox(height: 32),
            // Mood selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood['label'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF4CAF50).withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mood['emoji'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: isSelected 
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade600,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            if (_selectedMood != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getMoodAdvice(_selectedMood!),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMood != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getMoodAdvice(String mood) {
    switch (mood) {
      case 'Great':
        return "Awesome! Keep up the great energy! 💪";
      case 'Good':
        return "Nice! You're on the right track! 🌟";
      case 'Okay':
        return "That's fine. Small steps lead to big changes!";
      case 'Low':
        return "Remember: every day is a fresh start. You've got this! 💙";
      case 'Stressed':
        return "Take a deep breath. Try a short walk or meditation. 🧘";
      default:
        return "Remember to stay hydrated and take breaks!";
    }
  }
}
