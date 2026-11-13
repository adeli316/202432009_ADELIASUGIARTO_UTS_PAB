import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/transaction.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'category_badge.dart';
import 'soft_card.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cat = AppState.instance.categoryById(transaction.categoryId);
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          CategoryBadge(category: cat),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cat.name} · ${tanggalSingkat(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '-${rupiah(transaction.amount)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.cottonPinkDeep,
            ),
          ),
        ],
      ),
    );
  }
}
