import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P42PetDressing extends StatefulWidget {
  final VoidCallback onNext;
  
  const P42PetDressing({super.key, required this.onNext});

  @override
  State<P42PetDressing> createState() => _P42PetDressingState();
}

class _P42PetDressingState extends State<P42PetDressing> {
  int _selectedSkin = 0;
  
  final skins = [
    {'name': 'Default', 'color': Colors.grey},
    {'name': 'Monet', 'color': Colors.pink},
    {'name': 'Forest', 'color': Colors.green},
    {'name': 'Ocean', 'color': Colors.blue},
    {'name': 'Sunset', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aura-Pet\nDressing Room', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28, height: 1.2)),
            const SizedBox(height: 8),
            Text("Choose your pet's style", style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [(skins[_selectedSkin]['color'] as Color).withOpacity(0.3), Colors.transparent]),
                    ),
                  ),
                  CanvasBear(mood: BearMood.heartEyes, size: 180, animate: true),
                  Positioned(
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: skins.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final skin = skins[index];
                  final isSelected = _selectedSkin == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSkin = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? (skin['color'] as Color).withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? skin['color'] as Color : Colors.grey.shade200, width: isSelected ? 2 : 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: skin['color'] as Color, shape: BoxShape.circle),
                          ),
                          const SizedBox(height: 4),
                          Text(skin['name'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: isSelected ? skin['color'] as Color : Colors.grey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            CapsuleButton(text: 'Apply & Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
