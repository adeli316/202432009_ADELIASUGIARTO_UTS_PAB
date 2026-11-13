import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

/// Pilihan bulan dengan tombol sebelumnya dan berikutnya.
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final m = state.viewMonth;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.babyBlue.withOpacity(0.35),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () => state.setViewMonth(DateTime(m.year, m.month - 1)),
          ),
          Expanded(
            child: Center(
              child: Text(
                bulanTahun(m),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () => state.setViewMonth(DateTime(m.year, m.month + 1)),
          ),
        ],
      ),
    );
  }
}
