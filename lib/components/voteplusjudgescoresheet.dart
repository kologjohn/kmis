
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ScoreSheetPrinterVoteJudge {
  final String eventTitle;
  final String subtitle;
  final String zone;
  final String episode;
  final String division;
  final String logoAssetPath;
  final String totalMarks;
  final List<String> judgeColumns;
  final List<Map<String, dynamic>> rows;

  ScoreSheetPrinterVoteJudge({
    required this.eventTitle,
    required this.subtitle,
    required this.zone,
    required this.episode,
    required this.division,
    required this.logoAssetPath,
    required this.totalMarks,
    required this.judgeColumns,
    required this.rows,
  });

  /// Custom number formatting
  String formatNum(dynamic value) {
    if (value == null) return '0.0';
    final num? parsed = num.tryParse(value.toString());
    if (parsed == null) return '0.0';

    double val = parsed.toDouble();
    double decimalPart = val - val.floor();

    if (decimalPart >= 0.5) {
      return val.ceil().toStringAsFixed(0);
    } else if (decimalPart <= 0.44) {
      return val.floor().toStringAsFixed(0);
    } else {
      return val.toStringAsFixed(1);
    }
  }

  Future<List<int>> generatePdf(PdfPageFormat format,  title) async {
    final pdf = pw.Document(title: title);

    // Load logo
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    // Build rows with calculations
    List<Map<String, dynamic>> calculatedRows = rows.map((r) {
      final judges = judgeColumns.map((j) {
        final score = (r['judges'] as Map<String, dynamic>?)?[j] ?? 0;
        return score is num ? score : num.tryParse(score.toString()) ?? 0;
      }).toList();

      final total = judges.fold<num>(0, (sum, s) => sum + s);
      final total60 = total * 0.6;

      final votes = r['votes'] ?? 0;
      final votesNum = votes is num ? votes : num.tryParse(votes.toString()) ?? 0;
      final votes40 = votesNum * 0.4;

      final overall = total60 + votes40;

      return {
        'contestant': r['contestant'] ?? '',
        'judges': judges,
        'total': total,
        'total60': total60,
        'votes': votesNum,
        'votes40': votes40,
        'overall': overall,
      };
    }).toList();

    // Sort by overall descending
    calculatedRows.sort((a, b) {
      final num overallA = (a['overall'] ?? 0) as num;
      final num overallB = (b['overall'] ?? 0) as num;
      return overallB.compareTo(overallA);
    });

    // Prepare table data
    final headers = <String>[
      '#',
      'CONTESTANT NAME',
      ...List.generate(judgeColumns.length, (i) => 'JUDGE ${i + 1}'),
      'TOTAL',
      '60% TOTAL',
      'VOTES',
      '40% VOTES',
      'OVERALL',
    ];

    final data = List.generate( calculatedRows.length, (index) {
      final r = calculatedRows[index];
      return [
        '${index + 1}',
        r['contestant'] ?? '',
        ...r['judges'].map(formatNum),
        formatNum(r['total']),
        formatNum(r['total60']),
        formatNum(r['votes']),
        formatNum(r['votes40']),
        formatNum(r['overall']),
      ];
    });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.copyWith(
          marginLeft: 10,
          marginRight: 10,
        ),
        build: (context) => [
          // Header with logo
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoImage != null)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey700, width: 1),
                  ),
                  child: pw.Image(logoImage, width: 60, height: 60),
                ),
              if (logoImage != null) pw.SizedBox(width: 15),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      eventTitle,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      subtitle,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('$zone - $division',
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('EPISODE: $episode',
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('TOTAL MARKS: $totalMarks',
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Table
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.5),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
            },
            columnWidths: {
              0: const pw.FixedColumnWidth(30),
            },
          ),

          pw.SizedBox(height: 20),
          pw.Text('Powered by Kologsoft',
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
        ],
      ),
    );

    return pdf.save();
  }
}
