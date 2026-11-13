import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'category_badge.dart';
import 'soft_card.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final spent = state.spentOf(category.id);
    final remaining = state.remainingOf(category.id);
    final over = remaining < 0;
    final ratio = category.allocation <= 0
        ? (spent > 0 ? 1.0 : 0.0)
        : (spent / category.allocation).clamp(0.0, 1.0);

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CategoryBadge(category: category),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Alokasi ${rupiah(category.allocation)}',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSoft),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSoft),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 9,
              backgroundColor: category.color.withOpacity(0.6),
              valueColor: AlwaysStoppedAnimation<Color>(
                over ? AppColors.danger : category.deepColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terpakai ${rupiah(spent)}',
                style: const TextStyle(fontSize: 12.5),
              ),
              Text(
                'Sisa ${rupiah(remaining)}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: over ? AppColors.danger : AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
