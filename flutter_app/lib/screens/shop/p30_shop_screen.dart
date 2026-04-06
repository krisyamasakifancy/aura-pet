import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 商店 P30 - 实时换装预览 + 呼吸同步缩放
class ShopP30Screen extends StatefulWidget {
  const ShopP30Screen({super.key});

  @override
  State<ShopP30Screen> createState() => _ShopP30ScreenState();
}

class _ShopP30ScreenState extends State<ShopP30Screen>
    with TickerProviderStateMixin {
  // 当前选中的配件
  String? _selectedAccessory;
  final List<Map<String, dynamic>> _accessories = [
    {'id': 'sunglasses', 'name': 'Sunglasses', 'emoji': '🕶️', 'price': 100, 'color': Color(0xFF2D3436)},
    {'id': 'crown', 'name': 'Crown', 'emoji': '👑', 'price': 500, 'color': Color(0xFFFFD700)},
    {'id': 'bow', 'name': 'Bow', 'emoji': '🎀', 'price': 80, 'color': Color(0xFFFF69B4)},
    {'id': 'hat', 'name': 'Top Hat', 'emoji': '🎩', 'price': 200, 'color': Color(0xFF2D3436)},
    {'id': 'scarf', 'name': 'Scarf', 'emoji': '🧣', 'price': 150, 'color': Color(0xFFFF6B6B)},
    {'id': 'cape', 'name': 'Cape', 'emoji': '🦸', 'price': 300, 'color': Color(0xFF9B59B6)},
    {'id': 'wings', 'name': 'Wings', 'emoji': '🪽', 'price': 800, 'color': Color(0xFFE0E0E0)},
    {'id': 'halo', 'name': 'Halo', 'emoji': '😇', 'price': 1000, 'color': Color(0xFFFFD700)},
  ];
  
  late AnimationController _breathController;
  late AnimationController _sparkleController;
  late Animation<double> _breathAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _breathAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _sparkleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_sparkleController);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8E1),
              Color(0xFFFFE4B5),
              Color(0xFFF5DEB3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildPetPreview(),
              _buildAccessoryGrid(),
              _buildBuyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Pet Shop',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('🪙', style: TextStyle(fontSize: 16)),
                SizedBox(width: 4),
                Text(
                  '2,500',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB8860B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetPreview() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathAnimation, _sparkleAnimation]),
      builder: (context, child) {
        return Container(
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFFFFD700).withOpacity(0.2 * _sparkleAnimation.value),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 光环效果
              ...List.generate(3, (index) {
                final delay = index * 0.3;
                final offset = (_sparkleAnimation.value + delay) % 1.0;
                return Positioned(
                  top: 20 + offset * 30,
                  left: 30 + index * 40,
                  child: Opacity(
                    opacity: (1 - offset) * 0.6,
                    child: Transform.scale(
                      scale: 0.5 + offset * 0.5,
                      child: const Text('✨', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              }),
              
              // 小熊主体 (呼吸同步缩放)
              Transform.scale(
                scale: _breathAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Aura 光晕
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.3 * _sparkleAnimation.value),
                            blurRadius: 40,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    
                    // 小熊身体
                    Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 脸部
                          Positioned(
                            top: 30,
                            left: 18,
                            child: Container(
                              width: 104,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                  bottomLeft: Radius.circular(45),
                                  bottomRight: Radius.circular(45),
                                ),
                              ),
                            ),
                          ),
                          
                          // 眼睛
                          Positioned(
                            top: 48,
                            left: 42,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D3436),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 2,
                                    left: 2,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 48,
                            right: 42,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D3436),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 2,
                                    left: 2,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // 腮红
                          Positioned(
                            bottom: 45,
                            left: 26,
                            child: Container(
                              width: 16,
                              height: 9,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5B5).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 45,
                            right: 26,
                            child: Container(
                              width: 16,
                              height: 9,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5B5).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                          
                          // 嘴巴
                          Positioned(
                            bottom: 30,
                            left: 62,
                            child: Container(
                              width: 16,
                              height: 10,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF2D3436), width: 2),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          
                          // 当前装备显示
                          if (_selectedAccessory != null) _buildEquippedAccessory(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEquippedAccessory() {
    final accessory = _accessories.firstWhere(
      (a) => a['id'] == _selectedAccessory,
      orElse: () => {},
    );
    
    if (accessory.isEmpty) return const SizedBox();
    
    // 根据配件类型放置在不同位置
    Offset position;
    double scale = 1.0;
    
    switch (accessory['id']) {
      case 'sunglasses':
        position = const Offset(0, 0);
        scale = 0.8;
        break;
      case 'crown':
        position = const Offset(0, -70);
        scale = 1.2;
        break;
      case 'bow':
        position = const Offset(50, -20);
        scale = 0.8;
        break;
      case 'hat':
        position = const Offset(0, -60);
        scale = 1.0;
        break;
      case 'scarf':
        position = const Offset(0, 55);
        scale = 1.2;
        break;
      case 'cape':
        position = const Offset(0, 40);
        scale = 1.5;
        break;
      case 'wings':
        position = const Offset(0, 10);
        scale = 1.3;
        break;
      case 'halo':
        position = const Offset(0, -80);
        scale = 1.0;
        break;
      default:
        position = Offset.zero;
    }
    
    return Positioned(
      top: 70 - position.dy,
      left: 70 + position.dx,
      child: Transform.scale(
        scale: scale * _breathAnimation.value,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: (accessory['color'] as Color).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Text(
            accessory['emoji'] as String,
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessoryGrid() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: _accessories.length,
          itemBuilder: (context, index) {
            final accessory = _accessories[index];
            final isSelected = _selectedAccessory == accessory['id'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAccessory = isSelected ? null : accessory['id'];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (accessory['color'] as Color).withOpacity(0.2)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: accessory['color'] as Color, width: 2)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (accessory['color'] as Color).withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accessory['emoji'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accessory['name'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? accessory['color'] as Color
                            : const Color(0xFF636E72),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 2),
                        Text(
                          '${accessory['price']}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? accessory['color'] as Color
                                : const Color(0xFFB8860B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBuyButton() {
    final selectedAccessory = _selectedAccessory != null
        ? _accessories.firstWhere((a) => a['id'] == _selectedAccessory)
        : null;
    
    final canAfford = selectedAccessory != null
        ? (2500 - (selectedAccessory['price'] as int)) >= 0
        : false;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: selectedAccessory != null
              ? () {
                  if (canAfford) {
                    _showPurchaseDialog(selectedAccessory);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canAfford
                ? const Color(0xFFFFD700)
                : const Color(0xFFB2BEC3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedAccessory != null
                    ? 'Buy ${selectedAccessory['emoji']} for 🪙${selectedAccessory['price']}'
                    : 'Select an accessory',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: canAfford ? const Color(0xFF2D3436) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(Map accessory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              '${accessory['emoji']} ${accessory['name']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Successfully equipped!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedAccessory = null);
            }),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
