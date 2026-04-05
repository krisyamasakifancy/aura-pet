import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P08: Channel Survey
/// "How did you hear about us?"
class P08ChannelSurvey extends StatefulWidget {
  final VoidCallback onNext;
  
  const P08ChannelSurvey({super.key, required this.onNext});
  
  @override
  State<P08ChannelSurvey> createState() => _P08ChannelSurveyState();
}

class _P08ChannelSurveyState extends State<P08ChannelSurvey> {
  String? _selectedChannel;
  
  final _channels = [
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
    {'name': 'TikTok', 'icon': Icons.music_note, 'color': Colors.black},
    {'name': 'YouTube', 'icon': Icons.play_circle_filled, 'color': Colors.red},
    {'name': 'Friend', 'icon': Icons.person, 'color': Colors.blue},
    {'name': 'Google', 'icon': Icons.search, 'color': Colors.green},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'How did you hear\nabout us?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _channels.length,
                itemBuilder: (context, index) {
                  final channel = _channels[index];
                  final isSelected = _selectedChannel == channel['name'];
                  
                  return SelectableCard(
                    title: channel['name'] as String,
                    icon: channel['icon'] as IconData,
                    iconColor: channel['color'] as Color,
                    selected: isSelected,
                    onTap: () {
                      setState(() => _selectedChannel = channel['name'] as String);
                      context.read<OnboardingState>().setChannel(channel['name'] as String);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next >',
              onPressed: _selectedChannel != null ? widget.onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}
