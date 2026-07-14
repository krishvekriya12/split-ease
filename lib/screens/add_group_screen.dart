import 'package:flutter/material.dart';
import '../models/group.dart';
import '../theme/app_theme.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _nameController = TextEditingController();
  final _memberController = TextEditingController();
  final List<String> _members = [];

  void _addMember() {
    if (_memberController.text.trim().isEmpty) return;
    setState(() {
      _members.add(_memberController.text.trim());
      _memberController.clear();
    });
  }

  void _removeMember(String member) {
    setState(() => _members.remove(member));
  }

  void _saveGroup() {
    if (_nameController.text.trim().isEmpty || _members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add a group name and at least 1 member'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      members: _members,
    );

    Navigator.pop(context, newGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Group')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GROUP NAME', style: _labelStyle()),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'e.g. Goa Trip'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('MEMBERS', style: _labelStyle()),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _memberController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _addMember(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: IconButton.filled(
                      onPressed: _addMember,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_members.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _members.map((m) {
                    return Chip(
                      label: Text(m),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeMember(m),
                    );
                  }).toList(),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGroup,
                  child: const Text('Create Group'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
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
