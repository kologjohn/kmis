import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ScoreSheetPrinter {
  final String eventTitle;
  final String subtitle;
  final String zone;
  final String episode;
  final String division;
  final List<Map<String, String>>? rows;
  final String? totalMarks;
  final String logoAssetPath;
  final String? companyName;

  ScoreSheetPrinter({
    required this.eventTitle,
    required this.subtitle,
    required this.zone,
    required this.episode,
    required this.division,
    required this.logoAssetPath,
    this.rows,
    this.totalMarks,
    this.companyName,
  });

  Future<void> printOrPreview(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        name: '${companyName}_ScoreSheet.pdf'.toUpperCase(),
        onLayout: (format) async {
          final pdf = pw.Document(title:'${companyName}_SCORE_SHEET' );

          // Load logo
          pw.MemoryImage? logoImage;
          try {
            final logoBytes = await rootBundle.load(logoAssetPath);
            logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
          } catch (_) {
            logoImage = null;
          }

          final bool hasStructuredRows = rows != null && rows!.isNotEmpty;

          //Collect criteria dynamically (exclude name + total)
          final criteria = <String>[];
          if (hasStructuredRows) {
            final firstRow = rows!.first;
            criteria.addAll(firstRow.keys
                .where((k) => k != "name" && k != "total")
                .toList());
          }

          List<List<String>> tableData = [];

          if (hasStructuredRows) {
            // Sort rows by total (descending)
            final sortedRows = [...rows!];
            sortedRows.sort((a, b) {
              final totalA = double.tryParse(a['total'] ?? "0") ?? 0.0;
              final totalB = double.tryParse(b['total'] ?? "0") ?? 0.0;
              return totalB.compareTo(totalA);
            });

            // Generate table data dynamically
            tableData = List.generate(sortedRows.length, (index) {
              final r = sortedRows[index];
              return [
                '${index + 1}', // Rank
                ( r['name'] ?? '').toUpperCase().toString(),
                //( r['code'] ?? '').toUpperCase().toString(),
                ...criteria.map((c) => r[c] ?? ''), // Dynamic criteria
                r['total'] ?? '',
              ];
            });
          }

          final String totalHeader =
          (totalMarks ?? '').trim().isNotEmpty ? totalMarks!.trim() : '0';

          // ✅ Dynamic headers
          final List<String> headers = [
            '#',
            'CONTESTANT NAME',
            ...criteria.map((c) => c.toUpperCase()),
            'TOTAL\n($totalHeader)',
          ];

          //Colors
          final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5); // Blue
          final PdfColor brandColor = PdfColor.fromInt(0xFFF47820);// yellow
          final PdfColor secondaryColor = PdfColor.fromInt(0xFFF57C00); // Orange
          final PdfColor brandBlue = PdfColor.fromInt(0xFF1E88E5); // #1E88E5 blue
          final PdfColor brandGreen = PdfColor.fromInt(0xFF43A047); // #43A047 green
          final PdfColor brandPurple = PdfColor.fromInt(0xFF8E24AA); // #8E24AA
          final PdfColor brandRed = PdfColor.fromInt(0xFFE53935); // #E53935
          final PdfColor brandTeal = PdfColor.fromInt(0xFF00897B); // #00897B
          const PdfColor brandOrange = PdfColor.fromInt(0xFFF47820); // #F47820
           const PdfColor brandYellow = PdfColor.fromInt(0xFFFBB03B); // #FBB03B
           const PdfColor brandGreen1  = PdfColor.fromInt(0xFF009444); // #009444
           const PdfColor brandWhite  = PdfColor.fromInt(0xFFFFFFFF); // #FFFFFF
            PdfColor brandRed2    = PdfColor.fromInt(0xFFED1C24); // #ED1C24
           const PdfColor brandBlack  = PdfColor.fromInt(0xFF000000); // #000000

          pdf.addPage(
            pw.MultiPage(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(20),
              build: (context) => [
                // 🔹 Header
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 20, horizontal: 15),
                  decoration: pw.BoxDecoration(
                    color: primaryColor,
                    borderRadius: const pw.BorderRadius.only(
                      bottomLeft: pw.Radius.circular(12),
                      bottomRight: pw.Radius.circular(12),
                    ),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
                              subtitle,
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColors.white,
                              ),
                            ),
                            pw.Text(
                              '$zone - $division'.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'EPISODE: $episode'.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 14,
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

                pw.SizedBox(height: 20),

                // 🔹 Dynamic Styled Table
                pw.Table.fromTextArray(
                  headers: headers,
                  data: tableData,
                  border: pw.TableBorder.all(color: primaryColor, width: 0.6),
                  headerDecoration: pw.BoxDecoration(color: brandColor ),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  cellStyle: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                  ),
                  cellHeight: 25,
                  columnWidths: {
                    0: const pw.FlexColumnWidth(0.7),
                    1: const pw.FlexColumnWidth(3.5),
                    for (int i = 0; i < criteria.length; i++)
                      i + 2: const pw.FlexColumnWidth(1.5),
                    criteria.length + 2: const pw.FlexColumnWidth(1.8),
                  },
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    for (int i = 0; i < criteria.length; i++)
                      i + 2: pw.Alignment.center,
                    criteria.length + 2: pw.Alignment.center,
                  },
                ),

                pw.SizedBox(height: 15),

                if (hasStructuredRows)
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Total score shown per contestant (out of $totalHeader).',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),

                pw.SizedBox(height: 25),
                pw.Center(
                  child: pw.Text(
                    'Powered by Kologsoft',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );

          return pdf.save();
        },
      );
    } catch (e) {
      debugPrint("PDF Generation Error: $e");
    }
  }
}


