class Expense {
  final String description;
  final double amount;
  final String paidBy;
  final List<String> splitBetween;

  Expense({
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
  });
}
