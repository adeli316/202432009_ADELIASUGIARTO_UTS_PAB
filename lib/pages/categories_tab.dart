import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/icon_badge.dart';

class CategoriesTab extends StatelessWidget {
  final int budget;
  final Map<String, int> allocations;
  final int Function(String category) spentOf;
  final ValueChanged<Category> onTapCategory;

  const CategoriesTab({
    super.key,
    required this.budget,
    required this.allocations,
    required this.spentOf,
    required this.onTapCategory,
  });

  @override
  Widget build(BuildContext context) {
    final totalAlokasi = allocations.values.fold<int>(0, (s, v) => s + v);
    final belumDialokasi = budget - totalAlokasi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori pengeluaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              Text(
                'Belum dialokasikan ${formatRupiah(belumDialokasi)}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: belumDialokasi < 0 ? kDanger : kMuted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: kCategories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final c = kCategories[index];
              final alokasi = allocations[c.name] ?? 0;
              final terpakai = spentOf(c.name);
              final sisa = alokasi - terpakai;
              final progres = alokasi > 0
                  ? (terpakai / alokasi).clamp(0.0, 1.0).toDouble()
                  : 0.0;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTapCategory(c),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      IconBadge(icon: c.icon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: kText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Alokasi ${formatRupiah(alokasi)}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: kMuted,
                              ),
                            ),
                            Text(
                              'Terpakai ${formatRupiah(terpakai)}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: kMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progres,
                                minHeight: 6,
                                backgroundColor: kGreenSoft,
                                color: sisa < 0 ? kDanger : kGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Sisa',
                            style: TextStyle(fontSize: 11.5, color: kMuted),
                          ),
                          Text(
                            formatRupiah(sisa),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: sisa < 0 ? kDanger : kText,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.chevron_right, color: kMuted, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
