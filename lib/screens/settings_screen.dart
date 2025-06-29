import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _dbService = DatabaseService();
  final _nameController = TextEditingController();

  List<String> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final names = await _dbService.getStudents();
    setState(() {
      _students = names;
      _isLoading = false;
    });
  }

  Future<void> _addStudent() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Please enter a student name.');
      return;
    }
    await _dbService.addStudent(name);
    _nameController.clear();
    await _loadStudents();
  }

  Future<void> _removeStudent(int index) async {
    // Store the context of the SettingsScreenState
    final BuildContext settingsScreenContext = context;

    final confirmed = await showDialog<bool>(
      context: settingsScreenContext, // Use the stable context for showDialog
      builder:
          (BuildContext dialogContext) => AlertDialog(
            // Give the dialog's context a distinct name
            title: const Text('Confirm Removal'),
            content: Text('Delete "${_students[index]}"?'),
            actions: [
              TextButton(
                // Use the dialog's context for popping the dialog itself
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('No'),
              ),
              TextButton(
                // Use the dialog's context for popping the dialog itself
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await _dbService.removeStudentAt(index);
      // After removal, reload students, which will trigger a rebuild.
      // The dialog should already be gone because we popped it using its own context.
      await _loadStudents();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Manage Students')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Students')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addStudent,
                child: const Text('Add Student'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _students.isEmpty
                      ? const Center(child: Text('No students added yet.'))
                      : ListView.builder(
                        itemCount: _students.length,
                        itemBuilder:
                            (ctx, i) => ListTile(
                              title: Text(_students[i]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeStudent(i),
                              ),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
