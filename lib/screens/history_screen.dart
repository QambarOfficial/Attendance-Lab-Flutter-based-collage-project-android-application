import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<FileSystemEntity>>? _filesFuture;
  final Set<FileSystemEntity> _selectedFiles = {};

  @override
  void initState() {
    super.initState();
    _refreshFileList();
  }

  void _refreshFileList() {
    _filesFuture = _listPdfFiles();
  }

  Future<List<FileSystemEntity>> _listPdfFiles() async {
    final dir = await getDownloadsDirectory();
    if (dir == null) return [];
    return dir
        .list()
        .where((e) => e.path.toLowerCase().endsWith('.pdf'))
        .toList();
  }

  void _toggleSelection(FileSystemEntity file) {
    setState(() {
      if (_selectedFiles.contains(file)) {
        _selectedFiles.remove(file);
      } else {
        _selectedFiles.add(file);
      }
    });
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        String password = '';
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Enter password'),
            obscureText: true,
            onChanged: (v) => password = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, password == 'Farhaz123'),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      for (var file in _selectedFiles) {
        try {
          if (await File(file.path).exists()) {
            await File(file.path).delete();
          }
        } catch (_) {}
      }
      setState(() {
        _selectedFiles.clear();
        _refreshFileList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Attendance Records'),
        actions: [
          if (_selectedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
        ],
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final files = snapshot.data ?? [];
          if (files.isEmpty) {
            return const Center(child: Text('No attendance records found.'));
          }
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, i) {
              final file = files[i];
              final fileName = file.path.split(Platform.pathSeparator).last;
              final sizeKb = (file.statSync().size / 1024).ceil();
              final isSelected = _selectedFiles.contains(file);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.redAccent,
                  ),
                  title: Text(fileName),
                  subtitle: Text('$sizeKb KB'),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(file),
                  ),
                  onTap: () => OpenFile.open(file.path),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
