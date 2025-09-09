import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';
import 'actionbuttons.dart';

class JudgeLandingPage extends StatefulWidget {
  const JudgeLandingPage({super.key});
  @override
  State<JudgeLandingPage> createState() => _JudgeLandingPageState();
}

class _JudgeLandingPageState extends State<JudgeLandingPage> {
  @override
  Widget build(BuildContext context) {
    int count = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    double mediawidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<Myprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${provider.userName.toUpperCase()}-(${provider.regionName.toUpperCase()})-${provider.episodeName.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2F45),
        foregroundColor: Colors.white,
        actions: actionButtons(provider, context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: mediawidth * 0.98,
          decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.3)),
          child: Consumer<Myprovider>(
            builder: (context, value, child) {
              return FutureBuilder(
                future: value.db
                    .collection("judgeSetup")
                    .where("episode", isEqualTo: provider.episodeName)
                    .where("judge", isEqualTo: value.phone)
                    .get(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return const Center(
                      child: Text(
                        "An error occurred. Please try again later.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  if (!asyncSnapshot.hasData ||
                      asyncSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No levels assigned.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  List<dynamic> assignedLevels =
                      asyncSnapshot.data!.docs[0]['levels'];
                  // Responsive aspect ratio
                  double aspectRatio = mediawidth > 900
                      ? 1.8
                      : mediawidth > 600
                      ? 1.3
                      : 1.0;
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: assignedLevels.length,
                      itemBuilder: (context, index) {
                        final level = assignedLevels[index].toString();
                        final color = Colors.primaries[index % Colors.primaries.length];
                        return InkWell(
                          onTap: () {
                            provider.fetchScoringMarks(provider.phone, level);
                            value.setstaffmarks(level: level);
                            context.go(Routes.scores);
                          },
                          child: _buildClickableCard(
                            context,
                            icon: Icons.star,
                            title: level,
                            color: color,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
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
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.folder_copy_outlined,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
