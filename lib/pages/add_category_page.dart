import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';

/// Halaman Tambah Kategori: nama, ikon, dan warna dari input pengguna.
class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  static const List<IconData> _icons = [
    Icons.shopping_bag_rounded,
    Icons.local_cafe_rounded,
    Icons.phone_android_rounded,
    Icons.wifi_rounded,
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.card_giftcard_rounded,
    Icons.checkroom_rounded,
    Icons.medical_services_rounded,
    Icons.pets_rounded,
    Icons.flight_rounded,
    Icons.fitness_center_rounded,
    Icons.more_horiz_rounded,
  ];

  static const List<List<Color>> _colors = [
    [AppColors.softYellow, AppColors.softYellowDeep],
    [AppColors.babyBlue, AppColors.babyBlueDeep],
    [AppColors.mint, AppColors.mintDeep],
    [AppColors.cottonPink, AppColors.cottonPinkDeep],
    [AppColors.peach, AppColors.peachDeep],
    [AppColors.lavender, AppColors.lavenderDeep],
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  int _iconIndex = 0;
  int _colorIndex = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.addCategory(
      name: _nameCtrl.text,
      icon: _icons[_iconIndex],
      color: _colors[_colorIndex][0],
      deepColor: _colors[_colorIndex][1],
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Kategori tersimpan! Atur alokasinya di Atur Anggaran.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _colors[_colorIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kategori')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: color[0],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: color[1].withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(_icons[_iconIndex], color: color[1], size: 42),
              ),
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _nameCtrl,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama kategori',
                prefixIcon: Icon(Icons.label_rounded),
              ),
              validator: (v) {
                final text = (v ?? '').trim();
                if (text.isEmpty) return 'Nama wajib diisi';
                if (AppState.instance.categoryNameExists(text)) {
                  return 'Nama kategori sudah ada';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text('Ikon', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < _icons.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _iconIndex = i),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _iconIndex == i ? color[0] : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _iconIndex == i ? color[1] : AppColors.babyBlue,
                          width: 2,
                        ),
                      ),
                      child: Icon(_icons[i], color: AppColors.text),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text('Warna', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < _colors.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _colorIndex = i),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _colors[i][0],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _colorIndex == i
                              ? AppColors.text
                              : _colors[i][1],
                          width: _colorIndex == i ? 3 : 2,
                        ),
                      ),
                      child: _colorIndex == i
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.text, size: 20)
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
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
