import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P08: Channel Survey
/// "How did you hear about us?"
class P08ChannelSurvey extends StatelessWidget {
  final VoidCallback onNext;
  
  const P08ChannelSurvey({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    final channels = [
      {'name': 'TikTok', 'icon': Icons.music_note},
      {'name': 'Instagram', 'icon': Icons.camera_alt},
      {'name': 'YouTube', 'icon': Icons.play_circle_fill},
      {'name': 'Google', 'icon': Icons.search},
      {'name': 'Friends', 'icon': Icons.people},
      {'name': 'App Store', 'icon': Icons.shopping_bag},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'How did you hear\nabout us?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select one option',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final isSelected = state.selectedChannel == channel['name'];
                  
                  return GestureDetector(
                    onTap: () => state.setChannel(channel['name'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            channel['icon'] as IconData,
                            size: 28,
                            color: isSelected 
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            channel['name'] as String,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isSelected 
                                  ? const Color(0xFF4CAF50)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.curious,
                  size: 50,
                  animate: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "We're curious! How did you find us? 🤔",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next',
              onPressed: state.selectedChannel != null ? onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}
