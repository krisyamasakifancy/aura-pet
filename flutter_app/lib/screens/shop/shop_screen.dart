import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utils/theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      '小熊商店',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Coins display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AuraPetTheme.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: AuraPetTheme.shadowSm,
                    ),
                    child: Consumer<PetProvider>(
                      builder: (context, pet, _) {
                        return Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              '${pet.state.coins}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF8B6914),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Shop grid
            Expanded(
              child: Consumer2<ShopProvider, PetProvider>(
                builder: (context, shop, pet, _) {
                  final ownedIds = pet.state.accessories.map((a) => a.name.toLowerCase()).toSet();
                  
                  return GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: shop.allItems.length,
                    itemBuilder: (context, index) {
                      final item = shop.allItems[index];
                      final isOwned = ownedIds.contains(item.id);
                      return _ShopItemCard(
                        item: item,
                        isOwned: isOwned,
                        onBuy: () => _buyItem(context, item, pet),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyItem(BuildContext context, ShopItem item, PetProvider pet) {
    HapticFeedback.mediumImpact();

    if (pet.state.coins >= item.price) {
      final accessoryMap = {
        'hat': PetAccessory.hat,
        'bow': PetAccessory.bow,
        'glasses': PetAccessory.glasses,
        'crown': PetAccessory.crown,
        'backpack': PetAccessory.backpack,
        'scarf': PetAccessory.scarf,
        'wings': PetAccessory.backpack,
        'halo': PetAccessory.crown,
      };

      final accessory = accessoryMap[item.id] ?? PetAccessory.scarf;

      if (pet.buyAccessory(accessory, item.price)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('购买成功！${item.emoji}'),
            backgroundColor: AuraPetTheme.accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('金币不够哦 💰'),
          backgroundColor: AuraPetTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool isOwned;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.item,
    required this.isOwned,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isOwned ? null : onBuy,
      child: Container(
        decoration: BoxDecoration(
          color: isOwned ? const Color(0xFFFFF5E8) : AuraPetTheme.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AuraPetTheme.bgPink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(item.emoji, style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AuraPetTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AuraPetTheme.secondary, Color(0xFFFFE066)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      isOwned ? '已拥有' : '🪙 ${item.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B6914),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Badges
            if (item.isHot)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AuraPetTheme.danger,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '热门',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (item.isNew)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AuraPetTheme.water,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '新',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (isOwned)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AuraPetTheme.accent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '已拥有',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
