import 'package:flutter/material.dart';
import 'pet_provider.dart';

class ShopItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final bool isNew;
  final bool isHot;
  final ShopItemCategory category;

  const ShopItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.isNew = false,
    this.isHot = false,
    this.category = ShopItemCategory.decoration,
  });
}

enum ShopItemCategory { decoration, background, effect }

class ShopProvider extends ChangeNotifier {
  static const List<ShopItem> _shopItems = [
    ShopItem(id: 'hat', name: '绅士帽子', emoji: '🎩', price: 50, isHot: true),
    ShopItem(id: 'bow', name: '蝴蝶结', emoji: '🎀', price: 40, isNew: true),
    ShopItem(id: 'glasses', name: '墨镜', emoji: '🕶️', price: 60),
    ShopItem(id: 'crown', name: '皇冠', emoji: '👑', price: 100),
    ShopItem(id: 'backpack', name: '背包', emoji: '🎒', price: 80),
    ShopItem(id: 'scarf', name: '围巾', emoji: '🧣', price: 30),
    ShopItem(id: 'wings', name: '天使翅膀', emoji: '🪽', price: 150, isNew: true),
    ShopItem(id: 'halo', name: '天使光环', emoji: '😇', price: 120),
  ];

  List<ShopItem> get allItems => _shopItems;

  ShopItem? getItemById(String id) {
    try {
      return _shopItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ShopItem> get newItems => _shopItems.where((item) => item.isNew).toList();
  List<ShopItem> get hotItems => _shopItems.where((item) => item.isHot).toList();
}
