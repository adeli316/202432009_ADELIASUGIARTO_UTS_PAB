import 'package:flutter/material.dart';

import '../models/transaction_item.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/transaction_tile.dart';

class TransactionsTab extends StatefulWidget {
  final String periode;
  final int budget;
  final int totalSpent;
  final List<TransactionItem> transactions;
  final VoidCallback onAdd;
  final VoidCallback onBudget;
  final ValueChanged<TransactionItem> onTapItem;

  const TransactionsTab({
    super.key,
    required this.periode,
    required this.budget,
    required this.totalSpent,
    required this.transactions,
    required this.onAdd,
    required this.onBudget,
    required this.onTapItem,
  });

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  int _filter = 0; // 0 = Semua, 1 = 7 hari terakhir

  List<TransactionItem> get _filtered {
    final all = widget.transactions;
    if (_filter == 0 || all.isEmpty) return all;
    // Acuan 7 hari adalah tanggal transaksi terbaru.
    final terbaru = all.map((t) => t.date).reduce((a, b) => a.isAfter(b) ? a : b);
    final batas = terbaru.subtract(const Duration(days: 6));
    return all.where((t) => !t.date.isBefore(batas)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryCard(
            periode: widget.periode,
            budget: widget.budget,
            spent: widget.totalSpent,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah\nTransaksi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onBudget,
                  icon: const Icon(Icons.tune),
                  label: const Text('Atur Anggaran'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kText,
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(color: kBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat transaksi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              Text(
                '${items.length} transaksi',
                style: const TextStyle(fontSize: 11.5, color: kMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ChoiceChip(
                label: const Text('Semua'),
                selected: _filter == 0,
                onSelected: (_) => setState(() => _filter = 0),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('7 hari terakhir'),
                selected: _filter == 1,
                onSelected: (_) => setState(() => _filter = 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Belum ada transaksi.',
                        style: TextStyle(color: kMuted),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Column(
                        children: [
                          TransactionTile(
                            item: item,
                            onTap: () => widget.onTapItem(item),
                          ),
                          if (index != items.length - 1)
                            const Divider(height: 1, color: kBorder),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String periode;
  final int budget;
  final int spent;

  const _SummaryCard({
    required this.periode,
    required this.budget,
    required this.spent,
  });

  String get _status {
    if (budget <= 0) return 'Belum diatur';
    final rasio = spent / budget;
    if (rasio > 1) return 'Melebihi anggaran';
    if (rasio >= 0.8) return 'Hampir habis';
    return 'Masih aman';
  }

  @override
  Widget build(BuildContext context) {
    final sisa = budget - spent;
    final belumDiatur = budget <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                periode.toUpperCase(),
                style: const TextStyle(color: Colors.white70, fontSize: 11.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      _status,
                      style: const TextStyle(color: Colors.white, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Sisa anggaran bulan ini',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 10),
          if (belumDiatur)
            const Text(
              'Atur anggaran terlebih dahulu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            Text(
              formatRupiah(sisa),
              style: TextStyle(
                color: sisa < 0 ? const Color(0xFFFFB4AB) : Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Stat(label: 'Total anggaran', value: budget)),
              Expanded(child: _Stat(label: 'Total pengeluaran', value: spent)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          formatRupiah(value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
