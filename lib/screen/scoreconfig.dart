import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/scoremodel.dart';

class ScoreConfigPage extends StatefulWidget {
  final ScoremodelConfig? config;
  const ScoreConfigPage({super.key, this.config});

  @override
  State<ScoreConfigPage> createState() => _ScoreConfigPageState();
}

class _ScoreConfigPageState extends State<ScoreConfigPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController continuousController;
  late TextEditingController examController;

  @override
  void initState() {
    super.initState();
    continuousController =
        TextEditingController(text: widget.config?.continuous.toString() ?? '');
    examController =
        TextEditingController(text: widget.config?.exam.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.config != null;

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (context, provider, _) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF2D2F45),
                  title: Text(
                    isEdit ? "Edit Score Config" : "New Score Config",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: const Color(0xFF2D2F45),
                      margin: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: continuousController,
                                decoration: const InputDecoration(
                                  labelText: "Continuous (%)",
                                  hintText: "Enter continuous score",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Continuous cannot be empty";
                                  }
                                  final num? val = num.tryParse(value);
                                  if (val == null) return "Enter a valid number";
                                  if (val < 0 || val > 100) {
                                    return "Must be between 0 and 100";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: examController,
                                decoration: const InputDecoration(
                                  labelText: "Exam (%)",
                                  hintText: "Enter exam score",
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Exam cannot be empty";
                                  }
                                  final num? val = num.tryParse(value);
                                  if (val == null) return "Enter a valid number";
                                  if (val < 0 || val > 100) {
                                    return "Must be between 0 and 100";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    progress?.show();

                                    try {
                                      final continuous = double.parse(
                                          continuousController.text.trim());
                                      final exam =
                                      double.parse(examController.text.trim());

                                      if (continuous + exam != 100) {
                                        progress?.dismiss();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Continuous + Exam must equal 100%"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                             final id = widget.config?.id ?? ("${provider.companyid}${continuous}${exam}").replaceAll(RegExp(r'\s+'), '')
                                              .toLowerCase();

                                      final scoreConfig = ScoremodelConfig(
                                        id: id.toString(),
                                        companyid: provider.companyid,
                                        continuous: continuous.toString(),
                                        exam: exam.toString(),
                                      ).toMap();

                                      await provider.db
                                          .collection("scoreconfig")
                                          .doc(id)
                                          .set(scoreConfig, SetOptions(merge: true));

                                      progress?.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(isEdit
                                              ? "Config updated successfully"
                                              : "Config saved successfully"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      if (!isEdit) {
                                        setState(() {
                                          continuousController.clear();
                                          examController.clear();
                                        });
                                      }
                                    } catch (e) {
                                      progress?.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Error: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon:
                                Icon(isEdit ? Icons.update : Icons.save),
                                label:
                                Text(isEdit ? "Update Config" : "Save Config"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
