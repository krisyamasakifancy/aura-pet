import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P11: Gender Selection
/// "What's your gender?"
class P11GenderSelection extends StatefulWidget {
  final VoidCallback onNext;
  
  const P11GenderSelection({super.key, required this.onNext});
  
  @override
  State<P11GenderSelection> createState() => _P11GenderSelectionState();
}

class _P11GenderSelectionState extends State<P11GenderSelection> {
  String? _selectedGender;
  
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
              "What's your\ngender?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _GenderCard(
                    gender: 'Female',
                    icon: Icons.female,
                    color: Colors.pink.shade300,
                    selected: _selectedGender == 'female',
                    onTap: () {
                      setState(() => _selectedGender = 'female');
                      context.read<OnboardingState>().setGender('female');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GenderCard(
                    gender: 'Male',
                    icon: Icons.male,
                    color: Colors.blue.shade300,
                    selected: _selectedGender == 'male',
                    onTap: () {
                      setState(() => _selectedGender = 'male');
                      context.read<OnboardingState>().setGender('male');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() => _selectedGender = 'other');
                context.read<OnboardingState>().setGender('other');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: _selectedGender == 'other' 
                      ? const Color(0xFFEDE7F6) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedGender == 'other' 
                        ? const Color(0xFF9575CD) 
                        : Colors.grey.shade200,
                    width: _selectedGender == 'other' ? 2 : 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Non-binary',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            CapsuleButton(
              text: 'Next >',
              onPressed: _selectedGender != null ? widget.onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String gender;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  
  const _GenderCard({
    required this.gender,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.grey.shade200,
            width: selected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 60, color: selected ? color : Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              gender,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                fontSize: 16,
                color: selected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
