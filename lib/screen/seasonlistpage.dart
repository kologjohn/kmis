import 'package:ksoftsms/screen/episodereg.dart';
import 'package:ksoftsms/screen/registerzone.dart';
import 'package:ksoftsms/screen/seasonreg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';

import '../controller/routes.dart';

class SeasonListPage extends StatefulWidget {
  const SeasonListPage({super.key});

  @override
  State<SeasonListPage> createState() => _SeasonListPageState();
}

class _SeasonListPageState extends State<SeasonListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch zones when page loads
    Future.microtask(
      () => Provider.of<Myprovider>(context, listen: false).getfetchSeasons(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Season', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      backgroundColor: const Color(0xFF1F1F2C),
      body: Consumer<Myprovider>(
        builder: (context,provider,child) {
          if (provider.seasons.isEmpty) {
            return const Center(
              child: Text(
                "No seasons found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            itemCount: provider.seasons.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final season = provider.seasons[index];

              return ListTile(
                title: Text(
                  season.seasonname ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
context.go(Routes.seasonreg);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) =>
                        //         SeasonRegistration(seasonData: season),
                        //   ),
                        // );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete ${season.seasonname}',
                      onPressed: () async {
                        await provider.deleteData(
                          "seasons",
                          season.id,

                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
