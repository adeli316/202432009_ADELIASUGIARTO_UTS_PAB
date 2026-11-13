import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/soft_card.dart';

/// Halaman Analisis: pengeluaran per bulan dalam satu tahun.
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analisis Pengeluaran')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final state = AppState.instance;
          final spending = state.monthlySpending(_year);
          final total = spending.fold(0, (a, b) => a + b);
          final maxValue = spending.fold(0, (a, b) => a > b ? a : b);
          final active = spending.where((v) => v > 0).length;
          final average = active == 0 ? 0 : (total / active).round();
          final topIndex = maxValue == 0 ? -1 : spending.indexOf(maxValue);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _year--),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    '$_year',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _year++),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      label: 'Total setahun',
                      value: rupiah(total),
                      color: AppColors.softYellow,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      label: 'Rata-rata per bulan',
                      value: rupiah(average),
                      color: AppColors.mint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SoftCard(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                child: SizedBox(
                  height: 190,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < 12; i++)
                        Expanded(
                          child: _Bar(
                            label: namaBulanSingkat(i + 1),
                            value: spending[i],
                            maxValue: maxValue,
                            highlight: i == topIndex,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'Rincian per bulan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              for (var i = 0; i < 12; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MonthRow(
                    month: i + 1,
                    spent: spending[i],
                    budget: state.budgetFor(_year, i + 1),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final bool highlight;

  const _Bar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: ratio < 0.02 && value > 0 ? 0.02 : ratio,
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: highlight
                      ? AppColors.cottonPinkDeep
                      : AppColors.babyBlueDeep,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.substring(0, 1),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _MonthRow extends StatelessWidget {
  final int month;
  final int spent;
  final int budget;

  const _MonthRow({
    required this.month,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final over = spent > budget;
    final ratio = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  namaBulan(month),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                rupiah(spent),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: over ? AppColors.danger : AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: spent == 0 ? 0 : ratio,
              minHeight: 8,
              backgroundColor: AppColors.babyBlue.withOpacity(0.4),
              color: over ? AppColors.danger : AppColors.mintDeep,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Anggaran ${rupiah(budget)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSoft),
            ),
          ),
        ],
      ),
    );
  }
}
