import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:ksoftsms/controller/dbmodels/episodeModel.dart';

import 'episodereg.dart';

class EpisodeListPage extends StatefulWidget {
  const EpisodeListPage({super.key});

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<Myprovider>(context, listen: false);
      await provider.getfetchEpisodes();
    });
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
      builder: (context, value, child) {
        final episodes = value.episodes;

        return Scaffold(
          backgroundColor: const Color(0xFF1B1D2A),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            backgroundColor: const Color(0xFF2D2F45),
            title: const Text(
              "Episodes List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: value.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: maxWidth,
                    height: MediaQuery.of(context).size.height * 0.7,
                    color: const Color(0xFF2D2F45),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columnSpacing: colSpacing,
                            columns: const [
                              DataColumn(
                                label: Text('No.',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Episode',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Time',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Total Mark',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Criterial Total Mark',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Action',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            rows: episodes.asMap().entries.map((entry) {
                              final index = entry.key;
                              final EpisodeModel episode = entry.value;
                                print(episode.id);
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}',
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(Text(episode.episodename ?? "-",
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(Text(
                                      episode.time
                                          .toLocal()
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        episode.totalMark ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        episode.cmt ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => EpisodeRegistration(
                                                  episodeData: {
                                                    "id": episode.id,
                                                    "name": episode.episodename,
                                                    "totalMark": episode.totalMark,
                                                    "cmt": episode.cmt,
                                                    "timestamp": episode.time.toIso8601String(),
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          tooltip: 'Delete ${episode.episodename}',
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.white, // Ensure dialog is visible
                                                title: Text(
                                                  "Delete ${episode.episodename}?",
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                ),
                                                content: const Text(
                                                  "This action cannot be undone.",
                                                  style: TextStyle(color: Colors.black87),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red, // Delete button in red
                                                      foregroundColor: Colors.white, // Text/icon white
                                                    ),
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await value.deletedocument("episodes", episode.id);
                                            }
                                          },
                                        )

                                      ],
                                    ),
                                  ),

                                ],
                              );
                            }).toList(),
                          ),
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
    );
  }
}
