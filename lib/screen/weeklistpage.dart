import 'package:ksoftsms/screen/episodereg.dart';
import 'package:ksoftsms/screen/registerzone.dart';
import 'package:ksoftsms/screen/seasonreg.dart';
import 'package:ksoftsms/screen/weekreg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';

import '../controller/routes.dart';

class WeekListPage extends StatefulWidget {
  const WeekListPage({super.key});

  @override
  State<WeekListPage> createState() => _WeekListPageState();
}

class _WeekListPageState extends State<WeekListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<Myprovider>(context, listen: false).getfetchWeeks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Weeks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.dashboard),
        ),
      ),
      backgroundColor: const Color(0xFF1F1F2C),
      body: Consumer<Myprovider>(
        builder: (context, provider,child) {
          if (provider.weeks.isEmpty) {
            return const Center(
              child: Text(
                "No weeks found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            itemCount: provider.weeks.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final week = provider.weeks[index];

              return ListTile(
                title: Text(
                  week.weekname ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        context.go(Routes.weekreg);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => WeekRegistration(weekData: week),
                        //   ),
                        // );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete ${week.weekname}',
                      onPressed: () async {
                        await provider.deleteData(
                          "weeks",
                          week.id,

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
