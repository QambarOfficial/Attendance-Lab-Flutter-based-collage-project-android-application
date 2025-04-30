import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/student.dart';

class PdfService {
  /// Generates and saves a PDF attendance sheet for [students].
  /// Returns the file path of the saved PDF.
  Future<String?> generateAttendancePdf(List<Student> students) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (_) => pw.Table.fromTextArray(
              headers: ['Student Name', 'Attendance'],
              data: students.map((s) => [s.name, s.attendance]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
            ),
      ),
    );

    final dir = await getDownloadsDirectory();
    if (dir == null) return null;

    // Generate unique filename
    int count = 1;
    String filePath;
    do {
      filePath = '${dir.path}/attendance_$count.pdf';
      count++;
    } while (await File(filePath).exists());

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
