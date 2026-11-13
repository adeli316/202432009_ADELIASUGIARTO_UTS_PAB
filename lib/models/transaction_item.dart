class TransactionItem {
  final String title;
  final String category;
  final int amount;
  final DateTime date;
  final String note;

  const TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.note = '',
  });
}
