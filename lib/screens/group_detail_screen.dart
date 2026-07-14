import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';
import 'add_expense_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Future<void> _addExpense() async {
    final newExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(members: widget.group.members),
      ),
    );

    if (newExpense != null) {
      setState(() {
        widget.group.expenses.add(newExpense);
        widget.group.save();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final balances = widget.group.calculateBalances();
    final total = widget.group.expenses.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Total spent card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total spent',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Balances section
          Text('BALANCES', style: _sectionLabel()),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: balances.entries.map((e) {
                final isLast = e.key == balances.keys.last;
                final isSettled = e.value.abs() < 0.01;
                final isPositive = e.value >= 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: AppColors.border),
                          ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.surface,
                        child: Text(
                          e.key.isNotEmpty ? e.key[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          e.key,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Text(
                        isSettled
                            ? 'settled up'
                            : '${isPositive ? "+" : "−"}₹${e.value.abs().toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isSettled
                              ? AppColors.textSecondary
                              : (isPositive
                                    ? AppColors.positive
                                    : AppColors.negative),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Expenses section
          Text('EXPENSES', style: _sectionLabel()),
          const SizedBox(height: AppSpacing.sm),
          if (widget.group.expenses.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Text(
                    'No expenses yet',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: widget.group.expenses.reversed
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final expense = entry.value;
                      final isLast = index == widget.group.expenses.length - 1;

                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: AppColors.border),
                                ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.description,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Paid by ${expense.paidBy} · split ${expense.splitBetween.length} ways',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${expense.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          const SizedBox(height: 80), // FAB ke neeche jagah
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExpense,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  TextStyle _sectionLabel() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 0.5,
    );
  }
}
