import 'package:ksoftsms/screen/episodereg.dart';
import 'package:ksoftsms/screen/registerzone.dart';
import 'package:ksoftsms/screen/seasonreg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';

import '../controller/routes.dart';
import 'levelreg.dart';

class Viewterms extends StatefulWidget {
  const Viewterms({super.key});

  @override
  State<Viewterms> createState() => _ViewtermsState();
}

class _ViewtermsState extends State<Viewterms> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(
    //       () => Provider.of<Myprovider>(context, listen: false).getfetchLevels(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Terms', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      backgroundColor: const Color(0xFF1F1F2C),
      body: Consumer<Myprovider>(
        builder: (BuildContext context, Myprovider provider, Widget? child) {
          if (provider.levelss.isEmpty) {
            return const Center(
              child: Text(
                "No levels found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            itemCount: provider.levelss.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final level = provider.levelss[index];

              return ListTile(
                title: Text(
                  level.levelname ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),

                      onPressed: () {
                        context.go(Routes.term, extra: level);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete ${level.levelname}',
                      onPressed: () async {
                        // await provider.deleteData(
                        //   "term",
                        //   level.id,
                        // );
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
