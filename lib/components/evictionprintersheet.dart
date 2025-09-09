
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class EvictionScoreSheetPrinter {
  final String eventTitle;
  final String subtitle;   // e.g. SEASON ONE (1) OFFICIAL EVICTION RESULTS
  final String division;   // e.g. UPPER CATEGORY
  final String? zone;      // optional
  final String? episode;   // e.g. Ep4 or Ep4+Ep5
  final List<String>? selectedEpisodes;
  final String logoAssetPath;
  final List<Map<String, dynamic>> rows;
  final int highlightBottom; // highlight last N rows

  EvictionScoreSheetPrinter({
    required this.eventTitle,
    required this.subtitle,
    required this.division,
    required this.logoAssetPath,
    required this.rows,
    this.zone,
    this.episode,
    this.selectedEpisodes,
    this.highlightBottom = 0,
  });

  num parseNum(dynamic v) {
    try {
      if (v == null) return 0;
      if (v is num) return v;
      if (v is String) return num.tryParse(v) ?? 0;
      return 0;
    } catch (_) {
      return 0;
    }
  }

  String formatNum(dynamic value) {
    try {
      final parsed = parseNum(value);
      return parsed.toStringAsFixed(2);
    } catch (_) {
      return "0.00";
    }
  }

  Future<Uint8List> generatePdf(PdfPageFormat format,title) async {
    final pdf = pw.Document(title: title,author: 'kologsoft');

    // Load logo safely
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    // Sort rows safely
    List<Map<String, dynamic>> sortedRows = [];
    try {
      sortedRows = List<Map<String, dynamic>>.from(rows)
        ..sort((a, b) => parseNum(b['TOTAL']).compareTo(parseNum(a['TOTAL'])));
    } catch (_) {
      sortedRows = List<Map<String, dynamic>>.from(rows);
    }

    // Headers
    final headers = const [
      '#',
      'NAMES',
      'CODE',
      'TJS',
      '60%',
      'CWW',
      '40%',
      'TOTAL',
    ];

    // Build table data with filter (skip rows where both TJS and CWW == 0)
    List<List<String>> data = [];
    try {
      int visibleIndex = 0;
      for (var r in sortedRows) {
        final tjs = parseNum(r['TJS']);
        final cww = parseNum(r['CWW']);

        if (tjs == 0 && cww == 0) {
          continue;
        }

        visibleIndex++;
        data.add([
          '$visibleIndex',
          (r['contestant'] ?? '').toString().toUpperCase(),
          (r['code'] ?? '').toString().toUpperCase(),
          tjs.toString(),
          formatNum(r['60%']),
          cww.toString(),
          formatNum(r['40%']),
          formatNum(r['TOTAL']),
        ]);
      }
    } catch (_) {
      data = [];
    }

    // Theme colors
    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E88E5);
    final PdfColor brandColor = PdfColor.fromInt(0xFFF47820);

    try {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: format.copyWith(marginLeft: 15, marginRight: 15),
          build: (context) => [
            // Header
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
                        pw.SizedBox(height: 2),
                        pw.Text(
                          subtitle,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          division,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                        if (zone != null && zone!.isNotEmpty)
                          pw.Text(
                            "ZONE: $zone",
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                            ),
                          ),
                        if (episode != null && episode!.isNotEmpty)
                          pw.Text(
                            "EPISODE(S): $episode",
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                            ),
                          ),
                        if (selectedEpisodes != null && selectedEpisodes!.isNotEmpty)
                          pw.Text(
                            "Selected Episodes: ${selectedEpisodes!.join(', ')}",
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontStyle: pw.FontStyle.italic,
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

            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(25),
                1: const pw.FlexColumnWidth(2.5),
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: brandColor),
                  children: headers.map((h) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        h,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),

                // Data rows with highlight logic
                for (var i = 0; i < data.length; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i < 0
                          ? PdfColors.yellow100
                          : (i >= data.length - highlightBottom
                          ? PdfColors.red100
                          : PdfColors.white),
                    ),
                    children: [
                      for (var j = 0; j < data[i].length; j++)
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                          child: pw.Text(
                            data[i][j],
                            style: pw.TextStyle(
                              fontSize: 10,
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

            pw.SizedBox(height: 18),
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
    } catch (_) {}

    try {
      return Uint8List.fromList(await pdf.save());
    } catch (_) {
      return Uint8List(0);
    }
  }
}


