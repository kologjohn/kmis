
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/myprovider.dart';
import '../controller/routes.dart';

class AdminResultsPage extends StatefulWidget {
  const AdminResultsPage({super.key});

  @override
  State<AdminResultsPage> createState() => _AdminResultsPageState();
}

class _AdminResultsPageState extends State<AdminResultsPage> {
  bool isRowLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String?selectedlevel;
  String?selectedepisode;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final provider = Provider.of<Myprovider>(context, listen: false);
        await provider.getdata();
        await provider.assignedJudges();

      // await provider.fetchScoringMarks();
        //await provider.clearContestantDetails();
    });

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900; // same width for search & table
    double colSpacing = screenWidth > 800 ? 35
        : screenWidth > 600
        ? 25
        : 10;
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final filteredRows = value.getFilteredGroupedStaff(_searchText);

        return Scaffold(
          backgroundColor: Color(0xFF1B1D2A),
          appBar: AppBar(
            backgroundColor: Color(0xFF2D2F45),
            title: Text(
              "Assigned Levels",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go(Routes.dashboard);
              },
            ),
          ),
          body: value.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: "Search Contestants",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.white60,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: maxWidth,
                        height: MediaQuery.of(context).size.height * 0.7,
                        color: Color(0xFF2D2F45),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: maxWidth,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                showCheckboxColumn: false,
                                columnSpacing:colSpacing,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'ID',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Judge',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Region',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Level',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Episode',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Zone',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],

                                rows: filteredRows.map((item) {
                               final index = value.assignedjudges.indexWhere((staff) =>
                                staff['name'] == item['name'] && staff['region'] == item['region']) + 1;

                          return DataRow(
                          cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Text(item['name'],)),
                          DataCell(Text(item['region'],)),
                          DataCell(DropdownButton<String>(
                          value: selectedlevel,
                          items: (item['levels'] as Set<String>).map((level) => DropdownMenuItem(value: level, child: Text(level))).toList(),
                          onChanged: (val) => setState(() => selectedlevel = val),
                          )),
                          DataCell(Text(value.episodeName ?? '')),
                          DataCell(Text(item['zone'],)),
                          ],
                          onSelectChanged: (_) {
                          if (selectedlevel == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar( content: Text( 'Please select both level and episode before proceeding.',
                           style: TextStyle(color: Colors.white), ),
                           backgroundColor: Colors.redAccent,
                           behavior: SnackBarBehavior.floating,
                           duration: Duration(seconds: 2), ), ); return;
                          }
                          // value.setstaffmarks(
                          // phone: item['name'],
                          // level: selectedlevel!,
                          // episode: value.episodeName,
                          // zone: item['zone'],
                          // region: item['region'],
                          // );
                           context.go(Routes.scores);
                          },
                          );
                          }).toList()

                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
            ),),
        );
      },
    );
  }
}
