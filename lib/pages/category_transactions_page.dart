import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/category_badge.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_detail_page.dart';

/// Halaman Transaksi per Kategori.
class CategoryTransactionsPage extends StatelessWidget {
  final Category category;

  const CategoryTransactionsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final state = AppState.instance;
          final items = state.transactionsOf(category.id);
          final remaining = state.remainingOf(category.id);
          final over = remaining < 0;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: items.isEmpty ? 2 : items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        CategoryBadge(category: category, size: 64),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alokasi ${rupiah(category.allocation)}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text('Terpakai ${rupiah(state.spentOf(category.id))}'),
                              const SizedBox(height: 4),
                              Text(
                                'Sisa ${rupiah(remaining)}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: over ? AppColors.danger : AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'Belum ada transaksi di kategori ini.',
                      style: TextStyle(color: AppColors.textSoft),
                    ),
                  ),
                );
              }
              final t = items[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TransactionTile(
                  transaction: t,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailPage(transaction: t),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
