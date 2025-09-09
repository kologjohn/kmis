import 'package:ksoftsms/screen/actionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class JudgeScoringPage extends StatefulWidget {
  const JudgeScoringPage({super.key});

  @override
  State<JudgeScoringPage> createState() => _JudgeScoringPageState();
}

class _JudgeScoringPageState extends State<JudgeScoringPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.clearContestantDetails();
      provider.fetchScoringMarks(provider.phone,provider.levelName);
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

    return Consumer<Myprovider>(
      builder: (BuildContext context, value, Widget? child) {
        final filteredMarks = value.marksList.where((m) {
          if (_searchText.isEmpty) return true;
          final values = [
            (m['id'] ?? '').toString().toLowerCase(),
            (m['studentName'] ?? '').toString().toLowerCase(),
            (m['studentId'] ?? '').toString().toLowerCase(),
            (m['level'] ?? '').toString().toLowerCase(),
          ];
          return values.any((v) => v.contains(_searchText));
        }).toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            foregroundColor: Colors.white,
            title: Text(
              "Contestants For - ${value.regionName}- ${value.levelName}-(${value.episodeName})- ${value.seasonName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go(Routes.judgelandingpage);
              },
            ),
            actions: actionButtons(value, context),
          ),
          body: Padding(
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
                      child: ListView.builder(
                        itemCount: filteredMarks.length,
                        itemBuilder: (context, idx) {
                          final mark = filteredMarks[idx];
                          final index = value.marksList.indexOf(mark) + 1;
                          final scores =
                              mark['scores'] as Map<String, dynamic>? ?? {};
                          return Card(
                            color: Colors.white10,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Text(
                                  index.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                mark['studentName'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Code: ${mark['studentId'] ?? ''}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Level: ${mark['level'] ?? ''}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                value.setContestantDetails(
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
          ),
        );
      },
    );
  }
}
