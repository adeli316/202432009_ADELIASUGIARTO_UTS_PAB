import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/category_badge.dart';

/// Halaman Atur Anggaran: anggaran bulanan dan alokasi per kategori.
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _budgetCtrl;
  late final Map<String, TextEditingController> _allocCtrls;
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final state = AppState.instance;
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _budgetCtrl = TextEditingController(
      text: state.budgetFor(_year, _month).toString(),
    );
    _allocCtrls = {
      for (final c in state.categories)
        c.id: TextEditingController(
          text: state.allocationFor(c.id, _year, _month).toString(),
        ),
    };
  }

  /// Muat anggaran dan alokasi sesuai bulan dan tahun yang dipilih.
  void _loadPeriod() {
    final state = AppState.instance;
    _budgetCtrl.text = state.budgetFor(_year, _month).toString();
    for (final c in state.categories) {
      _allocCtrls[c.id]!.text =
          state.allocationFor(c.id, _year, _month).toString();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _budgetCtrl.dispose();
    for (final c in _allocCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  int _parse(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

  int get _allocated =>
      _allocCtrls.values.fold(0, (sum, c) => sum + _parse(c));

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final budget = _parse(_budgetCtrl);
    if (_allocated > budget) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Total alokasi melebihi anggaran bulanan.'),
      ));
      return;
    }

    AppState.instance.saveBudgetFor(
      _year,
      _month,
      budget,
      {for (final e in _allocCtrls.entries) e.key: _parse(e.value)},
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Anggaran tersimpan!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cats = AppState.instance.categories;
    final budget = _parse(_budgetCtrl);
    final left = budget - _allocated;
    final over = left < 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Atur Anggaran')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    value: _month,
                    decoration: const InputDecoration(
                      labelText: 'Bulan',
                      prefixIcon: Icon(Icons.calendar_month_rounded),
                    ),
                    items: [
                      for (var m = 1; m <= 12; m++)
                        DropdownMenuItem(value: m, child: Text(namaBulan(m))),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      _month = v;
                      _loadPeriod();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    value: _year,
                    decoration: const InputDecoration(labelText: 'Tahun'),
                    items: [
                      for (var y = DateTime.now().year - 3;
                          y <= DateTime.now().year + 3;
                          y++)
                        DropdownMenuItem(value: y, child: Text('$y')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      _year = v;
                      _loadPeriod();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Anggaran bulanan',
                prefixText: 'Rp ',
                prefixIcon: Icon(Icons.account_balance_wallet_rounded),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null) return 'Anggaran wajib berupa angka';
                if (n <= 0) return 'Anggaran harus lebih dari 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: over ? AppColors.dangerSoft : AppColors.softYellow,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Icon(
                    over ? Icons.warning_rounded : Icons.pie_chart_rounded,
                    color: over ? AppColors.danger : AppColors.softYellowDeep,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      over ? 'Alokasi kelebihan' : 'Belum dialokasikan',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    rupiah(over ? -left : left),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: over ? AppColors.danger : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Bagi ke kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            for (final c in cats)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CategoryBadge(category: c, size: 50),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _allocCtrls[c.id],
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: c.name,
                          prefixText: 'Rp ',
                        ),
                        validator: (v) {
                          final text = (v ?? '').trim();
                          if (text.isEmpty) return 'Isi 0 jika tidak dipakai';
                          if (int.tryParse(text) == null) return 'Harus angka';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
