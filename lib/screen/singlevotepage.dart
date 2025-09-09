import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class SingleVotePage extends StatefulWidget {
  @override
  _SingleVotePageState createState() => _SingleVotePageState();
}

class _SingleVotePageState extends State<SingleVotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _scoreController = TextEditingController();

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double inputWidth = 400;
    final inputFill = const Color(0xFF2C2C3C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, Routes.home);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              tooltip: "View votes",
              color: Colors.white,
              icon: const Icon(Icons.add_chart_sharp),
              onPressed: () {
                Navigator.pushNamed(context, Routes.viewvotes);
              },
            ),
          ),
        ],
        title: const Text(
          "Score Sheet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E2C),
      body: Consumer<Myprovider>(
        builder: (context, value, child) {
          if (value.pagekeyvote != "votes3310") {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                  SizedBox(height: 12),
                  Text("Permission denied. Please select a contestant first."),
                ],
              ),
            );
          }

          final imageUrl = value.imageUrl;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: const Color(0xFF2D2F45),
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Profile section
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: (imageUrl != null && imageUrl.trim().isNotEmpty)
                                        ? NetworkImage(imageUrl)
                                        : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    value.contestantName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Text(
                                    value.contestantID,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Single input field
                          SizedBox(
                            width: inputWidth,
                            child: TextFormField(
                              controller: _scoreController,
                              decoration: InputDecoration(
                                labelText: "Votes", // Static label
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: inputFill,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                final intValue = int.tryParse(val.trim());
                                if (intValue == null || intValue < 0) {
                                  return 'Enter a non-negative number';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Save button
                          ElevatedButton.icon(
                            onPressed: value.isLoading
                                ? null
                                : () async {
                              if (_formKey.currentState?.validate() ?? false)  {
                                String totalvotes = _scoreController.text.trim();
                                await value.setContestantScore(value.scoringid, totalvotes,);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Score saved successfully!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                               Navigator.pushNamed(context, Routes.votinglist);
                              }
                            },
                            icon: value.isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Icon(Icons.save),
                            label: value.isLoading
                                ? const Text('')
                                : const Text('Save Score'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ],
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
