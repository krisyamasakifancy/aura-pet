import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ScreenName extends StatelessWidget {
  const ScreenName({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ScreenName')),
      body: const Center(child: Text('ScreenName')),
    );
  }
}
