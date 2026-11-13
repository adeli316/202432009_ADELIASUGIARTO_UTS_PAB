import 'package:flutter/material.dart';

import '../theme.dart';

class IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;

  const IconBadge({super.key, required this.icon, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: kGreenSoft, shape: BoxShape.circle),
      child: Icon(icon, color: kGreen, size: size * 0.5),
    );
  }
}
