import 'package:flutter/material.dart';

/// Kategori pengeluaran beserta ikon, warna, dan alokasi anggarannya.
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Color deepColor;
  int allocation;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.deepColor,
    this.allocation = 0,
  });
}
