import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';

/// P42: Pet Dressing Room - Skin switching with real-time preview
/// Click hat → Canvas bear wears hat in real-time
class P42PetDressing extends StatefulWidget {
  final VoidCallback onNext;
  
  const P42PetDressing({super.key, required this.onNext});

  @override
  State<P42PetDressing> createState() => _P42PetDressingState();
}

class _P42PetDressingState extends State<P42PetDressing> {
  // Currently selected skin/accessory
  String _selectedSkin = 'default';
  String? _selectedAccessory;
  
  // Available skins
  final List<_SkinItem> _skins = [
    _SkinItem(id: 'default', name: 'Classic Bear', emoji: '🐻', color: Color(0xFFD4A574)),
    _SkinItem(id: 'panda', name: 'Panda', emoji: '🐼', color: Color(0xFF1A1A1A)),
    _SkinItem(id: 'koala', name: 'Koala', emoji: '🐨', color: Color(0xFF808080)),
    _SkinItem(id: 'polar', name: 'Polar Bear', emoji: '🐻‍❄️', color: Color(0xFFF5F5F5)),
    _SkinItem(id: 'red_panda', name: 'Red Panda', emoji: '🦊', color: Color(0xFFFF6B35)),
  ];
  
  // Available accessories
  final List<_AccessoryItem> _accessories = [
    _AccessoryItem(id: 'none', name: 'None', emoji: '❌', assetKey: null),
    _AccessoryItem(id: 'hat_straw', name: 'Straw Hat', emoji: '👒', assetKey: 'straw_hat'),
    _AccessoryItem(id: 'hat_cowboy', name: 'Cowboy', emoji: '🤠', assetKey: 'cowboy_hat'),
    _AccessoryItem(id: 'hat_party', name: 'Party Hat', emoji: '🎉', assetKey: 'party_hat'),
    _AccessoryItem(id: 'glasses', name: 'Glasses', emoji: '🕶️', assetKey: 'glasses'),
    _AccessoryItem(id: 'bow', name: 'Bow', emoji: '🎀', assetKey: 'bow'),
    _AccessoryItem(id: 'crown', name: 'Crown', emoji: '👑', assetKey: 'crown'),
  ];
  
  // 【CORE】Get bear mood based on skin
  BearMood _getMoodForSkin(String skinId) {
    switch (skinId) {
      case 'panda': return BearMood.heartEyes;
      case 'polar': return BearMood.celebrating;
      case 'koala': return BearMood.sleeping;
      case 'red_panda': return BearMood.rollingEyes;
      default: return BearMood.heartEyes;
    }
  }
  
  // 【CORE】Select skin and update state
  void _selectSkin(String skinId) {
    setState(() {
      _selectedSkin = skinId;
    });
    
    // Persist selection
    final state = Provider.of<OnboardingState>(context, listen: false);
    state.setPetSkin(skinId);
  }
  
  // 【CORE】Select accessory → Canvas bear updates in real-time
  void _selectAccessory(String? accessoryId) {
    setState(() {
      _selectedAccessory = accessoryId == 'none' ? null : accessoryId;
    });
    
    // Persist selection
    final state = Provider.of<OnboardingState>(context, listen: false);
    state.setPetAccessory(_selectedAccessory);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF8E7), Colors.white],
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
                  const Expanded(
                    child: Text(
                      'Pet Dressing Room',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 【CORE】Live preview - Canvas bear updates in real-time
            Expanded(
              flex: 2,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glow
                    Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _skins.firstWhere((s) => s.id == _selectedSkin).color.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    
                    // 【LIVE PREVIEW】Canvas bear with accessories
                    _LiveBearPreview(
                      skinId: _selectedSkin,
                      accessory: _selectedAccessory,
                      mood: _getMoodForSkin(_selectedSkin),
                    ),
                  ],
                ),
              ),
            ),
            
            // Skin selector
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _skins.length,
                itemBuilder: (context, index) {
                  final skin = _skins[index];
                  final isSelected = skin.id == _selectedSkin;
                  
                  return GestureDetector(
                    onTap: () => _selectSkin(skin.id),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? skin.color.withOpacity(0.2) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? skin.color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(skin.emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 4),
                          Text(
                            skin.name,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Accessory selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accessories',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _accessories.map((acc) {
                      final isSelected = acc.id == (_selectedAccessory ?? 'none');
                      return GestureDetector(
                        onTap: () => _selectAccessory(acc.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(acc.emoji, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                acc.name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: _CapsuleButton(
                text: 'Save & Continue',
                onPressed: widget.onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 【CORE】Live Canvas bear preview with accessories
class _LiveBearPreview extends StatelessWidget {
  final String skinId;
  final String? accessory;
  final BearMood mood;
  
  const _LiveBearPreview({
    required this.skinId,
    required this.accessory,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base bear
          CanvasBear(
            mood: mood,
            size: 120,
            animate: true,
            skinId: skinId, // Pass skin to CanvasBear
          ),
          
          // 【ACCESSORY OVERLAY】Real-time accessory preview
          if (accessory != null)
            _AccessoryOverlay(accessoryType: accessory!),
        ],
      ),
    );
  }
}

/// 【ACCESSORY】Overlay widget for real-time accessory display
class _AccessoryOverlay extends StatelessWidget {
  final String accessoryType;
  
  const _AccessoryOverlay({required this.accessoryType});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: _buildAccessory(),
    );
  }
  
  Widget _buildAccessory() {
    switch (accessoryType) {
      case 'hat_straw':
        return const _StrawHat();
      case 'hat_cowboy':
        return const _CowboyHat();
      case 'hat_party':
        return const _PartyHat();
      case 'glasses':
        return Positioned(
          top: 50,
          child: const _Glasses(),
        );
      case 'bow':
        return Positioned(
          top: 5,
          child: const _Bow(),
        );
      case 'crown':
        return Positioned(
          top: -5,
          child: const _Crown(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ===== Accessory Widgets =====
class _StrawHat extends StatelessWidget {
  const _StrawHat();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            color: const Color(0xFFDEB887),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: const Color(0xFFD2691E), width: 2),
          ),
        ),
        Container(
          width: 80,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFDEB887),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _CowboyHat extends StatelessWidget {
  const _CowboyHat();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFF8B4513),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
        ),
        Container(
          width: 90,
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFF8B4513),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
          ),
        ),
      ],
    );
  }
}

class _PartyHat extends StatelessWidget {
  const _PartyHat();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 0,
          height: 0,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 25, color: Colors.transparent),
              right: BorderSide(width: 25, color: Colors.transparent),
              bottom: BorderSide(width: 50, color: Color(0xFFFF69B4)),
            ),
          ),
        ),
        Container(
          width: 50,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFFF69B4),
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}

class _Glasses extends StatelessWidget {
  const _Glasses();
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28, height: 20,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(width: 8, height: 3, color: Colors.black54),
        Container(
          width: 28, height: 20,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _Bow extends StatelessWidget {
  const _Bow();
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20, height: 15,
          decoration: const BoxDecoration(
            color: Color(0xFFFF69B4),
            borderRadius: BorderRadius.vertical(left: Radius.circular(10)),
          ),
        ),
        Container(
          width: 12, height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFFFF1493),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 20, height: 15,
          decoration: const BoxDecoration(
            color: Color(0xFFFF69B4),
            borderRadius: BorderRadius.vertical(right: Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}

class _Crown extends StatelessWidget {
  const _Crown();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 30,
      child: CustomPaint(
        painter: _CrownPainter(),
      ),
    );
  }
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(10, size.height * 0.3)
      ..lineTo(20, size.height * 0.6)
      ..lineTo(30, 0)
      ..lineTo(40, size.height * 0.6)
      ..lineTo(50, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..close();
    
    canvas.drawPath(path, paint);
    
    // Jewels
    final jewelPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(30, size.height * 0.4), 4, jewelPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CapsuleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const _CapsuleButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SkinItem {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  
  _SkinItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class _AccessoryItem {
  final String id;
  final String name;
  final String emoji;
  final String? assetKey;
  
  _AccessoryItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.assetKey,
  });
}
