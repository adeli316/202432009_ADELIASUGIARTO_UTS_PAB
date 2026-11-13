import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../theme/app_colors.dart';

/// Penyimpanan data sementara (in-memory). Data hilang saat aplikasi ditutup.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  int _nextId = 100;

  int monthlyBudget = 1500000;

  final List<Category> categories = [
    Category(
      id: 'makan',
      name: 'Makan',
      icon: Icons.ramen_dining_rounded,
      color: AppColors.softYellow,
      deepColor: AppColors.softYellowDeep,
      allocation: 600000,
    ),
    Category(
      id: 'transport',
      name: 'Transportasi',
      icon: Icons.directions_bus_rounded,
      color: AppColors.babyBlue,
      deepColor: AppColors.babyBlueDeep,
      allocation: 200000,
    ),
    Category(
      id: 'kuliah',
      name: 'Kebutuhan Kuliah',
      icon: Icons.menu_book_rounded,
      color: AppColors.mint,
      deepColor: AppColors.mintDeep,
      allocation: 250000,
    ),
    Category(
      id: 'hiburan',
      name: 'Hiburan',
      icon: Icons.sports_esports_rounded,
      color: AppColors.cottonPink,
      deepColor: AppColors.cottonPinkDeep,
      allocation: 150000,
    ),
    Category(
      id: 'darurat',
      name: 'Dana Darurat',
      icon: Icons.health_and_safety_rounded,
      color: AppColors.peach,
      deepColor: AppColors.peachDeep,
      allocation: 150000,
    ),
    Category(
      id: 'dingin',
      name: 'Uang Dingin',
      icon: Icons.savings_rounded,
      color: AppColors.lavender,
      deepColor: AppColors.lavenderDeep,
      allocation: 100000,
    ),
  ];

  final List<Transaction> _transactions = [
    Transaction(id: 1, title: 'Nasi goreng kantin', categoryId: 'makan', amount: 18000, date: DateTime(2026, 11, 13), note: 'Makan siang setelah kelas PAB'),
    Transaction(id: 2, title: 'Ojek online ke kampus', categoryId: 'transport', amount: 15000, date: DateTime(2026, 11, 13), note: 'Berangkat pagi'),
    Transaction(id: 3, title: 'Fotokopi modul', categoryId: 'kuliah', amount: 12000, date: DateTime(2026, 11, 12), note: 'Modul praktikum Flutter'),
    Transaction(id: 4, title: 'Nonton bioskop', categoryId: 'hiburan', amount: 55000, date: DateTime(2026, 11, 12), note: 'Nonton bareng teman kelas'),
    Transaction(id: 5, title: 'Kopi susu', categoryId: 'makan', amount: 20000, date: DateTime(2026, 11, 11)),
    Transaction(id: 6, title: 'Top up e-money', categoryId: 'transport', amount: 50000, date: DateTime(2026, 11, 10), note: 'Untuk naik KRL'),
    Transaction(id: 7, title: 'Buku referensi Dart', categoryId: 'kuliah', amount: 85000, date: DateTime(2026, 11, 9)),
    Transaction(id: 8, title: 'Voucher game', categoryId: 'hiburan', amount: 120000, date: DateTime(2026, 11, 8), note: 'Lebih dari alokasi, sisa jadi merah'),
    Transaction(id: 9, title: 'Ayam geprek', categoryId: 'makan', amount: 25000, date: DateTime(2026, 11, 8)),
    Transaction(id: 10, title: 'Tabung dana darurat', categoryId: 'darurat', amount: 100000, date: DateTime(2026, 11, 5), note: 'Setoran awal bulan'),
    Transaction(id: 11, title: 'Beli reksa dana', categoryId: 'dingin', amount: 50000, date: DateTime(2026, 11, 5), note: 'Uang yang tidak disentuh dulu'),
  ];

  /// Daftar transaksi, terbaru di atas.
  List<Transaction> get transactions {
    final list = List<Transaction>.from(_transactions);
    list.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.id.compareTo(a.id);
    });
    return list;
  }

  Category categoryById(String id) =>
      categories.firstWhere((c) => c.id == id, orElse: () => categories.first);

  List<Transaction> transactionsOf(String categoryId) =>
      transactions.where((t) => t.categoryId == categoryId).toList();

  int get totalSpent => _transactions.fold(0, (sum, t) => sum + t.amount);

  int get remainingBudget => monthlyBudget - totalSpent;

  int get totalAllocated => categories.fold(0, (sum, c) => sum + c.allocation);

  int get unallocated => monthlyBudget - totalAllocated;

  int spentOf(String categoryId) => _transactions
      .where((t) => t.categoryId == categoryId)
      .fold(0, (sum, t) => sum + t.amount);

  int remainingOf(String categoryId) =>
      categoryById(categoryId).allocation - spentOf(categoryId);

  void addTransaction({
    required String title,
    required String categoryId,
    required int amount,
    required DateTime date,
    String note = '',
  }) {
    _transactions.add(Transaction(
      id: _nextId++,
      title: title,
      categoryId: categoryId,
      amount: amount,
      date: date,
      note: note,
    ));
    notifyListeners();
  }

  // ---- Tambahan: kategori buatan pengguna ----

  static const List<List<Color>> _palette = [
    [AppColors.softYellow, AppColors.softYellowDeep],
    [AppColors.babyBlue, AppColors.babyBlueDeep],
    [AppColors.mint, AppColors.mintDeep],
    [AppColors.cottonPink, AppColors.cottonPinkDeep],
    [AppColors.peach, AppColors.peachDeep],
    [AppColors.lavender, AppColors.lavenderDeep],
  ];

  /// Tambah kategori baru dari input pengguna. Jika nama sudah ada, pakai yang lama.
  Category addCategory(String name) {
    final clean = name.trim();
    final existing = categories.where(
      (c) => c.name.toLowerCase() == clean.toLowerCase(),
    );
    if (existing.isNotEmpty) return existing.first;

    final colors = _palette[categories.length % _palette.length];
    final cat = Category(
      id: 'custom_${_nextId++}',
      name: clean,
      icon: Icons.label_rounded,
      color: colors[0],
      deepColor: colors[1],
    );
    categories.add(cat);
    notifyListeners();
    return cat;
  }

  // ---- Tambahan: anggaran per bulan dan tahun ----

  final Map<String, int> _budgetByMonth = {};
  final Map<String, Map<String, int>> _allocByMonth = {};

  String _key(int year, int month) => '$year-$month';

  bool _isCurrentMonth(int year, int month) {
    final now = DateTime.now();
    return now.year == year && now.month == month;
  }

  /// Anggaran bulan tertentu. Bulan yang belum diatur memakai anggaran saat ini.
  int budgetFor(int year, int month) =>
      _budgetByMonth[_key(year, month)] ?? monthlyBudget;

  /// Alokasi kategori pada bulan tertentu.
  int allocationFor(String categoryId, int year, int month) {
    final saved = _allocByMonth[_key(year, month)];
    if (saved != null) return saved[categoryId] ?? 0;
    return categoryById(categoryId).allocation;
  }

  void saveBudgetFor(
    int year,
    int month,
    int budget,
    Map<String, int> allocations,
  ) {
    _budgetByMonth[_key(year, month)] = budget;
    _allocByMonth[_key(year, month)] = Map<String, int>.from(allocations);
    if (_isCurrentMonth(year, month)) {
      saveBudget(budget, allocations);
      return;
    }
    notifyListeners();
  }

  // ---- Tambahan: analisis pengeluaran ----

  /// Total pengeluaran tiap bulan (indeks 0 = Januari) pada tahun tertentu.
  List<int> monthlySpending(int year) {
    final result = List<int>.filled(12, 0);
    for (final t in _transactions) {
      if (t.date.year == year) result[t.date.month - 1] += t.amount;
    }
    return result;
  }

  /// Daftar tahun yang punya transaksi, ditambah tahun ini.
  List<int> get analysisYears {
    final years = {DateTime.now().year, ..._transactions.map((t) => t.date.year)};
    return years.toList()..sort();
  }

  void saveBudget(int budget, Map<String, int> allocations) {
    monthlyBudget = budget;
    for (final c in categories) {
      c.allocation = allocations[c.id] ?? 0;
    }
    notifyListeners();
  }
}
