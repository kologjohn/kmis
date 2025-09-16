import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/academicyrmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class AcademicYr extends StatefulWidget {
  final AcademicModel? year;
  const AcademicYr({super.key, this.year});

  @override
  State<AcademicYr> createState() => _AcademicYrState();
}

class _AcademicYrState extends State<AcademicYr> {
  final yearName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.year;
    if (data != null) {
      yearName.text = data.name;
    }
  }
  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.year != null;
    final docId = widget.year?.id;

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
                    isEdit ? 'Edit Academic Year' : 'Register Academic Year',
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
                      color: const Color(0xFF2D2F45),
                      margin: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: yearName,
                                decoration: InputDecoration(
                                  labelText: "Academic Year",
                                  hintText: "Enter Academic Year (e.g. 2024/2025)",
                                  labelStyle: const TextStyle(color: Colors.white),
                                  hintStyle: const TextStyle(color: Colors.grey),
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
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                style: const TextStyle(fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Academic Year cannot be empty';
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

                                        String year = yearName.text.trim();
                                        String yea = yearName.text.trim().replaceAll('/', '');
                                        String id = "${value.schoolid}_${yea.replaceAll(RegExp(r'\s+'), '').toLowerCase()}";
                                        final data = AcademicModel(
                                          id: id,
                                          name: year,
                                          schoolid: value.schoolid,
                                          timestamp: DateTime.now(),
                                        ).toMap();
                                        await value.db.collection('academicyears').doc(id).set(data, SetOptions(merge: true));
                                        await value.db.collection('schools').doc(value.schoolid).update({
                                          "academicyr": year,
                                          "updatedAt": DateTime.now(),
                                        });
                                        progress.dismiss();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isEdit
                                                  ? 'Academic Year updated successfully'
                                                  : 'Academic Year registered successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        if (!isEdit) {
                                          yearName.clear();
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      isEdit ? Icons.update : Icons.save,
                                    ),
                                    label: Text(
                                      isEdit ? 'Update Year' : 'Register Year',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
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
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.go(Routes.viewacademicyr);
                                    },
                                    icon: const Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'View Academic yr',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
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
