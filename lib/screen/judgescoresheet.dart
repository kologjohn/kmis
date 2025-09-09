
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class JudgeScoreSheet extends StatefulWidget {
  const JudgeScoreSheet({super.key});

  @override
  State<JudgeScoreSheet> createState() => _JudgeScoreSheetState();
}

class _JudgeScoreSheetState extends State<JudgeScoreSheet> {
  String searchQuery = "";
  int? sortColumnIndex;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchscoringData();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900;
    double colSpacing = screenWidth > 800
        ? 56 : screenWidth > 600 ? 40  : 10;
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text("Judge Score Sheet",
            style: TextStyle(color: Colors.white60)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          if (provider.isLoadingjudge) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.distinctMeta.isEmpty) {
            return const Center(
                child: Text("No data found",
                    style: TextStyle(color: Colors.white60)));
          }
           List<Map<String, String>> filteredData = provider.distinctMeta
              .where((meta) => meta.values.any((value) =>

        value != null && value.toLowerCase().contains(searchQuery.toLowerCase()))).toList();


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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

                    // Meta Table (Region/Zone/Level/Episode)
                    Container(
                      width: maxWidth,
                      color: const Color(0xFF2D2F45),
                      child: filteredData.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No matching results",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey)),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: maxWidth),
                          child: DataTable(
                            columnSpacing: colSpacing,
                            headingRowColor:
                            WidgetStateProperty.all(Colors.transparent),
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            columns: [
                              DataColumn(
                                label: const Text("Region"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["region"] ?? "",
                                    i,
                                    asc,
                                    filteredData),
                              ),
                              DataColumn(
                                label: const Text("Zone"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["zone"] ?? "",
                                    i,
                                    asc,
                                    filteredData),
                              ),
                              DataColumn(
                                label: const Text("Level"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["level"] ?? "",
                                    i,
                                    asc,
                                    filteredData),
                              ),
                              DataColumn(
                                label: const Text("Episode"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["episode"] ?? "",
                                    i,
                                    asc,
                                    filteredData),
                              ),
                            ],
                            rows: filteredData.map((meta) {
                              return DataRow(
                                onSelectChanged: (_) {
                                 provider.previewPDF(meta);

                                },
                                cells: [
                                  DataCell(
                                    Tooltip(
                                      message:"click to view to region",
                                      child: Text(meta["region"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white60)),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message:"click to view zone result",
                                      child: Text(meta["zone"] ?? "",
                                          style: const TextStyle(
                                            color: Colors.white60)),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message:"Click to view level result",
                                      child: Text(meta["level"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white60)),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message:"click to view episode result",
                                      child: Text(meta["episode"] ?? "",
                                      style: const TextStyle(color: Colors.white60)),
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
