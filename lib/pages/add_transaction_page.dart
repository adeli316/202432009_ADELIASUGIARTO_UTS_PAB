import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

/// Halaman Form Tambah Transaksi.
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _customCatCtrl = TextEditingController();

  static const String _otherId = '__dll__';

  String? _categoryId;
  bool _categoryError = false;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _customCatCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final formOk = _formKey.currentState!.validate();
    final catOk = _categoryId != null;
    setState(() => _categoryError = !catOk);
    if (!formOk || !catOk) return;

    final state = AppState.instance;
    final amount = int.parse(_amountCtrl.text.trim());
    final categoryId = _categoryId == _otherId
        ? state.addCategory(_customCatCtrl.text).id
        : _categoryId!;
    final remainingAfter = state.remainingOf(categoryId) - amount;

    state.addTransaction(
      title: _titleCtrl.text.trim(),
      categoryId: categoryId,
      amount: amount,
      date: _date,
      note: _noteCtrl.text.trim(),
    );

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(
      content: Text(
        remainingAfter < 0
            ? 'Tersimpan. Pengeluaran melebihi alokasi kategori.'
            : 'Transaksi tersimpan!',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cats = AppState.instance.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            TextFormField(
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama pengeluaran',
                prefixIcon: Icon(Icons.edit_rounded),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in cats)
                  ChoiceChip(
                    avatar: Icon(c.icon, size: 18, color: c.deepColor),
                    label: Text(c.name),
                    selected: _categoryId == c.id,
                    selectedColor: c.color,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: c.color, width: 2),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                    onSelected: (_) => setState(() {
                      _categoryId = c.id;
                      _categoryError = false;
                    }),
                  ),
                ChoiceChip(
                  avatar: const Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppColors.textSoft,
                  ),
                  label: const Text('DLL'),
                  selected: _categoryId == _otherId,
                  selectedColor: AppColors.lavender,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.lavender, width: 2),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                  onSelected: (_) => setState(() {
                    _categoryId = _otherId;
                    _categoryError = false;
                  }),
                ),
              ],
            ),
            if (_categoryId == _otherId) ...[
              const SizedBox(height: 14),
              TextFormField(
                controller: _customCatCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama kategori baru',
                  prefixIcon: Icon(Icons.label_rounded),
                ),
                validator: (v) => (_categoryId == _otherId &&
                        (v == null || v.trim().isEmpty))
                    ? 'Nama kategori wajib diisi'
                    : null,
              ),
            ],
            if (_categoryError)
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 8),
                child: Text(
                  'Pilih salah satu kategori',
                  style: TextStyle(color: AppColors.danger, fontSize: 12.5),
                ),
              ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
                prefixIcon: Icon(Icons.payments_rounded),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null) return 'Nominal wajib berupa angka';
                if (n <= 0) return 'Nominal harus lebih dari 0';
                return null;
              },
            ),
            const SizedBox(height: 18),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  prefixIcon: Icon(Icons.event_rounded),
                ),
                child: Text(tanggalLengkap(_date)),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.sticky_note_2_rounded),
              ),
            ),
            const SizedBox(height: 28),
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
