/*
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/dbmodels/episodeModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({super.key});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  String searchQuery = "";
  int? sortColumnIndex;
  bool isAscending = true;

  // Store selected
  final Map<String, Set<String>> rowSelectedEpisodes = {};
  final Map<String, int> rowEvictionNumbers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<Myprovider>();
      provider.fetchEvictionVotescoringData();
      provider.getfetchEpisodes();
    });
  }

  void onSort<T>(
      Comparable<T> Function(Map<String, String> meta) getField,
      int columnIndex,
      bool ascending,
      List<Map<String, String>> data,
      ) {
    data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  //Dialog for selecting multiple episodes
  Future<void> _showEpisodeSelector(
      BuildContext context,
      List<EpisodeModel> episodes,
      String rowKey, {
        String? defaultEpisode,
      }) async {
    final selected = rowSelectedEpisodes[rowKey] ?? <String>{};

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2F45),
          title: const Text("Select Episodes",
              style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (context, setSB) {
              return SizedBox(
                width: 300,
                height: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: episodes.map((ep) {
                    final checked = selected.contains(ep.episodename);
                    return CheckboxListTile(
                      value: checked,
                      title: Text(ep.episodename,
                          style: const TextStyle(color: Colors.white70)),
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      onChanged: (val) {
                        setSB(() {
                          setState(() {
                            if (val == true) {
                              selected.add(ep.episodename);
                            } else {
                              selected.remove(ep.episodename);
                            }
                            rowSelectedEpisodes[rowKey] = selected;
                          });
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
              const Text("Close", style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const double maxWidth = 1000;
    final double colSpacing =
    screenWidth > 800 ? 16 : screenWidth > 600 ? 10 : 10;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text(
          "Eviction Sheet",
          style: TextStyle(color: Colors.white60),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          if (provider.isLoadingEvictionvote) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.EvictionWeeklyMeta2.isEmpty) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white60),
              ),
            );
          }

          // filter meta table
          final List<Map<String, String>> filteredMeta =
          provider.EvictionWeeklyMeta2.where((meta) {
            return meta.values.any((value) =>
            value != null &&
                value.toLowerCase().contains(searchQuery.toLowerCase()));
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: maxWidth,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                            "Search region, zone, level, or episode...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                          ),
                          onChanged: (value) =>
                              setState(() => searchQuery = value),
                        ),
                      ),
                    ),

                    // Meta Table
                    Container(
                      width: maxWidth,
                      color: const Color(0xFF2D2F45),
                      child: filteredMeta.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "No matching results",
                          style:
                          TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                          const BoxConstraints(minWidth: maxWidth),
                          child: DataTable(
                            columnSpacing: colSpacing,
                            headingRowColor:
                            MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent),
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            columns: const [
                              DataColumn(label: Text("Region")),
                              DataColumn(label: Text("Zone")),
                              DataColumn(label: Text("Level")),
                              DataColumn(label: Text("Episode ID")),
                              DataColumn(label: Text("Episodes")),
                              DataColumn(label: Text("Evic #")),
                              DataColumn(label: Text("Report")),
                            ],
                            rows: filteredMeta.map((meta) {
                              // row key unique with episodeId
                              final rowKey =
                                  "${meta["region"]}-${meta["zone"]}-${meta["level"]}-${meta["episodeId"]}";

                              // Meta episode (if exists)
                              final metaEpisode = meta["episode"];

                              // Row selection
                              final selected =
                                  rowSelectedEpisodes[rowKey] ?? {};

                              return DataRow(
                                cells: [
                                  DataCell(Text(meta["region"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white60))),
                                  DataCell(Text(meta["zone"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white60))),
                                  DataCell(Text(meta["level"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white60))),
                                  DataCell(Text(meta["episodeId"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white60))),
                                  // 🔹 Episode Selector
                                  DataCell(
                                    Tooltip(
                                      message:"Select the episodes to use for the eviction",
                                      child: InkWell(
                                        onTap: () => _showEpisodeSelector(
                                          context,
                                          provider.episodes,
                                          rowKey,
                                          defaultEpisode: metaEpisode,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (selected.isNotEmpty)
                                                    ? selected.join(", ")
                                                    : "Select episodes",
                                                style: const TextStyle(
                                                    color: Colors.white70),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white70,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message: "Enter the number to evict",
                                      child: SizedBox(
                                        width: 60, // adjust width as needed
                                        child: TextFormField(
                                          initialValue: rowEvictionNumbers[rowKey]?.toString() ?? "0",
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            labelText: "",
                                          ),
                                          onChanged: (value) {
                                            final number = int.tryParse(value) ?? 0;
                                            setState(() {
                                              rowEvictionNumbers[rowKey] = number;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) return "Enter Number";
                                            if (int.tryParse(value) == null) return "Enter a valid number";
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                  ),
                                  // 🔹 PDF Button
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: "Generate Report",
                                      onPressed: () {
                                        final evictionnum = rowEvictionNumbers[rowKey] ?? 0;
                                        if (selected.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please select episodes first")),
                                          );
                                          return;
                                        }
                                        provider.EvictionpreviewPDFVote(
                                          meta,
                                          selectedEpisodeIds:
                                          selected.toList(),
                                          evictionnum: evictionnum,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';

import '../components/terminalreportsheetprinter.dart';
import '../controller/routes.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({super.key});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  String? selectedSchool;
  String? selectedLevel;
  String? selectedTerm;

  final List<String> schools = ["Sacred Heart Academy"];
  final List<String> levels = ["JHS2", "JHS3"];
  final List<String> terms = ["First Term", "Second Term", "Third Term"];

  // Static student dataset
  final Map<String, List<Map<String, dynamic>>> studentsData = {
    "Sacred Heart Academy-JHS2": [
      {
        "name": "ASAA COURAGE AWINTIMAM",
        "id": "SHS-0456",
        "class": "JHS2",
        "subjects": [
          {
            "code": "ENG",
            "subject": "English Language",
            "classScore": "35",
            "examScore": "55",
            "totalScore": "90",
            "remarks": "Excellent",
          },
          {
            "code": "MTH",
            "subject": "Mathematics",
            "classScore": "28",
            "examScore": "60",
            "totalScore": "88",
            "remarks": "Very Good",
          },
        ],
      },
      {
        "name": "AMMA KORANTENG",
        "id": "SHS-0457",
        "class": "JHS2",
        "subjects": [
          {
            "code": "ENG",
            "subject": "English Language",
            "classScore": "28",
            "examScore": "42",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "MTH",
            "subject": "Mathematics",
            "classScore": "30",
            "examScore": "45",
            "totalScore": "75",
            "remarks": "Good",
          },
          {
            "code": "SCI",
            "subject": "Integrated Science",
            "classScore": "30",
            "examScore": "40",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "SST",
            "subject": "Social Studies",
            "classScore": "32",
            "examScore": "47",
            "totalScore": "79",
            "remarks": "Very Good",
          },
          {
            "code": "BDT",
            "subject": "Basic Design & Technology",
            "classScore": "27",
            "examScore": "46",
            "totalScore": "73",
            "remarks": "Very Good",
          },
          {
            "code": "CRE",
            "subject": "Creative Arts",
            "classScore": "29",
            "examScore": "48",
            "totalScore": "77",
            "remarks": "Very Good",
          },
          {
            "code": "RME",
            "subject": "Religious & Moral Education",
            "classScore": "31",
            "examScore": "49",
            "totalScore": "80",
            "remarks": "Excellent",
          },
          {
            "code": "ICT",
            "subject": "Computing",
            "classScore": "25",
            "examScore": "44",
            "totalScore": "69",
            "remarks": "Good",
          },
        ],
      },
    ],
    "Sacred Heart Academy-JHS3": [
      {
        "name": "KOFI MENSAH",
        "id": "SHS-0789",
        "class": "JHS3",
        "subjects": [
          {
            "code": "SCI",
            "subject": "Integrated Science",
            "classScore": "30",
            "examScore": "40",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "SST",
            "subject": "Social Studies",
            "classScore": "32",
            "examScore": "47",
            "totalScore": "79",
            "remarks": "Very Good",
          },
        ],
      },
    ],
  };

  /// Strip unsupported characters (non-ASCII)
  String cleanText(String input) {
    return input.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  }

  /// Calculate overall class positions with competition ranking
  /// Calculate overall class positions based on total scores
  Map<String, String> calculateClassPositions(List<Map<String, dynamic>> students) {
    final totals = students.map((student) {
      final subjectScores = student["subjects"]
          .map((s) => int.tryParse(s["totalScore"].toString()) ?? 0)
          .toList();

      final total = subjectScores.isNotEmpty
          ? subjectScores.reduce((a, b) => a + b)
          : 0;

      return {
        "id": student["id"] as String,
        "total": total,
      };
    }).toList();

    // Sort by total descending
    totals.sort((a, b) => (b["total"] as int).compareTo(a["total"] as int));

    // Assign positions
    final positions = <String, String>{};
    for (int i = 0; i < totals.length; i++) {
      positions[totals[i]["id"] as String] = (i + 1).toString();
    }

    return positions;
  }


  Future<void> generateReports() async {
    if (selectedSchool == null || selectedLevel == null || selectedTerm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select school, level and term")),
      );
      return;
    }

    final key = "$selectedSchool-$selectedLevel";
    final students = studentsData[key] ?? [];

    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No students found for this selection")),
      );
      return;
    }

    // ✅ Compute class positions
    final classPositions = calculateClassPositions(students);

    final pdf = pw.Document();

    for (var student in students) {
      final report = ReportCardPrinter(
        schoolName: cleanText(selectedSchool!),
        reportTitle: "TERMINAL REPORT CARD",
        examSession: cleanText("END OF $selectedTerm EXAMINATION, 2023/2024"),
        logoAssetPathl: "assets/images/logo.png",
        logoAssetPathr: "assets/images/logo.png",
        studentName: cleanText(student["name"]),
        studentId: cleanText(student["id"]),
        studentClass: cleanText(student["class"]),
        noInClass: students.length.toString(),
        reOpeningDate: "10th September 2024",
        promotedTo: "Next Class",
        nextTermFees: "GHS705.00",
        subjects: List<Map<String, String>>.from(student["subjects"]),
        areaOfStrength: "Mathematics and English",
        areaOfInterest: "Reading & Science Projects",
        weakness: "Needs improvement in handwriting",
        attendance: "95%",
        teacherRemarks: cleanText("A hardworking student."),
        headTeacherRemarks: cleanText("Promoted to the next class."),
        position: classPositions[student["id"]] ?? '',
      );

      // Generate actual pw.Page from ReportCardPrinter
      final studentPage = await report.generatePage(PdfPageFormat.a4, "Report Card");
      pdf.addPage(studentPage);
    }

    final allBytes = await pdf.save();

    // Show merged PDF preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => allBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text(
          "Terminal Reports",
          style: TextStyle(color: Colors.white60),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: selectedSchool,
              decoration: const InputDecoration(
                labelText: "Select School",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: schools
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => selectedSchool = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              decoration: const InputDecoration(
                labelText: "Select Level",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: levels
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (val) => setState(() => selectedLevel = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTerm,
              decoration: const InputDecoration(
                labelText: "Select Term",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: terms
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => selectedTerm = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Generate Reports"),
              onPressed: generateReports,
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';

import '../components/terminalreportsheetprinter.dart';
import '../controller/routes.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({super.key});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  String? selectedSchool;
  String? selectedLevel;
  String? selectedTerm;

  final List<String> schools = ["Sacred Heart Academy"];
  final List<String> levels = ["JHS2", "JHS3"];
  final List<String> terms = ["First Term", "Second Term", "Third Term"];

  // Static student dataset
  final Map<String, List<Map<String, dynamic>>> studentsData = {
    "Sacred Heart Academy-JHS2": [
      {
        "name": "ASAA COURAGE AWINTIMAM",
        "id": "SHS-0456",
        "class": "JHS2",
        "subjects": [
          {
            "code": "ENG",
            "subject": "English Language",
            "classScore": "30",
            "examScore": "40",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "MTH",
            "subject": "Mathematics",
            "classScore": "25",
            "examScore": "50",
            "totalScore": "75",
            "remarks": "Good",
          },
          {
            "code": "SCI",
            "subject": "Integrated Science",
            "classScore": "28",
            "examScore": "42",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "SOC",
            "subject": "Social Studies",
            "classScore": "26",
            "examScore": "45",
            "totalScore": "71",
            "remarks": "Good",
          },
          {
            "code": "BDT",
            "subject": "Basic Design & Technology",
            "classScore": "27",
            "examScore": "46",
            "totalScore": "73",
            "remarks": "Very Good",
          },
          {
            "code": "CRE",
            "subject": "Creative Arts",
            "classScore": "29",
            "examScore": "48",
            "totalScore": "77",
            "remarks": "Very Good",
          },
          {
            "code": "RME",
            "subject": "Religious & Moral Education",
            "classScore": "30",
            "examScore": "50",
            "totalScore": "80",
            "remarks": "Excellent",
          },
          {
            "code": "ICT",
            "subject": "Computing",
            "classScore": "32",
            "examScore": "44",
            "totalScore": "76",
            "remarks": "Very Good",
          },
          {
            "code": "FRN",
            "subject": "French",
            "classScore": "24",
            "examScore": "40",
            "totalScore": "64",
            "remarks": "Fair",
          },
        ],
      },
      {
        "name": "AMMA KORANTENG",
        "id": "SHS-0457",
        "class": "JHS2",
        "subjects": [
          {
            "code": "ENG",
            "subject": "English Language",
            "classScore": "28",
            "examScore": "42",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "MTH",
            "subject": "Mathematics",
            "classScore": "30",
            "examScore": "45",
            "totalScore": "75",
            "remarks": "Good",
          },
          {
            "code": "SCI",
            "subject": "Integrated Science",
            "classScore": "30",
            "examScore": "40",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "SST",
            "subject": "Social Studies",
            "classScore": "32",
            "examScore": "47",
            "totalScore": "79",
            "remarks": "Very Good",
          },
          {
            "code": "BDT",
            "subject": "Basic Design & Technology",
            "classScore": "27",
            "examScore": "46",
            "totalScore": "73",
            "remarks": "Very Good",
          },
          {
            "code": "CRE",
            "subject": "Creative Arts",
            "classScore": "29",
            "examScore": "48",
            "totalScore": "77",
            "remarks": "Very Good",
          },
          {
            "code": "RME",
            "subject": "Religious & Moral Education",
            "classScore": "31",
            "examScore": "49",
            "totalScore": "80",
            "remarks": "Excellent",
          },
          {
            "code": "ICT",
            "subject": "Computing",
            "classScore": "25",
            "examScore": "44",
            "totalScore": "69",
            "remarks": "Good",
          },
        ],
      },
    ],
    "Sacred Heart Academy-JHS3": [
      {
        "name": "KOFI MENSAH",
        "id": "SHS-0789",
        "class": "JHS3",
        "subjects": [
          {
            "code": "SCI",
            "subject": "Integrated Science",
            "classScore": "30",
            "examScore": "40",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "SST",
            "subject": "Social Studies",
            "classScore": "32",
            "examScore": "47",
            "totalScore": "79",
            "remarks": "Very Good",
          },
          {
            "code": "ENG",
            "subject": "English Language",
            "classScore": "28",
            "examScore": "42",
            "totalScore": "70",
            "remarks": "Good",
          },
          {
            "code": "MTH",
            "subject": "Mathematics",
            "classScore": "30",
            "examScore": "45",
            "totalScore": "75",
            "remarks": "Good",
          },
          {
            "code": "BDT",
            "subject": "Basic Design & Technology",
            "classScore": "27",
            "examScore": "46",
            "totalScore": "73",
            "remarks": "Very Good",
          },
          {
            "code": "CRE",
            "subject": "Creative Arts",
            "classScore": "29",
            "examScore": "48",
            "totalScore": "77",
            "remarks": "Very Good",
          },
          {
            "code": "RME",
            "subject": "Religious & Moral Education",
            "classScore": "31",
            "examScore": "49",
            "totalScore": "80",
            "remarks": "Excellent",
          },
          {
            "code": "ICT",
            "subject": "Computing",
            "classScore": "25",
            "examScore": "44",
            "totalScore": "69",
            "remarks": "Good",
          },
        ],

      },
    ],
  };

  /// Strip unsupported characters (non-ASCII)
  String cleanText(String input) {
    return input.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  }

  ///Calculate overall class positions
  Map<String, String> calculateClassPositions(List<Map<String, dynamic>> students) {
    final totals = students.map((student) {
      final subjectScores = student["subjects"]
          .map((s) => int.tryParse(s["totalScore"].toString()) ?? 0)
          .toList();

      final total = subjectScores.isNotEmpty
          ? subjectScores.reduce((a, b) => a + b)
          : 0;

      return {
        "id": student["id"] as String,
        "total": total,
      };
    }).toList();

    // Sort by total descending
    totals.sort((a, b) => (b["total"] as int).compareTo(a["total"] as int));

    // Assign positions
    final positions = <String, String>{};
    for (int i = 0; i < totals.length; i++) {
      positions[totals[i]["id"] as String] = (i + 1).toString();
    }

    return positions;
  }

  /// Calculate subject positions across class
  Map<String, Map<String, String>> calculateSubjectPositions(List<Map<String, dynamic>> students) {
    final subjectScores = <String, List<Map<String, dynamic>>>{};

    // Collect scores per subject code
    for (var student in students) {
      for (var s in student["subjects"]) {
        final code = s["code"];
        final total = int.tryParse(s["totalScore"].toString()) ?? 0;

        subjectScores.putIfAbsent(code, () => []);
        subjectScores[code]!.add({
          "id": student["id"],
          "score": total,
        });
      }
    }

    // Rank within each subject
    final result = <String, Map<String, String>>{};
    subjectScores.forEach((code, entries) {
      entries.sort((a, b) => (b["score"] as int).compareTo(a["score"] as int));

      for (int i = 0; i < entries.length; i++) {
        result.putIfAbsent(entries[i]["id"], () => {});
        result[entries[i]["id"]]![code] = (i + 1).toString();
      }
    });

    return result;
  }

  Future<void> generateReports() async {
    if (selectedSchool == null || selectedLevel == null || selectedTerm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select school, level and term")),
      );
      return;
    }

    final key = "$selectedSchool-$selectedLevel";
    final students = studentsData[key] ?? [];

    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No students found for this selection")),
      );
      return;
    }

    // Compute class and subject positions
    final classPositions = calculateClassPositions(students);
    final subjectPositions = calculateSubjectPositions(students);

    final pdf = pw.Document();

    for (var student in students) {
      final updatedSubjects = List<Map<String, dynamic>>.from(student["subjects"]).map((s) {
        final pos = subjectPositions[student["id"]]?[s["code"]] ?? '';
        return {
          ...s,
          "position": pos, //add subject position
        };
      }).toList();

      final report = ReportCardPrinter(
        schoolName: cleanText(selectedSchool!),
        reportTitle: "TERMINAL REPORT CARD",
        examSession: cleanText("END OF $selectedTerm EXAMINATION, 2023/2024"),
        logoAssetPathl: "assets/images/logo.png",
        logoAssetPathr: "assets/images/logo.png",
        studentName: cleanText(student["name"]),
        studentId: cleanText(student["id"]),
        studentClass: cleanText(student["class"]),
        noInClass: students.length.toString(),
        reOpeningDate: "10th September 2024",
        promotedTo: "Next Class",
        nextTermFees: "GHS705.00",
        subjects: updatedSubjects,
        areaOfStrength: "Mathematics and English",
        areaOfInterest: "Reading & Science Projects",
        weakness: "Needs improvement in handwriting",
        attendance: "95%",
        teacherRemarks: cleanText("A hardworking student."),
        headTeacherRemarks: cleanText("Promoted to the next class."),
        position: classPositions[student["id"]] ?? '',
      );

      final studentPage = await report.generatePage(PdfPageFormat.a4, "Report Card");
      pdf.addPage(studentPage);
    }

    final allBytes = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => allBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text(
          "Terminal Reports",
          style: TextStyle(color: Colors.white60),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: selectedSchool,
              decoration: const InputDecoration(
                labelText: "Select School",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: schools
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => selectedSchool = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              decoration: const InputDecoration(
                labelText: "Select Level",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: levels
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (val) => setState(() => selectedLevel = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTerm,
              decoration: const InputDecoration(
                labelText: "Select Term",
                filled: true,
                fillColor: Colors.white70,
              ),
              items: terms
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => selectedTerm = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Generate Reports"),
              onPressed: generateReports,
            ),
          ],
        ),
      ),
    );
  }
}
