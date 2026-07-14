import 'package:hive_ce/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String paidBy;

  @HiveField(3)
  List<String> splitBetween;

  Expense({
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
  });
}
