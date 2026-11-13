import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/transaction.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/category_badge.dart';
import '../widgets/soft_card.dart';

/// Halaman Detail Transaksi.
class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final cat = state.categoryById(transaction.categoryId);
    final remaining = state.remainingOf(cat.id);
    final over = remaining < 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cat.color, Colors.white],
              ),
              border: Border.all(color: cat.color, width: 2),
            ),
            child: Column(
              children: [
                CategoryBadge(category: cat, size: 84),
                const SizedBox(height: 14),
                Text(
                  transaction.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  '-${rupiah(transaction.amount)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.cottonPinkDeep,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _Row(label: 'Kategori', value: cat.name),
                const _Divider(),
                _Row(label: 'Tanggal', value: tanggalLengkap(transaction.date)),
                const _Divider(),
                _Row(
                  label: 'Catatan',
                  value: transaction.note.isEmpty ? '-' : transaction.note,
                ),
                const _Divider(),
                _Row(
                  label: 'Sisa kategori',
                  value: rupiah(remaining),
                  valueColor: over ? AppColors.danger : AppColors.text,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _Row({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(color: AppColors.textSoft)),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w700, color: valueColor),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: AppColors.babyBlue.withOpacity(0.6)),
      );
}
