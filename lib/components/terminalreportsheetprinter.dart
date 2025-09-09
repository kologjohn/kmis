/*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPath;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final List<Map<String, dynamic>> subjects;
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPath,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.subjects,
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    // Load logo safely
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    final totalScoreValue = subjects.fold<num>(
      0,
          (sum, s) => sum + parseNum(s['totalScore']),
    );
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS SCORE',
      'EXAM SCORE',
      'TOTAL SCORE',
      'POSITION',
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, // left align
          children: [
            // 🔹 Header (centered only)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: primaryColor,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (logoImage != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      margin: const pw.EdgeInsets.only(right: 10),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImage),
                      ),
                    ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        schoolName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.Text(
                        reportTitle,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.Text(
                        examSession,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      margin: const pw.EdgeInsets.only(left: 10),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImage),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 10),

            // 🔹 Student info (left aligned)
            pw.Text("Name: $studentName"),
            pw.Text("ID: $studentId"),
            pw.Text("Class: $studentClass"),
            pw.Text("No in Class: $noInClass"),
            pw.Text("Re-Opening: $reOpeningDate"),
            pw.Text("Promoted To: $promotedTo"),
            pw.Text("Next Term Fees: $nextTermFees"),

            pw.SizedBox(height: 10),

            // 🔹 Subjects table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 10),

            pw.Text("Total Score: $totalScoreValue"),
            pw.Text("Average Score: ${avgScoreValue.toStringAsFixed(2)}"),

            pw.SizedBox(height: 10),

            // 🔹 Remarks (left aligned)
            pw.Text("Strength: $areaOfStrength"),
            pw.Text("Interest: $areaOfInterest"),
            pw.Text("Weakness: $weakness"),
            pw.Text("Attendance: $attendance"),
            pw.Text("Teacher: $teacherRemarks"),
            pw.Text("Head Teacher: $headTeacherRemarks"),
          ],
        );
      },
    );
  }
}
*/

/*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPath;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final List<Map<String, dynamic>> subjects;
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPath,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.subjects,
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }
  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;
    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS SCORE',
      'EXAM SCORE',
      'TOTAL SCORE',
      'POSITION',
      'REMARKS',
    ];
    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Header styled
            pw.Container(
              width: double.infinity,
              padding:
              const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(12),
                  bottomRight: pw.Radius.circular(12),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null)
                    pw.Container(
                      width: 55,
                      height: 55,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImage),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 55,
                      height: 55,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImage),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // 🔹 Student Info in 2 columns
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(children: [
                  pw.Text("Name:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(studentName),
                  pw.Text("ID:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(studentId),
                ]),
                pw.TableRow(children: [
                  pw.Text("Class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(studentClass),
                  pw.Text("No in Class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(noInClass),
                ]),
                pw.TableRow(children: [
                  pw.Text("Re-Opening:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(reOpeningDate),
                  pw.Text("Promoted To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(promotedTo),
                ]),
                pw.TableRow(children: [
                  pw.Text("Next Term Fees:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(nextTermFees),
                  pw.Text("", style: const pw.TextStyle()), // empty
                  pw.Text(""),
                ]),
              ],
            ),

            pw.SizedBox(height: 12),

            // 🔹 Subjects Table with Total & Average row
            pw.Table.fromTextArray(
              headers: headers,
              data: [
                ...subjects.map((s) => [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ]),
                // Add totals row
                [
                  '',
                  'TOTAL / AVERAGE',
                  '',
                  '',
                  '$totalScoreValue / ${avgScoreValue.toStringAsFixed(2)}',
                  '',
                  '',
                ]
              ],
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 12),

            // 🔹 Remarks Section
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Strength: $areaOfStrength"),
                pw.Text("Interest: $areaOfInterest"),
                pw.Text("Weakness: $weakness"),
                pw.Text("Attendance: $attendance"),
                pw.Text("Teacher Remarks: $teacherRemarks"),
                pw.Text("Head Teacher Remarks: $headTeacherRemarks"),
              ],
            ),
          ],
        );
      },
    );
  }
}
*/

/*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPathl;
  final String logoAssetPathr;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final String position; // 🔹 make position dynamic
  final List<Map<String, dynamic>> subjects;
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPathl,
    required this.logoAssetPathr,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.position, // 🔹 required now
    required this.subjects,
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImagel;
    pw.MemoryImage? logoImager;
    try {
      final logoBytesl = await rootBundle.load(logoAssetPathl);
      logoImagel = pw.MemoryImage(logoBytesl.buffer.asUint8List());
      final logoBytesr = await rootBundle.load(logoAssetPathr);
      logoImager = pw.MemoryImage(logoBytesr.buffer.asUint8List());
    } catch (_) {
      logoImagel = null;
      logoImager = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS SCORE (50%)',
      'EXAM SCORE (50%)',
      'TOTAL SCORE (100%)',
      'POSITION',
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Rounded Heading
            pw.Container(
              width: double.infinity,
              padding:
              const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(15),
                  bottomRight: pw.Radius.circular(15),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImagel != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImagel),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImager != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImager),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 15),

            // 🔹 Student Info neatly aligned
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5), // Label
                1: const pw.FlexColumnWidth(3),   // Value
                2: const pw.FlexColumnWidth(1.5), // Label
                3: const pw.FlexColumnWidth(2),   // Value
              },
              border: null,
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Class:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentClass),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("No. in class:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(noInClass),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Re-Opening Date:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(reOpeningDate),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Position:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(position),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Student ID:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentId),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Promoted To:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(promotedTo),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Student Name:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentName),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Next Term Fees:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(nextTermFees),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),

            // 🔹 Subjects Table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 8),

            // 🔹 Totals and Average rows
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(5),
                1: const pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("TOTAL",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("$totalScoreValue"),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Average Score",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(avgScoreValue.toStringAsFixed(2)),
                  ),
                ]),
              ],
            ),

            pw.SizedBox(height: 15),

            // 🔹 Remarks Section
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Area of strength: $areaOfStrength"),
                pw.Text("Area of interest: $areaOfInterest"),
                pw.Text("Areas that need strengthening: $weakness"),
                pw.Text("Attendance made: $attendance"),
                pw.SizedBox(height: 6),
                pw.Text("Teacher's Remarks: $teacherRemarks"),
                pw.Text("Head Teacher's Remarks: $headTeacherRemarks"),
              ],
            ),
          ],
        );
      },
    );
  }
}
*/

 /*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPathl;
  final String logoAssetPathr;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final String position; // 🔹 general position
  final List<Map<String, dynamic>> subjects; // 🔹 each subject should include 'position'
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPathl,
    required this.logoAssetPathr,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.position, // ✅ overall position passed here
    required this.subjects, // ✅ each subject must contain "position"
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImagel;
    pw.MemoryImage? logoImager;
    try {
      final logoBytesl = await rootBundle.load(logoAssetPathl);
      logoImagel = pw.MemoryImage(logoBytesl.buffer.asUint8List());
      final logoBytesr = await rootBundle.load(logoAssetPathr);
      logoImager = pw.MemoryImage(logoBytesr.buffer.asUint8List());
    } catch (_) {
      logoImagel = null;
      logoImager = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS SCORE (50%)',
      'EXAM SCORE (50%)',
      'TOTAL SCORE (100%)',
      'SUBJECT POSITION', // ✅ added subject position header
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Rounded Heading
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(15),
                  bottomRight: pw.Radius.circular(15),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImagel != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImagel),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImager != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImager),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 15),

            // 🔹 Student Info neatly aligned
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
              },
              border: null,
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Class:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentClass),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("No. in class:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(noInClass),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Re-Opening Date:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(reOpeningDate),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("General Position:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(position), // ✅ overall position here
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Student ID:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentId),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Promoted To:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(promotedTo),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Student Name:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(studentName),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text("Next Term Fees:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(nextTermFees),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),

            // 🔹 Subjects Table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(), // ✅ subject position here
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 8),

            // 🔹 Totals and Average rows
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(5),
                1: const pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("TOTAL",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("$totalScoreValue"),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text("Average Score",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(avgScoreValue.toStringAsFixed(2)),
                  ),
                ]),
              ],
            ),

            pw.SizedBox(height: 15),

            // 🔹 Remarks Section
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Area of strength: $areaOfStrength"),
                pw.Text("Area of interest: $areaOfInterest"),
                pw.Text("Areas that need strengthening: $weakness"),
                pw.Text("Attendance made: $attendance"),
                pw.SizedBox(height: 6),
                pw.Text("Teacher's Remarks: $teacherRemarks"),
                pw.Text("Head Teacher's Remarks: $headTeacherRemarks"),
              ],
            ),
          ],
        );
      },
    );
  }
}
*/

/*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPathl;
  final String logoAssetPathr;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final String position; // 🔹 general position
  final List<Map<String, dynamic>> subjects; // 🔹 includes 'position'
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPathl,
    required this.logoAssetPathr,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.position,
    required this.subjects,
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImagel;
    pw.MemoryImage? logoImager;
    try {
      final logoBytesl = await rootBundle.load(logoAssetPathl);
      logoImagel = pw.MemoryImage(logoBytesl.buffer.asUint8List());
      final logoBytesr = await rootBundle.load(logoAssetPathr);
      logoImager = pw.MemoryImage(logoBytesr.buffer.asUint8List());
    } catch (_) {
      logoImagel = null;
      logoImager = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS (50%)',
      'EXAM (50%)',
      'TOTAL (100%)',
      'SUBJECT POS.',
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(20),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Rounded Heading
            pw.Container(
              width: double.infinity,
              padding:
              const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(15),
                  bottomRight: pw.Radius.circular(15),
                ),
              ),
              child: pw.Row(
                children: [
                  if (logoImagel != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImagel),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImager != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImager),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // 🔹 Student Info
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Text("Class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(studentClass),
                    pw.Text("No. in class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(noInClass),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text("Re-Opening:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(reOpeningDate),
                    pw.Text("Position:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(position),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text("ID:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(studentId),
                    pw.Text("Promoted To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(promotedTo),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text("Name:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(studentName),
                    pw.Text("Next Term Fees:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(nextTermFees),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Subjects Table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 6),

            // 🔹 Totals / Average
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("TOTAL: $totalScoreValue",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("AVERAGE: ${avgScoreValue.toStringAsFixed(2)}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Remarks Section (ALWAYS INSIDE the page per student)
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Area of strength: $areaOfStrength"),
                  pw.Text("Area of interest: $areaOfInterest"),
                  pw.Text("Weakness: $weakness"),
                  pw.Text("Attendance: $attendance"),
                  pw.SizedBox(height: 4),
                  pw.Text("Teacher's Remarks: $teacherRemarks"),
                  pw.Text("Head Teacher's Remarks: $headTeacherRemarks"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
*/

/*
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPathl;
  final String logoAssetPathr;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final String position; // 🔹 general position
  final List<Map<String, dynamic>> subjects; // 🔹 includes 'position'
  final String areaOfStrength;
  final String areaOfInterest;
  final String weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPathl,
    required this.logoAssetPathr,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.position,
    required this.subjects,
    required this.areaOfStrength,
    required this.areaOfInterest,
    required this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImagel;
    pw.MemoryImage? logoImager;
    try {
      final logoBytesl = await rootBundle.load(logoAssetPathl);
      logoImagel = pw.MemoryImage(logoBytesl.buffer.asUint8List());
      final logoBytesr = await rootBundle.load(logoAssetPathr);
      logoImager = pw.MemoryImage(logoBytesr.buffer.asUint8List());
    } catch (_) {
      logoImagel = null;
      logoImager = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    // 🔹 Dynamic font scaling based on number of subjects
    double subjectFontSize;
    if (subjects.length <= 6) {
      subjectFontSize = 12; // Few subjects → bigger font
    } else if (subjects.length <= 9) {
      subjectFontSize = 11;
    } else if (subjects.length <= 12) {
      subjectFontSize = 9.5;
    } else if (subjects.length <= 15) {
      subjectFontSize = 8.5;
    } else {
      subjectFontSize = 7.5; // Many subjects → shrink
    }

    // 🔹 Remarks font adjustment
    double remarksFontSize =
    (teacherRemarks.length + headTeacherRemarks.length > 300)
        ? subjectFontSize - 1
        : subjectFontSize;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS (50%)',
      'EXAM (50%)',
      'TOTAL (100%)',
      'SUBJECT POS.',
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(20),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Rounded Heading
            pw.Container(
              width: double.infinity,
              padding:
              const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(15),
                  bottomRight: pw.Radius.circular(15),
                ),
              ),
              child: pw.Row(
                children: [
                  if (logoImagel != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImagel),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImager != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImager),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // 🔹 Student Info
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentClass),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("No. in class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(noInClass),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Re-Opening:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(reOpeningDate),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Position:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(position),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("ID:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentId),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Promoted To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(promotedTo),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Name:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentName),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Next Term Fees:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(nextTermFees),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Subjects Table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: subjectFontSize,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: subjectFontSize),
              border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 10),

            // 🔹 Totals / Average
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("TOTAL: $totalScoreValue",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("AVERAGE: ${avgScoreValue.toStringAsFixed(2)}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Remarks Section
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Area of strength: $areaOfStrength",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Area of interest: $areaOfInterest",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Weakness: $weakness",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Attendance: $attendance",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.SizedBox(height: 4),
                  pw.Text("Teacher's Remarks: $teacherRemarks",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Head Teacher's Remarks: $headTeacherRemarks",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
*/

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class ReportCardPrinter {
  final String schoolName;
  final String reportTitle;
  final String examSession;
  final String logoAssetPathl;
  final String logoAssetPathr;
  final String studentName;
  final String studentId;
  final String studentClass;
  final String noInClass;
  final String reOpeningDate;
  final String promotedTo;
  final String nextTermFees;
  final String position; // 🔹 general position
  final List<Map<String, dynamic>> subjects; // 🔹 includes 'position'

  final String? areaOfStrength;
  final String? areaOfInterest;
  final String? weakness;
  final String attendance;
  final String teacherRemarks;
  final String headTeacherRemarks;
  final String? academicYearAverage; // 🔹 optional

  ReportCardPrinter({
    required this.schoolName,
    required this.reportTitle,
    required this.examSession,
    required this.logoAssetPathl,
    required this.logoAssetPathr,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.noInClass,
    required this.reOpeningDate,
    required this.promotedTo,
    required this.nextTermFees,
    required this.position,
    required this.subjects,
    this.areaOfStrength,
    this.areaOfInterest,
    this.weakness,
    required this.attendance,
    required this.teacherRemarks,
    required this.headTeacherRemarks,
    this.academicYearAverage,
  });

  num parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  /// 🔹 Find subject(s) with highest score
  String getTopSubject() {
    if (subjects.isEmpty) return "N/A";
    final maxScore = subjects.map((s) => parseNum(s['totalScore'])).reduce((a, b) => a > b ? a : b);
    final tops = subjects.where((s) => parseNum(s['totalScore']) == maxScore).map((s) => s['subject']).toList();
    return tops.join(", ");
  }

  /// 🔹 Find subject(s) with lowest score
  String getWeakSubject() {
    if (subjects.isEmpty) return "N/A";
    final minScore = subjects.map((s) => parseNum(s['totalScore'])).reduce((a, b) => a < b ? a : b);
    final lows = subjects.where((s) => parseNum(s['totalScore']) == minScore).map((s) => s['subject']).toList();
    return lows.join(", ");
  }

  /// 🔹 Find mid-range subject (interest area = between top and weak)
  String getInterestSubject() {
    if (subjects.isEmpty) return "N/A";
    final sorted = subjects.toList()
      ..sort((a, b) => parseNum(b['totalScore']).compareTo(parseNum(a['totalScore'])));
    if (sorted.length < 3) return sorted.first['subject'];
    return sorted[sorted.length ~/ 2]['subject'];
  }

  Future<pw.Page> generatePage(PdfPageFormat format, String title) async {
    pw.MemoryImage? logoImagel;
    pw.MemoryImage? logoImager;
    try {
      final logoBytesl = await rootBundle.load(logoAssetPathl);
      logoImagel = pw.MemoryImage(logoBytesl.buffer.asUint8List());
      final logoBytesr = await rootBundle.load(logoAssetPathr);
      logoImager = pw.MemoryImage(logoBytesr.buffer.asUint8List());
    } catch (_) {
      logoImagel = null;
      logoImager = null;
    }

    final totalScoreValue =
    subjects.fold<num>(0, (sum, s) => sum + parseNum(s['totalScore']));
    final avgScoreValue =
    subjects.isNotEmpty ? totalScoreValue / subjects.length : 0;

    // 🔹 Dynamic areas if not provided
    final computedStrength = areaOfStrength == null || areaOfStrength!.isEmpty
        ? getTopSubject()
        : areaOfStrength!;
    final computedWeakness = weakness == null || weakness!.isEmpty
        ? getWeakSubject()
        : weakness!;
    final computedInterest = areaOfInterest == null || areaOfInterest!.isEmpty
        ? getInterestSubject()
        : areaOfInterest!;

    // 🔹 Font scaling
    double subjectFontSize;
    if (subjects.length <= 6) {
      subjectFontSize = 12;
    } else if (subjects.length <= 9) {
      subjectFontSize = 11;
    } else if (subjects.length <= 12) {
      subjectFontSize = 9.5;
    } else if (subjects.length <= 15) {
      subjectFontSize = 8.5;
    } else {
      subjectFontSize = 7.5;
    }

    double remarksFontSize =
    (teacherRemarks.length + headTeacherRemarks.length > 300)
        ? subjectFontSize - 1
        : subjectFontSize;

    final headers = const [
      'CODE',
      'SUBJECT',
      'CLASS (50%)',
      'EXAM (50%)',
      'TOTAL (100%)',
      'SUBJECT POS.',
      'REMARKS',
    ];

    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);

    return pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(20),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            pw.Container(
              width: double.infinity,
              padding:
              const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(15),
                  bottomRight: pw.Radius.circular(15),
                ),
              ),
              child: pw.Row(
                children: [
                  if (logoImagel != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImagel),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          schoolName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          reportTitle,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          examSession,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logoImager != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(image: logoImager),
                      ),
                    ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // 🔹 Student Info
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentClass),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("No. in class:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(noInClass),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Re-Opening:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(reOpeningDate),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Position:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(position),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("ID:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentId),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Promoted To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(promotedTo),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Name:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(studentName),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text("Next Term Fees:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(nextTermFees),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Subjects Table
            pw.Table.fromTextArray(
              headers: headers,
              data: subjects.map((s) {
                return [
                  s['code'].toString(),
                  s['subject'].toString(),
                  s['classScore'].toString(),
                  s['examScore'].toString(),
                  s['totalScore'].toString(),
                  s['position'].toString(),
                  s['remarks'].toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: subjectFontSize,
              ),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: subjectFontSize),
              border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey),
            ),

            pw.SizedBox(height: 10),

            // 🔹 Totals / Average
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("TOTAL: $totalScoreValue",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("AVERAGE: ${avgScoreValue.toStringAsFixed(2)}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                if (academicYearAverage != null)
                  pw.Text("YEAR AVG: $academicYearAverage",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Remarks Section
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Area of strength: $computedStrength",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Area of interest: $computedInterest",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Weakness: $computedWeakness",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Attendance: $attendance",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.SizedBox(height: 4),
                  pw.Text("Teacher's Remarks: $teacherRemarks",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                  pw.Text("Head Teacher's Remarks: $headTeacherRemarks",
                      style: pw.TextStyle(fontSize: remarksFontSize)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
