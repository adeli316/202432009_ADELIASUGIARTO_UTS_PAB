import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/transaction_item.dart';

/// Bulan anggaran yang sedang dipakai.
final DateTime kPeriode = DateTime(2026, 2, 1);

const int kAnggaranAwal = 1500000;

const List<Category> kCategories = [
  Category(name: 'Makan', icon: Icons.restaurant),
  Category(name: 'Transportasi', icon: Icons.two_wheeler),
  Category(name: 'Kebutuhan Kuliah', icon: Icons.menu_book_outlined),
  Category(name: 'Hiburan', icon: Icons.movie_outlined),
  Category(name: 'Dana Darurat', icon: Icons.shield_outlined),
  Category(name: 'Uang Dingin', icon: Icons.savings_outlined),
];

Category categoryByName(String name) {
  return kCategories.firstWhere(
    (c) => c.name == name,
    orElse: () => kCategories.first,
  );
}

Map<String, int> alokasiAwal() => {
      'Makan': 500000,
      'Transportasi': 200000,
      'Kebutuhan Kuliah': 250000,
      'Hiburan': 150000,
      'Dana Darurat': 250000,
      'Uang Dingin': 150000,
    };

List<TransactionItem> transaksiAwal() => [
      TransactionItem(
        title: 'Makan siang di kantin',
        category: 'Makan',
        amount: 18000,
        date: DateTime(2026, 2, 12),
        note: 'Nasi ayam dan es teh',
      ),
      TransactionItem(
        title: 'Ojek online ke kampus',
        category: 'Transportasi',
        amount: 12500,
        date: DateTime(2026, 2, 12),
        note: 'Berangkat kuliah pagi',
      ),
      TransactionItem(
        title: 'Beli buku Statistika',
        category: 'Kebutuhan Kuliah',
        amount: 96000,
        date: DateTime(2026, 2, 11),
        note: 'Buku wajib mata kuliah Statistika',
      ),
      TransactionItem(
        title: 'Nonton film akhir pekan',
        category: 'Hiburan',
        amount: 45000,
        date: DateTime(2026, 2, 10),
        note: 'Nonton bersama teman kelas',
      ),
      TransactionItem(
        title: 'Isi tabungan darurat',
        category: 'Dana Darurat',
        amount: 150000,
        date: DateTime(2026, 2, 9),
        note: 'Setoran bulanan',
      ),
      TransactionItem(
        title: 'Langganan aplikasi musik',
        category: 'Hiburan',
        amount: 54000,
        date: DateTime(2026, 2, 8),
        note: 'Paket pelajar bulanan',
      ),
      TransactionItem(
        title: 'Makan malam bersama teman',
        category: 'Makan',
        amount: 62000,
        date: DateTime(2026, 2, 7),
        note: 'Patungan makan malam',
      ),
      TransactionItem(
        title: 'Parkir dan bensin motor',
        category: 'Transportasi',
        amount: 28000,
        date: DateTime(2026, 2, 6),
        note: 'Isi bensin dan bayar parkir kampus',
      ),
    ];
