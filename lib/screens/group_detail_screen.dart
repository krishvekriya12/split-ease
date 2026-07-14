import 'package:flutter/material.dart';
import 'package:split_ease/models/expense.dart';
import 'package:split_ease/models/group.dart';
import 'package:split_ease/screens/add_expense_screen.dart';

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
        widget.group.save(); // Hive ko batao data update hua hai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final balances = widget.group.calculateBalances();
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...balances.entries.map((e) {
                      final isPositive = e.value >= 0;
                      return Text(
                        '${e.key}: ${isPositive ? "get back" : "owes"} ₹${e.value.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isPositive
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: widget.group.expenses.isEmpty
                ? const Center(child: Text('No Expense yet'))
                : ListView.builder(
                    itemCount: widget.group.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = widget.group.expenses[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(expense.description),
                        subtitle: Text('Paid by ${expense.paidBy}'),
                        trailing: Text('₹${expense.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
