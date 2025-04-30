import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/database_service.dart';
import '../services/pdf_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _dbService = DatabaseService();
  final _pdfService = PdfService();

  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final names = await _dbService.getStudents();
    setState(() {
      _students = names.map((n) => Student(name: n)).toList();
      _isLoading = false;
    });
  }

  void _updateAttendance(int index, String status) {
    setState(() {
      _students[index].attendance = status;
    });
  }

  Future<void> _savePdf() async {
    final path = await _pdfService.generateAttendancePdf(_students);
    if (path == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save PDF')));
      return;
    }
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Saved'),
            content: Text('Attendance sheet saved to:\n$path'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Mark Attendance')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, idx) {
          final student = _students[idx];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text(student.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Absent button
                    TextButton(
                      onPressed: () => _updateAttendance(idx, 'A'),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            student.attendance == 'A'
                                ? Colors.red
                                : Colors.grey.shade200,
                      ),
                      child: const Text(
                        'A',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Present button
                    TextButton(
                      onPressed: () => _updateAttendance(idx, 'P'),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            student.attendance == 'P'
                                ? Colors.green
                                : Colors.grey.shade200,
                      ),
                      child: const Text(
                        'P',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _savePdf,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }
}
