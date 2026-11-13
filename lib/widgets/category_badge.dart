import 'package:flutter/material.dart';
import '../models/category.dart';

/// Lingkaran pastel berisi ikon kategori.
class CategoryBadge extends StatelessWidget {
  final Category category;
  final double size;

  const CategoryBadge({super.key, required this.category, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: category.deepColor.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(category.icon, color: category.deepColor, size: size * 0.5),
    );
  }
}
