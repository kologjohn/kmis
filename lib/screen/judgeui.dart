import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JudgeGroundScreen extends StatefulWidget {
  const JudgeGroundScreen({Key? key}) : super(key: key);

  @override
  State<JudgeGroundScreen> createState() => _JudgeGroundScreenState();
}

class _JudgeGroundScreenState extends State<JudgeGroundScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> episodesList = [];
  Map<String, dynamic>? selectedEpisode;
  List<Map<String, dynamic>> criteriaList = [];
  final Map<String, TextEditingController> scoreControllers = {};

  bool loadingEpisodes = false;
  bool loadingCriteria = false;

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    setState(() => loadingEpisodes = true);
    try {
      final snap = await FirebaseFirestore.instance
          .collection('episodesheading')
          .get();

      episodesList = snap.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'episodeTitle': data['episodeTitle'] ?? '',
        };
      }).toList();

      setState(() {});
    } catch (e) {
      debugPrint('Error fetching episodes: $e');
    } finally {
      setState(() => loadingEpisodes = false);
    }
  }

  Future<void> fetchCriteria(String episodeId) async {
    setState(() {
      loadingCriteria = true;
      criteriaList.clear();
      scoreControllers.clear();
    });
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('episodesheading')
          .doc(episodeId)
          .get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        final List<dynamic> criteria = data['criteria'] ?? [];

        criteriaList = criteria.map((c) {
          final crit = Map<String, dynamic>.from(c);
          scoreControllers[crit['name']] = TextEditingController();
          return crit;
        }).toList();

        setState(() {});
      }
    } catch (e) {
      debugPrint('Error fetching criteria: $e');
    } finally {
      setState(() => loadingCriteria = false);
    }
  }

  void submitScores() {
    if (_formKey.currentState!.validate()) {
      final Map<String, int> scores = {};
      for (var c in criteriaList) {
        scores[c['name']] = int.parse(scoreControllers[c['name']]!.text.trim());
      }
      debugPrint('Submitted Scores: $scores');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Scores submitted successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Judge Ground"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Episode Dropdown
            loadingEpisodes
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Episode",
                border: OutlineInputBorder(),
              ),
              value: selectedEpisode?['id'],
              items: episodesList.map<DropdownMenuItem<String>>((ep) {
                return DropdownMenuItem<String>(
                  value: ep['id'] as String,
                  child: Text(ep['episodeTitle'] as String),
                );
              }).toList(),
              onChanged: (val) {
                final ep = episodesList.firstWhere((e) => e['id'] == val);
                setState(() => selectedEpisode = ep);
                fetchCriteria(val!);
              },
              validator: (value) =>
              value == null ? "Please select an episode" : null,
            ),
            const SizedBox(height: 20),

            // Dynamic Criteria Form
            if (loadingCriteria)
              const CircularProgressIndicator()
            else if (criteriaList.isNotEmpty)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemCount: criteriaList.length,
                    itemBuilder: (context, index) {
                      final crit = criteriaList[index];
                      final max = crit['max'] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          controller: scoreControllers[crit['name']],
                          decoration: InputDecoration(
                            labelText:
                            "${crit['name']} (Max: $max)",
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter score for ${crit['name']}";
                            }
                            final num? parsed = num.tryParse(value);
                            if (parsed == null) {
                              return "Enter a valid number";
                            }
                            if (parsed > max) {
                              return "Score cannot exceed $max";
                            }
                            if (parsed < 0) {
                              return "Score cannot be negative";
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Submit Button
            if (criteriaList.isNotEmpty)
              ElevatedButton(
                onPressed: submitScores,
                child: const Text("Submit Scores"),
              ),
          ],
        ),
      ),
    );
  }
}
