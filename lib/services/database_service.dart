import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const _keyStudents = 'student_names';

  /// Fetches the list of student names.
  Future<List<String>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyStudents) ?? <String>[];
  }

  /// Adds [name] to the list of students.
  Future<void> addStudent(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final students = prefs.getStringList(_keyStudents) ?? <String>[];
    students.add(name);
    await prefs.setStringList(_keyStudents, students);
  }

  /// Removes the student at [index].
  Future<void> removeStudentAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final students = prefs.getStringList(_keyStudents) ?? <String>[];
    if (index >= 0 && index < students.length) {
      students.removeAt(index);
      await prefs.setStringList(_keyStudents, students);
    }
  }

  /// Overwrites the entire student list.
  Future<void> saveStudents(List<String> students) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyStudents, students);
  }
}
