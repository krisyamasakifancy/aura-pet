import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P33CalorieCalculator extends StatefulWidget {
  final VoidCallback onNext;
  
  const P33CalorieCalculator({super.key, required this.onNext});

  @override
  State<P33CalorieCalculator> createState() => _P33CalorieCalculatorState();
}

class _P33CalorieCalculatorState extends State<P33CalorieCalculator> {
  double _grams = 100;
  int _calories = 120;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: widget.onNext, icon: const Icon(Icons.arrow_back)),
                const Text('Sweet Potato', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const Spacer(),
            Text('$_calories kcal', style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 48, color: Color(0xFF4CAF50))),
            Text('$_grams g', style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600)),
            const Spacer(),
            Text('Adjust amount', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: const Color(0xFF4CAF50),
              ),
              child: Slider(
                value: _grams,
                min: 10,
                max: 500,
                onChanged: (value) {
                  setState(() {
                    _grams = value;
                    _calories = (value * 1.2).round();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                Text('500g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            CapsuleButton(text: 'Add to Diary', onPressed: widget.onNext),
          ],
        ),
      ),
    );
  }
}
