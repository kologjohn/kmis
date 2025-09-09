import 'package:ksoftsms/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/episodeModel.dart';
import '../controller/myprovider.dart';


class EpisodeRegistration extends StatefulWidget {
  final Map<String, dynamic>? episodeData;
  const EpisodeRegistration({super.key, this.episodeData});

  @override
  State<EpisodeRegistration> createState() => _EpisodeRegistrationState();
}

class _EpisodeRegistrationState extends State<EpisodeRegistration> {
  final episode = TextEditingController();
  final totalMarkController = TextEditingController();
  final criteriaMarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.episodeData;

    if (data != null) {
      episode.text = (data['name'] ?? '').toString();
      totalMarkController.text = (data['totalMark'] ?? '').toString();
      criteriaMarkController.text = (data['cmt'] ?? '').toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.episodeData != null;

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (BuildContext context, Myprovider value, Widget? child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF2D2F45),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go(Routes.dashboard),
                  ),
                  title: Text(
                    isEdit ? 'Edit Episode' : 'Register Episode',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: const Color(0xFF2D2F45),
                      margin: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 20),

                              // Episode Name
                              TextFormField(
                                controller: episode,
                                decoration: _buildDecoration(
                                    "Episode Name", "Enter Episode Name", inputFill),
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Episode name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Total Mark
                              TextFormField(
                                controller: totalMarkController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: _buildDecoration("Total Mark",
                                    "Enter total mark for episode", inputFill),
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Total mark cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Criteria Mark Total
                              TextFormField(
                                controller: criteriaMarkController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: _buildDecoration("Criteria Mark Total",
                                    "Enter total criteria mark", inputFill),
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Criteria mark total cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final progress = ProgressHUD.of(context);
                                        progress!.show();

                                        final episodename = episode.text.trim();
                                        final episodeModel = EpisodeModel(
                                          episodename: episodename,
                                          time: DateTime.now(),
                                          totalMark: totalMarkController.text.trim(),
                                          cmt: criteriaMarkController.text.trim(),
                                          id: episodename,
                                        );

                                        final episodeData = {
                                          ...episodeModel.toMap(),
                                          'isCompleted': "false", // keep consistent with your earlier structure
                                        };

                                        try {
                                          if (isEdit) {
                                            await value.db
                                                .collection('episodes')
                                                .doc(episodename)
                                                .set(episodeData);
                                          } else {
                                            await value.db
                                                .collection('episodes')
                                                .doc(episodename)
                                                .set(episodeData);
                                          }

                                          progress.dismiss();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                isEdit ? 'Episode updated successfully' : 'Episode registered successfully'),
                                            backgroundColor: Colors.green,
                                          ));
                                        } catch (e) {
                                          progress.dismiss();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Operation failed: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      }
                                    },

                                    icon: Icon(isEdit ? Icons.update : Icons.save),
                                    label: Text(isEdit ? 'Update Episode' : 'Register Episode'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: const TextStyle(fontSize: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.go(Routes.episodelist);
                                    },
                                    icon: const Icon(Icons.list, color: Colors.white),
                                    label: const Text('View Episodes',
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: const TextStyle(fontSize: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
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

  InputDecoration _buildDecoration(String label, String hint, Color fill) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
      enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
      focusedBorder:
      const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      filled: true,
      fillColor: fill,
    );
  }
}
