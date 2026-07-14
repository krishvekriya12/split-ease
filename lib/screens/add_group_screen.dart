import 'package:flutter/material.dart';
import '../models/group.dart';

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

  void _saveGroup() {
    if (_nameController.text.trim().isEmpty || _members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group name aur kam se kam 1 member daalo'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _memberController,
                    decoration: const InputDecoration(
                      labelText: 'Member Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addMember,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _members.map((m) => Chip(label: Text(m))).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGroup,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Create Group'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
