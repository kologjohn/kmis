/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class viewScorePage extends StatefulWidget {
  const viewScorePage({super.key});

  @override
  State<viewScorePage> createState() => _viewScorePageState();
}

class _viewScorePageState extends State<viewScorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.clearContestantDetails();
      provider.fetchScoredMarks();
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
    double maxWidth = 900;
    double colSpacing = screenWidth > 800
        ? 35
        : screenWidth > 600
        ? 25
        : 10;
    final provider = Provider.of<Myprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, Routes.scores);
          },
        ),
        backgroundColor: const Color(0xFF2D2F45),
        title:  Text("Recorded Marks For ${provider.regionName} ${provider.levelName}${" "}(${provider.episodeName})",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          final marks = provider.scoredList.where((m) {
            final name = (m['studentName'] ?? '').toString().toLowerCase();
            return name.contains(_searchText);
          }).toList();

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.topCenter,
           child:  Column(
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
                color: const Color(0xFF2D2F45),
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
                        columnSpacing: colSpacing,
                        columns: const [
                          DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Code', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Score', style: TextStyle(color: Colors.white))),
                        ],

                        rows: marks.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final mark = entry.value;
                          final imageUrl = mark['photoUrl'] ?? '';
                          final scores = mark['scores'] as Map<String, dynamic>? ?? {};
                          return DataRow(
                            onSelectChanged: (_) async{
                              provider.clearContestantDetails();
                             await provider.setContestantDetails(scoringid: mark['id'],studentId: mark['studentId'] , studentName: mark['studentName'], photoUrl: mark['photoUrl'],pagekey: 'nokia3310',scores:scores );
                              Navigator.pushNamed(context, Routes.autoform2,
                              );
                            },
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,

                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      mark['studentName'] ?? '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(mark['studentId'] ?? '')),
                              DataCell(Text(mark['totalscore'] ?? '')),

                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
          ),);
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class viewScorePage extends StatefulWidget {
  const viewScorePage({super.key});

  @override
  State<viewScorePage> createState() => _viewScorePageState();
}

class _viewScorePageState extends State<viewScorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.clearContestantDetails();
      provider.fetchScoredMarks();
      provider.fetchAccessComponents();
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
    double maxWidth = 900;
    double colSpacing = screenWidth > 800
        ? 35
        : screenWidth > 600
        ? 25
        : 10;
    final provider = Provider.of<Myprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go(Routes.scores);
          },
        ),
        backgroundColor: const Color(0xFF2D2F45),
        title: Text(
          "Recorded Marks For ${provider.regionName} ${provider.levelName} (${provider.episodeName})",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<Myprovider>(
        builder: (context, provider, _) {
          final marks = provider.scoredList.where((m) {
            if (_searchText.isEmpty) return true;

            // Collect all searchable fields
            final values = [
              (m['studentName'] ?? '').toString().toLowerCase(),
              (m['studentId'] ?? '').toString().toLowerCase(),
              (m['totalscore'] ?? '').toString().toLowerCase(),
              (m['id'] ?? '').toString().toLowerCase(),
            ];

            // Match if any column contains the search text
            return values.any((v) => v.contains(_searchText));
          }).toList();

          // if (provider.isLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                  Expanded(
                    child: Container(
                      width: maxWidth,
                      color: const Color(0xFF2D2F45),
                      child: marks.isEmpty
                          ? const Center(
                              child: Text(
                                "No marks found",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: marks.length,
                              itemBuilder: (context, idx) {
                                final mark = marks[idx];
                                final index = idx + 1;
                                final imageUrl = mark['photoUrl'] ?? '';
                                final scores =
                                    mark['scores'] as Map<String, dynamic>? ??
                                    {};
                                return Card(
                                  color: Colors.white10,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage(
                                                  'assets/images/bookwormlogo.jpg',
                                                )
                                                as ImageProvider,
                                    ),
                                    title: Text(
                                      mark['studentName'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Code: ${mark['studentId'] ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          'Score: ${mark['totalscore'] ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      index.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () async {
                                      provider.clearContestantDetails();
                                      await provider.setContestantDetails(
                                        scoringid: mark['id'],
                                        studentId: mark['studentId'],
                                        studentName: mark['studentName'],
                                        photoUrl: mark['photoUrl'],
                                        pagekey: 'nokia3310',
                                        scores: scores,
                                      );
                                      context.go(Routes.autoform2);
                                    },
                                  ),
                                );
                              },
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
