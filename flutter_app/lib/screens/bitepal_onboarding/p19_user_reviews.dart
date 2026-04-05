import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P19: User Reviews
/// "What our users say"
class P19UserReviews extends StatefulWidget {
  final VoidCallback onNext;
  
  const P19UserReviews({super.key, required this.onNext});
  
  @override
  State<P19UserReviews> createState() => _P19UserReviewsState();
}

class _P19UserReviewsState extends State<P19UserReviews> {
  final _reviews = [
    {
      'name': 'Sarah M.',
      'rating': 5,
      'text': 'Lost 10 lbs in 2 months! The food scanner is amazing.',
      'avatar': Colors.pink,
    },
    {
      'name': 'James K.',
      'rating': 5,
      'text': 'Best calorie tracking app. The AI is so accurate!',
      'avatar': Colors.blue,
    },
    {
      'name': 'Emily R.',
      'rating': 5,
      'text': 'Love the virtual pet feature. Keeps me motivated!',
      'avatar': Colors.green,
    },
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
              'What our users say',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'average rating',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: _reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: review['avatar'] as Color,
                              child: Text(
                                (review['name'] as String)[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['name'] as String,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      review['rating'] as int,
                                      (_) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${review['text']}"',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            CapsuleButton(
              text: 'Continue >',
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
