import 'package:flutter/material.dart';
import 'models/group.dart';
import 'screens/add_group_screen.dart';

void main() {
  runApp(const SplitEaseApp());
}

class SplitEaseApp extends StatelessWidget {
  const SplitEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Group> _groups = [];

  Future<void> _createGroup() async {
    final newGroup = await Navigator.push<Group>(
      context,
      MaterialPageRoute(builder: (context) => const AddGroupScreen()),
    );

    if (newGroup != null) {
      setState(() {
        _groups.add(newGroup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Groups')),
      body: _groups.isEmpty
          ? const Center(child: Text('No groups yet. Tap + to create one.'))
          : ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.group)),
                    title: Text(group.name),
                    subtitle: Text('${group.members.length} members'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGroup,
        child: const Icon(Icons.add),
      ),
    );
  }
}
