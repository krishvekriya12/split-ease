import 'expense.dart';

class Group {
  final String id;
  final String name;
  final List<String> members;
  final List<Expense> expenses;

  Group({
    required this.id,
    required this.name,
    required this.members,
    List<Expense>? expenses,
  }) : expenses = expenses ?? [];

  Map<String, double> calculateBalance() {
    final Map<String, double> balance = {for (var m in members) m: 0.0};
    for (final expense in expenses) {
      final splitAmount = expense.amount / expense.splitBetween.length;
      balance[expense.paidBy] = (balance[expense.paidBy] ?? 0) + expense.amount;
      for (final person in expense.splitBetween) {
        balance[person] = (balance[person] ?? 0) - splitAmount;
      }
    }
    return balance;
  }
}
