/// Satu transaksi pengeluaran.
class Transaction {
  final int id;
  final String title;
  final String categoryId;
  final int amount;
  final DateTime date;
  final String note;

  const Transaction({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.note = '',
  });
}
