import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class WeeklyScoreSheet extends StatefulWidget {
  const WeeklyScoreSheet({super.key});

  @override
  State<WeeklyScoreSheet> createState() => _WeeklyScoreSheetState();
}

class _WeeklyScoreSheetState extends State<WeeklyScoreSheet> {
  String searchQuery = "";
  int? sortColumnIndex;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchWeeklyVotescoringData();
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
    double colSpacing = screenWidth > 800 ? 56
        : screenWidth > 600 ? 40: 10;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text(
          "Weekly Score Sheet",
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
          if (provider.isLoadingweeklysheet) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.weeklysheetdistinctMeta.isEmpty) {
            return const Center(
              child: Text("No data found",
                  style: TextStyle(color: Colors.white60)),
            );
          }
          // Filter distinct meta by search query
          List<Map<String, String>> filteredMeta = provider.weeklysheetdistinctMeta
              .where((meta) => meta.values.any((value) =>
          value != null &&
              value.toLowerCase().contains(searchQuery.toLowerCase())))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Search bar
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
                            headingRowColor: WidgetStateProperty.all(
                                Colors.transparent),
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            columns: [
                              DataColumn(
                                label: const Text("Region"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["region"] ?? "",
                                    i,
                                    asc,
                                    filteredMeta),
                              ),
                              DataColumn(
                                label: const Text("Zone"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["zone"] ?? "",
                                    i,
                                    asc,
                                    filteredMeta),
                              ),
                              DataColumn(
                                label: const Text("Level"),
                                onSort: (i, asc) => onSort(
                                        (meta) => meta["level"] ?? "",
                                    i,
                                    asc,
                                    filteredMeta),
                              ),
                              DataColumn(
                                label: const Text("Episode"),
                                onSort: (i, asc) => onSort(
                                (meta) => meta["episode"] ?? "",
                                    i,
                                    asc,
                                    filteredMeta),
                              ),
                              const DataColumn(
                                label: Text("Status"),
                              ),
                            ],
                            rows: filteredMeta.map((meta) {
                              //check against tableData
                              bool hasData = provider.tableData1.any((row) {
                                return (row["region"]?.toString() ?? "") ==
                                    (meta["region"] ?? "") &&
                                    (row["zone"]?.toString() ?? "") ==
                                        (meta["zone"] ?? "") &&
                                    (row["level"]?.toString() ?? "") ==
                                        (meta["level"] ?? "") &&
                                    (row["episode"]?.toString() ?? "") ==
                                        (meta["episode"] ?? "");
                              });

                          return DataRow(onSelectChanged: (_) =>
                                    provider.weeklysheetpreviewPDFVote(meta),
                                cells: [
                                  DataCell(
                                    Tooltip(
                                      message:"Click to view results",
                                      child: Text(meta["region"] ?? "",
                                       style: const TextStyle(color: Colors.white60)),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                    message:"click gto view results",
                                    child: Text(meta["zone"] ?? "",
                                        style: const TextStyle(
                                            color: Colors.white60)),
                                  ),),
                                  DataCell(
                                    Tooltip(
                                      message:"click to view results",
                                      child: Text(meta["level"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white60)),
                                    ),
                                  ),
                                  DataCell(Tooltip(
                                      message: '${meta["episode"]}  results',
                                    child: Text(meta["episode"] ?? "",
                                        style: const TextStyle(
                                            color: Colors.white60)),
                                  )),
                                  DataCell(
                                    Tooltip(
                                      message:"Contain results if green",
                                      child: hasData
                                       ? const Icon(Icons.check_circle,
                                       color: Colors.green)
                                       : const Icon(Icons.cancel,
                                       color: Colors.red),
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
