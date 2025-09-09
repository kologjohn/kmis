import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class CriteriaScoreSheet extends StatefulWidget {
  const CriteriaScoreSheet({super.key});

  @override
  State<CriteriaScoreSheet> createState() => _CriteriaScoreSheetState();
}

class _CriteriaScoreSheetState extends State<CriteriaScoreSheet> {
  String searchQuery = "";
  int? sortColumnIndex;
  bool isAscending = true;

  ///Track selected criteria per meta row
  final Map<String, String?> selectedCriteria = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchBestCriteria();
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
    double maxWidth = 1000;
    double colSpacing = screenWidth > 800 ? 36 : screenWidth > 600 ? 30 : 10;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text("Criteria Score Sheet", style: TextStyle(color: Colors.white60)),
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
            return const Center(child: Text("No data found", style: TextStyle(color: Colors.white60)));
          }
          List<Map<String, String>> filteredData = provider.distinctMeta
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
                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: maxWidth,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search region, zone, level, or episode...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.white60,
                            filled: true,
                          ),
                          onChanged: (value) => setState(() => searchQuery = value),
                        ),
                      ),
                    ),
                    // Table
                    Container(
                      width: maxWidth,
                      color: const Color(0xFF2D2F45),
                      child: filteredData.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No matching results",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: maxWidth),
                          child: DataTable(
                            columnSpacing: colSpacing,
                            headingRowColor: WidgetStateProperty.all(Colors.transparent),
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            columns: [
                              const DataColumn(label: Text("Region")),
                              const DataColumn(label: Text("Zone")),
                              const DataColumn(label: Text("Level")),
                              const DataColumn(label: Text("Episode")),
                              const DataColumn(label: Text("Criteria")),
                              const DataColumn(label: Text("Report")),
                            ],
                            rows: filteredData.map((meta) {
                              final metaKey = meta["metaKey"]?.toString() ?? '';
                              final criteriaList = (provider.bestCriteriaData[metaKey]?["criteria"] as List<String>? ?? []);

                              return DataRow(
                                cells: [
                                  DataCell(Text(meta["region"] ?? "", style: const TextStyle(color: Colors.white60))),
                                  DataCell(Text(meta["zone"] ?? "", style: const TextStyle(color: Colors.white60))),
                                  DataCell(Text(meta["level"] ?? "", style: const TextStyle(color: Colors.white60))),
                                  DataCell(Text(meta["episode"] ?? "", style: const TextStyle(color: Colors.white60))),

                                  // Criteria dropdown
                                  DataCell(
                                    Tooltip(
                                      message:"click to select the episode criteria",
                                      child: DropdownButton<String>(
                                        dropdownColor: Color(0xFF2D2F45), // dark dropdown
                                        value: selectedCriteria[metaKey],
                                        hint: const Text("Select", style: TextStyle(color: Colors.white60)),
                                        items: criteriaList.map((c) {
                                          return DropdownMenuItem(
                                            value: c,
                                            child: Text(c, style: const TextStyle(color: Colors.white)),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCriteria[metaKey] = val;
                                          });
                                        },
                                      ),
                                    ),

                                  ),
                                  // Report button
                                  DataCell(
                                    Tooltip(
                                      message: "Click to view the best contestant under the selected episode",
                                      child: IconButton(
                                        icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                                        onPressed: () {
                                          final chosen = selectedCriteria[metaKey];
                                          if (chosen == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Please select a criteria first")),
                                            );
                                            return;
                                          }
                                          provider.criteriaPDF(meta, chosen);
                                        },
                                      ),
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
