import 'package:flutter/material.dart';

/// P36: 帮助反馈
class P36HelpScreen extends StatelessWidget {
  const P36HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Emoji
              const Text(
                '❓',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 32),
              // 小熊
              _buildPet(),
              const SizedBox(height: 32),
              // 标题
              Text(
                '帮助反馈',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              // 副标题
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF636E72),
                ),
              ),
              const Spacer(),
              // 页面标识
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'P36/44',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF636E72),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPet() {
    final isSleeping = 'hearting' == 'sleeping';
    final isDiving = 'hearting' == 'diving';
    final isCelebrating = 'hearting' == 'celebrating';
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // 光晕
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x40FF8BA0),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
        ),
        // 身体
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFB8C5D0),
                const Color(0xFF8E9EAB),
              ],
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
              // 睡帽
              if (isSleeping)
                Positioned(
                  top: -15,
                  left: 45,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C63FF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      const Text('⭐', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              // ZZZ
              if (isSleeping)
                const Positioned(
                  top: 5,
                  right: 20,
                  child: Text('💤', style: TextStyle(fontSize: 20)),
                ),
              // 潜水镜
              if (isDiving) ...[
                Positioned(
                  top: 35,
                  left: 25,
                  child: Container(
                    width: 22,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 25,
                  child: Container(
                    width: 22,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
              // 皇冠
              if (isCelebrating)
                const Positioned(
                  top: -20,
                  left: 40,
                  child: Text('👑', style: TextStyle(fontSize: 32)),
                ),
              // 眼睛
              Positioned(
                top: 48,
                left: 42,
                child: isSleeping
                    ? Container(width: 18, height: 3, color: const Color(0xFF2D3436))
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D3436),
                          shape: BoxShape.circle,
                        ),
                        child: const Stack(
                          children: [
                            Positioned(top: 2, left: 2, child: SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)))),
                          ],
                        ),
                      ),
              ),
              Positioned(
                top: 48,
                right: 42,
                child: isSleeping
                    ? Container(width: 18, height: 3, color: const Color(0xFF2D3436))
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D3436),
                          shape: BoxShape.circle,
                        ),
                        child: const Stack(
                          children: [
                            Positioned(top: 2, left: 2, child: SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)))),
                          ],
                        ),
                      ),
              ),
              // 腮红
              Positioned(
                bottom: 45,
                left: 26,
                child: Container(
                  width: 14,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB5B5).withValues(alpha: isSleeping || isDiving ? 0.8 : 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                bottom: 45,
                right: 26,
                child: Container(
                  width: 14,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB5B5).withValues(alpha: isSleeping || isDiving ? 0.8 : 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // 嘴巴
              Positioned(
                bottom: 30,
                left: 62,
                child: Container(
                  width: 16,
                  height: isDiving ? 12 : 8,
                  decoration: BoxDecoration(
                    border: const Border(bottom: BorderSide(color: Color(0xFF2D3436), width: 2)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isDiving ? 12 : 8), bottomRight: Radius.circular(isDiving ? 12 : 8)),
                  ),
                ),
              ),
              // 比心
              if (!isSleeping && !isDiving)
                Positioned(
                  bottom: 20,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8BA0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('💕', style: TextStyle(fontSize: 20)),
                  ),
                ),
              // 泡泡
              if (isDiving)
                const Positioned(
                  bottom: 10,
                  right: 5,
                  child: Text('🫧', style: TextStyle(fontSize: 16)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
