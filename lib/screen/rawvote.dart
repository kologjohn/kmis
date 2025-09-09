import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class Rawvote extends StatefulWidget {
  const Rawvote({super.key});

  @override
  State<Rawvote> createState() => _RawvoteState();
}

class _RawvoteState extends State<Rawvote> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchDataVotes(); // <-- fetch from datavotes
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
        title: const Text("Raw Votes", style: TextStyle(color: Colors.white60)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white60),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          if (provider.isLoadingVotes) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.dataVotes.isEmpty) {
            return const Center(
              child: Text("No votes found",
                  style: TextStyle(color: Colors.white60)),
            );
          }

          // Apply search filter
          List<Map<String, dynamic>> filteredData = provider.dataVotes
              .where((vote) =>
          vote["choice_text"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
              vote["region"]
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search box
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: maxWidth,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search by name or region...",
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
                    // Table
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
                            WidgetStateProperty.all(Colors.black26),
                            columns: const [
                              DataColumn(
                                  label: Text("ID",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Name",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Region",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Votes",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Percent",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Image",
                                      style: TextStyle(
                                          color: Colors.white60))),
                              DataColumn(
                                  label: Text("Vote Date",
                                      style: TextStyle(
                                          color: Colors.white60))),
                            ],
                            rows: filteredData.map((vote) {
                              return DataRow(cells: [
                                DataCell(Text(vote["id"].toString(),
                                    style: const TextStyle(
                                        color: Colors.white60))),
                                DataCell(Text(vote["choice_text"] ?? "",
                                    style: const TextStyle(
                                        color: Colors.white60))),
                                DataCell(Text(vote["region"] ?? "",
                                    style: const TextStyle(
                                        color: Colors.white60))),
                                DataCell(Text(
                                    vote["num_of_votes"].toString(),
                                    style: const TextStyle(
                                        color: Colors.white60))),
                                DataCell(Text(
                                    vote["result_percent"].toString(),
                                    style: const TextStyle(
                                        color: Colors.white60))),
                                DataCell(
                                  Image.network(
                                    vote["image"] ?? "",
                                    height: 40,
                                    width: 40,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                    const Icon(Icons.error,
                                        color: Colors.red),
                                  ),
                                ),
                                DataCell(Text(vote["votedate"] ?? "",
                                    style: const TextStyle(
                                        color: Colors.white60))),
                              ]);
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
