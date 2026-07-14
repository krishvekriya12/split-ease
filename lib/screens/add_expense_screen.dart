import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<String> members;

  const AddExpenseScreen({super.key, required this.members});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String? _paidBy;
  final Set<String> _splitBetween = {};

  void _save() {
    if (_descController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty ||
        _paidBy == null ||
        _splitBetween.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sab fields fill karo')));
      return;
    }

    final expense = Expense(
      description: _descController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      paidBy: _paidBy!,
      splitBetween: _splitBetween.toList(),
    );

    Navigator.pop(context, expense);
  }

  @override
  void initState() {
    super.initState();
    _splitBetween.addAll(widget.members); // default: sab mein split
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description (e.g. Dinner)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Paid by',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: widget.members.map((m) {
                return ChoiceChip(
                  label: Text(m),
                  selected: _paidBy == m,
                  onSelected: (selected) {
                    setState(() => _paidBy = selected ? m : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Split between',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: widget.members.map((m) {
                return FilterChip(
                  label: Text(m),
                  selected: _splitBetween.contains(m),
                  onSelected: (selected) {
                    setState(() {
                      selected ? _splitBetween.add(m) : _splitBetween.remove(m);
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Add Expense'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
