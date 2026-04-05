import 'package:flutter/material.dart';
import '../utils/theme.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AuraPetTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AuraPetTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionItem {
  final String icon;
  final String label;
  final Color bgColor;
  final VoidCallback? onTap;

  const ActionItem({
    required this.icon,
    required this.label,
    required this.bgColor,
    this.onTap,
  });
}

class ActionGrid extends StatelessWidget {
  final List<ActionItem> actions;

  const ActionGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return GestureDetector(
          onTap: action.onTap,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: action.bgColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AuraPetTheme.shadowSm,
                ),
                child: Center(
                  child: Text(action.icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AuraPetTheme.textDark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AuraPetTheme.shadowMd,
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AuraPetTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AuraPetTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
