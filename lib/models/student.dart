class Student {
  final String name;
  String attendance;

  Student({
    required this.name,
    this.attendance = 'P', // default to Present
  });

  /// Creates a Student from a JSON-like map (if you later persist as JSON).
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] as String,
      attendance: map['attendance'] as String? ?? 'P',
    );
  }

  /// Converts this Student to a Map.
  Map<String, dynamic> toMap() {
    return {'name': name, 'attendance': attendance};
  }
}
