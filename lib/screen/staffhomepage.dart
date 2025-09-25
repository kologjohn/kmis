
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';
import 'actionbuttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    int count = mediaWidth > 600 ? 3 : 2;
    return Consumer<Myprovider>(
      builder: (context, provider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Welcome ${provider.name} ~ ${provider.auth.currentUser?.email ?? "No user"}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: actionButtons(provider, context),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D2F45), Color(0xFF1B1C2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FutureBuilder<DocumentSnapshot>(
              future: provider.db
                  .collection("teacherSetup")
                  .doc("KS0002_${provider.academicyrid}_${provider.term}")
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildMessage("An error occurred. Please try again.");
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildMessage("No subjects/classes assigned yet.");
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;

                final Map<String, dynamic> classesMap =
                Map<String, dynamic>.from(data['classname'] ?? {});
                final Map<String, dynamic> subjectsMap =
                Map<String, dynamic>.from(data['subjects'] ?? {});

                if (classesMap.isEmpty || subjectsMap.isEmpty) {
                  return _buildMessage("No subjects/classes assigned yet.");
                }

                final List<Map<String, dynamic>> assignedList = [];
                for (final classEntry in classesMap.values) {
                  for (final subjectEntry in subjectsMap.values) {
                    assignedList.add({
                      "class": classEntry['name'],
                      "subject": subjectEntry['name'],
                      "subjectkey": subjectEntry['id'],
                      "department": classEntry['department'],
                    });
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: mediaWidth > 900
                          ? 1.8
                          : mediaWidth > 600
                          ? 1.3
                          : 1.0,
                    ),
                    itemCount: assignedList.length,
                    itemBuilder: (context, index) {
                      final entry = assignedList[index];
                      final color =
                      Colors.primaries[index % Colors.primaries.length];

                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: color.withOpacity(0.3),
                        onTap: () {
                          context.go(
                            Routes.staffscoring,
                            extra: {
                              "subject": entry['subject'],
                              "level": entry['class'],
                              "department": entry['department'],
                              "subjectkey": entry['subjectkey'],
                            },
                          );
                        },
                        child: _buildClickableCard(
                          context,
                          icon: Icons.book_rounded,
                          title: "${entry['subject']} (${entry['class']})",
                          color: color,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  Widget _buildClickableCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
      }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
