
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

class ScoreSheetPrinter1 {
  final String eventTitle;
  final String subtitle;
  final String zone;
  final String episode;
  final String division;
  final String logoAssetPath;
  final List<String> judgeColumns;
  final List<Map<String, dynamic>> rows;

  ScoreSheetPrinter1({
    required this.eventTitle,
    required this.subtitle,
    required this.zone,
    required this.episode,
    required this.division,
    required this.logoAssetPath,
    required this.judgeColumns,
    required this.rows,
  });

  /// Generate PDF bytes
  Future<Uint8List> generatePdf(PdfPageFormat format,title) async {
    try {
      final pdf = pw.Document(title: title,author: 'kologsoft');

      // Load logo safely
      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load(logoAssetPath);
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (e) {
        print("Error loading logo: $e");
        logoImage = null;
      }

      //  Sort rows safely
      final sortedRows = [...rows];
      try {
        sortedRows.sort((a, b) {
          final aTotal = (a['overall'] ?? 0.0) as double;
          final bTotal = (b['overall'] ?? 0.0) as double;
          return bTotal.compareTo(aTotal);
        });
      } catch (e) {
        print(" Error sorting rows: $e");
      }

      //Build headers
      final headers = <String>[
        '#',
        'CONTESTANT NAME',
        'CODE',
        ...judgeColumns.map((j) => j.toUpperCase()),
        'OVERALL TOTAL',
      ];

      //  Build table rows safely
      final data = <List<String>>[];
      try {
        for (int index = 0; index < sortedRows.length; index++) {
          final r = sortedRows[index];
          final judges = judgeColumns.map((j) {
            try {
              final score = (r['judges'] as Map<String, dynamic>)[j] ?? 0;
              return score.toString();
            } catch (e) {
              print("Error reading judge score: $e");
              return "0";
            }
          }).toList();

          data.add([
            '${index + 1}',
            (r['contestant'] ?? '').toString().toUpperCase(),
            (r['code'] ?? '').toString().toUpperCase(),
            ...judges,
            (r['overall'] ?? 0).toString(),
          ]);
        }
      } catch (e) {
        print("Error building table data: $e");
      }

      //Theme colors
      final PdfColor primaryColor = PdfColor.fromHex("#1E88E5"); // Blue
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
              //Header
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
                            subtitle,
                            style: pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            '$zone  $division'.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 13,
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

              // 🔹 Table
              pw.Table.fromTextArray(
                headers: headers,
                data: data,
                border: pw.TableBorder.all(color: primaryColor, width: 0.6),
                headerDecoration: pw.BoxDecoration(color: brandColor),
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
                  for (var i = 2; i < headers.length - 1; i++) i: const pw.FlexColumnWidth(1.5),
                  headers.length - 1: const pw.FlexColumnWidth(1.8),
                },
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  for (var i = 2; i < headers.length; i++) i: pw.Alignment.center,
                },
                headerAlignments: {
                  for (var i = 0; i < headers.length; i++)
                    i: (i == 1 ? pw.Alignment.centerLeft : pw.Alignment.center),
                },
              ),

              pw.SizedBox(height: 20),

              // Footer
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
        print("Error building PDF page: $e");
      }

      return Uint8List.fromList(await pdf.save());
    } catch (e) {
      print("Error generating PDF: $e");
      return Uint8List(0); // return empty PDF bytes on error
    }
  }
}