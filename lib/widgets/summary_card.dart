import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

/// Kartu ringkasan: anggaran, pengeluaran, dan sisa.
class SummaryCard extends StatelessWidget {
  final int budget;
  final int spent;
  final int remaining;

  const SummaryCard({
    super.key,
    required this.budget,
    required this.spent,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    final over = remaining < 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.babyBlue, AppColors.cottonPink],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cottonPinkDeep.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anggaran bulan ini',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            rupiah(budget),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.6),
              valueColor: AlwaysStoppedAnimation<Color>(
                over ? AppColors.danger : AppColors.softYellowDeep,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Pill(
                  label: 'Pengeluaran',
                  value: rupiah(spent),
                  color: Colors.white.withOpacity(0.75),
                  valueColor: AppColors.text,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Pill(
                  label: 'Sisa',
                  value: rupiah(remaining),
                  color: over ? AppColors.dangerSoft : AppColors.softYellow,
                  valueColor: over ? AppColors.danger : AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color valueColor;

  const _Pill({
    required this.label,
    required this.value,
    required this.color,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSoft)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
