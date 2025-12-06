import 'package:flutter/material.dart';

class VedicBackground extends StatelessWidget {
  final Widget child;

  const VedicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(child: child),
    );
  }
}
