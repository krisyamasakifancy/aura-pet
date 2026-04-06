import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P19: User Reviews
class P19UserReviews extends StatefulWidget {
  final VoidCallback onNext;
  
  const P19UserReviews({super.key, required this.onNext});

  @override
  State<P19UserReviews> createState() => _P19UserReviewsState();
}

class _P19UserReviewsState extends State<P19UserReviews> {
  final _reviews = [
    {'name': 'Sarah M.', 'text': 'Lost 10kg in 3 months! Best app ever!', 'rating': 5},
    {'name': 'John D.', 'text': 'The virtual pet keeps me motivated daily!', 'rating': 5},
    {'name': 'Emily R.', 'text': 'Finally understand my eating habits.', 'rating': 4},
  ];
  
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final review = _reviews[_currentIndex];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'What our users say',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % _reviews.length;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Stars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          review['rating'] as int,
                          (_) => const Icon(Icons.star, color: Colors.amber, size: 28),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '"${review['text']}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        review['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _reviews.asMap().entries.map((e) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: e.key == _currentIndex ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: e.key == _currentIndex ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const CanvasBear(mood: BearMood.heartEyes, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Join 2M+ happy users! ⭐", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.amber)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: widget.onNext),
          ],
        ),
      ),
    );
  }
}
