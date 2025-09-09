
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/dbmodels/episodeModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class EvictionSheet extends StatefulWidget {
  const EvictionSheet({super.key});

  @override
  State<EvictionSheet> createState() => _EvictionSheetState();
}

class _EvictionSheetState extends State<EvictionSheet> {
  String searchQuery = "";
  int? sortColumnIndex;
  bool isAscending = true;

  // Store selected episodes per row (key = region+zone+level+episodeId)
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
