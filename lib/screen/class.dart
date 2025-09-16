import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/classmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class ClassScreen extends StatefulWidget {
  final ClassModel? classes;
  const ClassScreen({super.key, this.classes});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final classController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.classes;
    if (data != null) {
      classController.text = data.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFFffffff);
    final isEdit = widget.classes != null;

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (BuildContext context, Myprovider value, Widget? child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF00273a),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go(Routes.dashboard),
                  ),
                  title: Text(
                    isEdit ? 'Edit Class' : 'Register Class',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: const Color(0xFFffffff),
                      margin: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: classController,
                                decoration: InputDecoration(
                                  labelText: "Class Name",
                                  hintText: "Enter Class Name",
                                  labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                                  hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[700]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[700]!,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF00496d),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  filled: false,
                                  fillColor: inputFill,
                                ),
                                style: const TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Class name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            final progress = ProgressHUD.of(context);
                                            progress!.show();

                                            String className = classController.text.trim();
                                            String id = className.replaceAll(RegExp(r'\s+'), '').toLowerCase();
                                            final data = ClassModel(
                                              id: className.toLowerCase(),
                                              name: className,
                                              timestamp: DateTime.now(),
                                            ).toMap();

                                            await value.db
                                                .collection('classes')
                                                .doc(id)
                                                .set(data, SetOptions(merge: true));

                                            progress.dismiss();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isEdit
                                                      ? 'Class updated successfully'
                                                      : 'Class registered successfully',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            if (!isEdit) {
                                              classController.clear();
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          isEdit ? Icons.update : Icons.save,
                                        ),
                                        label: Text(
                                          isEdit ? 'Update Class' : 'Register Class',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF00496d),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 15,
                                          ),
                                          textStyle: const TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          context.go(Routes.viewclass);
                                        },
                                        icon: const Icon(
                                          Icons.list,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'View Classes',
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF00496d),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 15,
                                          ),
                                          textStyle: const TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                        ),
                                      ),
                                    ],
                                  )
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
}
