import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/category_tile.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_page.dart';
import 'analysis_page.dart';
import 'budget_page.dart';
import 'category_transactions_page.dart';
import 'transaction_detail_page.dart';

/// Halaman Beranda dengan dua tab: Transaksi dan Kategori.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Row(
            children: [
              Image.asset('assets/images/logo.png', width: 36, height: 36),
              const SizedBox(width: 10),
              const Text('MyDuit'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Analisis Pengeluaran',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: AppColors.text,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalysisPage()),
              ),
              icon: const Icon(Icons.bar_chart_rounded),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.softYellow,
                  foregroundColor: AppColors.text,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetPage()),
                ),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text(
                  'Atur Anggaran',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              height: 48,
              margin: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.babyBlue.withOpacity(0.45),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: AppColors.text,
                unselectedLabelColor: AppColors.textSoft,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                tabs: const [
                  Tab(text: 'Transaksi'),
                  Tab(text: 'Kategori'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _TransactionTab(),
            _CategoryTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Tambah Transaksi',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _TransactionTab extends StatelessWidget {
  const _TransactionTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final items = state.transactions;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          itemCount: items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SummaryCard(
                  budget: state.monthlyBudget,
                  spent: state.totalSpent,
                  remaining: state.remainingBudget,
                ),
              );
            }
            if (index == 1) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 4),
                child: Text(
                  'Riwayat ${bulanTahun(DateTime(2026, 11))}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              );
            }
            final t = items[index - 2];
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
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final cats = AppState.instance.categories;
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          itemCount: cats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final c = cats[index];
            return CategoryTile(
              category: c,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryTransactionsPage(category: c),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
