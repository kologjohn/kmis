
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CriteriaPdfsheet {
  final String eventTitle;
  final String subtitle;
  final String zone;
  final String episode;
  final String division;
  final String logoAssetPath;
  final String? totalMarks;
  final List<String> criteriaColumns;
  final List<Map<String, dynamic>> rows;

  CriteriaPdfsheet({
    required this.eventTitle,
    required this.subtitle,
    required this.zone,
    required this.episode,
    required this.division,
    required this.logoAssetPath,
    this.totalMarks,
    required this.criteriaColumns,
    required this.rows,
  });

  /// Generate PDF bytes
  Future<List<int>> generatePdf(PdfPageFormat format,title) async {
    final pdf = pw.Document(title: title,author: 'kologsoft');

    // ✅ Load logo safely
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (e) {
      logoImage = null;
    }

    List<Map<String, dynamic>> sortedRows = [];
    try {
      // 🔹 Sort rows in descending order by total
      sortedRows = [...rows];
      sortedRows.sort((a, b) {
        final aTotal = (a['total'] ?? 0) as num;
        final bTotal = (b['total'] ?? 0) as num;
        return bTotal.compareTo(aTotal);
      });
    } catch (e) {
      sortedRows = rows;
    }

    List<String> headers = [];
    try {
      // ✅ Headers
      headers = <String>[
        '#',
        'CONTESTANT NAME',
        ...criteriaColumns.map((c) => "JUDGE $c"),
        'TOTAL',
      ];
    } catch (e) {
      headers = ['#', 'CONTESTANT NAME', 'TOTAL'];
    }

    List<List<String>> data = [];
    try {
      // ✅ Build table rows
      data = List.generate(sortedRows.length, (index) {
        final r = sortedRows[index];
        final judgeScores = (r['judgeScores'] ?? {}) as Map<String, num>;

        final scores = criteriaColumns.map((judgeId) {
          return judgeScores[judgeId]?.toString() ?? "0";
        }).toList();

        return [
          '${index + 1}',
          r['contestant'] ?? ''.toUpperCase(),
          ...scores,
          (r['total'] ?? 0).toString(),
        ];
      });
    } catch (e) {
      data = [];
    }

    // Colors
    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);
    final PdfColor highlightColor = PdfColors.yellow;
    final PdfColor headerColor = PdfColor.fromInt(0xFFFFC400);
    final PdfColor secondaryColor = PdfColor.fromHex("#F57C00"); // Orange
    final PdfColor brandColor = PdfColor.fromInt(0xFFF47820); // yellow
    final PdfColor brandBlue = PdfColor.fromInt(0xFF1E88E5); // #1E88E5 blue
    final PdfColor brandGreen = PdfColor.fromInt(0xFF43A047); // #43A047 green
    final PdfColor brandPurple = PdfColor.fromInt(0xFF8E24AA); // #8E24AA
    final PdfColor brandRed = PdfColor.fromInt(0xFFE53935); // #E53935
    final PdfColor brandTeal = PdfColor.fromInt(0xFF00897B); // #00897B
    const PdfColor brandOrange = PdfColor.fromInt(0xFFF47820); // #F47820
    const PdfColor brandYellow = PdfColor.fromInt(0xFFFBB03B); // #FBB03B
    const PdfColor brandGreen1 = PdfColor.fromInt(0xFF009444); // #009444
    const PdfColor brandWhite = PdfColor.fromInt(0xFFFFFFFF); // #FFFFFF
    PdfColor brandRed2 = PdfColor.fromInt(0xFFED1C24); // #ED1C24

    try {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            // 🔹 Header
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(12),
                  bottomRight: pw.Radius.circular(12),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
                          eventTitle,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          '$zone - $division'.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 13,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          "JUDGE SCORE SHEET",
                          style: pw.TextStyle(
                            fontSize: 13,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          subtitle,
                          style: pw.TextStyle(
                            fontSize: 13,
                            color: PdfColors.white,
                          ),
                        ),

                        pw.Text(
                          'JUDGES: ${criteriaColumns.join(", ")}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontStyle: pw.FontStyle.italic,
                            color: PdfColors.white,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'EPISODE: $episode'.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                        // pw.Text(
                        //   'TOTAL MARKS: $totalMarks',
                        //   style: pw.TextStyle(
                        //     fontSize: 11,
                        //     color: PdfColors.white,
                        //   ),
                        // ),
                        pw.SizedBox(height: 2),

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

            pw.SizedBox(height: 20),

            // 🔹 Table
            pw.Table(
              border: pw.TableBorder.all(color: primaryColor, width: 0.6),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.7),
                1: const pw.FlexColumnWidth(3.5),
                for (var i = 2; i < headers.length - 1; i++)
                  i: const pw.FlexColumnWidth(1.5),
                headers.length - 1: const pw.FlexColumnWidth(1.8),
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: brandColor),
                  children: headers.map((h) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        h,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 10,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),

                // Data Rows
                for (var i = 0; i < data.length; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i == 0 ? highlightColor : PdfColors.white,
                    ),
                    children: [
                      for (var j = 0; j < data[i].length; j++)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            data[i][j],
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: i == 0
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                              color: PdfColors.black,
                            ),
                            textAlign: j == 1
                                ? pw.TextAlign.left
                                : pw.TextAlign.center,
                          ),
                        ),
                    ],
                  ),
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Powered by Kologsoft',
                style: pw.TextStyle(
                  fontStyle: pw.FontStyle.italic,
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      return pdf.save();
    } catch (e) {
      return <int>[];
    }
  }
}
