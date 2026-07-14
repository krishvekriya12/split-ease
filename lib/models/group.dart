import 'package:hive_ce/hive.dart';
import 'expense.dart';

part 'group.g.dart';

@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> members;

  @HiveField(3)
  List<Expense> expenses;

  Group({
    required this.id,
    required this.name,
    required this.members,
    List<Expense>? expenses,
  }) : expenses = expenses ?? [];

  Map<String, double> calculateBalances() {
    final Map<String, double> balances = {for (var m in members) m: 0.0};

    for (final expense in expenses) {
      final splitAmount = expense.amount / expense.splitBetween.length;
      balances[expense.paidBy] =
          (balances[expense.paidBy] ?? 0) + expense.amount;
      for (final person in expense.splitBetween) {
        balances[person] = (balances[person] ?? 0) - splitAmount;
      }
    }

    return balances;
  }
}
