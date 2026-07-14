import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _splitBetween.addAll(widget.members);
  }

  void _save() {
    if (_descController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty ||
        _paidBy == null ||
        _splitBetween.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('DESCRIPTION', style: _labelStyle()),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                hintText: 'e.g. Dinner at cafe',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('AMOUNT', style: _labelStyle()),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: '₹  ',
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('PAID BY', style: _labelStyle()),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.members.map((m) {
                final selected = _paidBy == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: selected,
                  onSelected: (v) => setState(() => _paidBy = v ? m : null),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SPLIT BETWEEN', style: _labelStyle()),
                Text(
                  '${_splitBetween.length} selected',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.members.map((m) {
                final selected = _splitBetween.contains(m);
                return FilterChip(
                  label: Text(m),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      v ? _splitBetween.add(m) : _splitBetween.remove(m);
                    });
                  },
                  showCheckmark: false,
                  avatar: selected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Add Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 0.5,
    );
  }
}
