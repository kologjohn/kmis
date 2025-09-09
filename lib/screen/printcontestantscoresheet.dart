
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class GenerateScoreSheet extends StatefulWidget {
  const GenerateScoreSheet({super.key});

  @override
  State<GenerateScoreSheet> createState() => _GenerateScoreSheetState();
}

class _GenerateScoreSheetState extends State<GenerateScoreSheet> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<Myprovider>().fetchJudges());

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 1000;
    double colSpacing = screenWidth > 800 ? 26
        : screenWidth > 600 ? 8  : 5;
     return Scaffold(
      backgroundColor: const Color(0xFF1B1D2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text("Student Score Sheet", style: TextStyle(color: Colors.white60)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          if (provider.loadingJudges) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.judgeData.isEmpty) {
            return const Center(
                child: Text("No judges found.", style: TextStyle(color: Colors.white60)));
          }
          // Filter data by search
          List<Map<String, dynamic>> filteredData = provider.judgeData.where((data) {
            final searchLower = searchQuery.toLowerCase();
            return data.values.any((value) =>
            value != null && value.toString().toLowerCase().contains(searchLower));
          }).toList();

          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: maxWidth,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search judge, region, level, or episode...",
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
                          columns: const [
                            DataColumn(label: Text("No.")),
                            DataColumn(label: Text("Judge (Phone)")),
                            DataColumn(label: Text("Region")),
                            DataColumn(label: Text("Level")),
                            DataColumn(label: Text("Episode")),
                            DataColumn(label: Text("Has Data")),
                          ],
                          rows: filteredData.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final data = entry.value;
                            final phone = data['judge'];
                            provider.getjname(phone);
                            final levels = List<String>.from(data['levels'] ?? []);
                            return DataRow(
                              cells: [
                                DataCell(Text(index.toString(),
                                    style: const TextStyle(color: Colors.white60))),
                                DataCell(
                                    Tooltip(
                                      message: provider.getJudgeName(phone) ?? "Loading...",
                                      child: Text(data['judge'] ?? '',
                                        style: const TextStyle(color: Colors.white60)),)
                                ),
                                DataCell(Text(data['region'] ?? '',
                                    style: const TextStyle(color: Colors.white60))),
                                DataCell(
                                   Tooltip(
                                     message:"select single or multiple levels",
                                     child: DropdownButton<String>(
                                       dropdownColor: const Color(0xFF2D2F45),
                                       value: data['selectedLevel'],
                                       style: const TextStyle(color: Colors.white60),
                                       items: levels.map((level) {
                                         return DropdownMenuItem<String>(
                                           value: level,
                                           child: Text(level),
                                         );
                                       }).toList(),
                                       onChanged: (newValue) {
                                         setState(() {
                                           data['selectedLevel'] = newValue!;
                                         });
                                       },
                                     ),
                                   ),
                                ),
                                DataCell(Text(data['episode'] ?? '',
                                    style: const TextStyle(color: Colors.white60))),
                                DataCell(
                                 Tooltip(
                                   message:"click to view sheet",
                                   child:  Icon(
                                     (data['hasData'] == true)
                                         ? Icons.check_circle
                                         : Icons.cancel,
                                     color: (data['hasData'] == true)
                                         ? Colors.green
                                         : Colors.red,
                                   ),
                                 ),
                                ),
                              ],
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  provider.generateScoreSheetForJudge(data, context);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
