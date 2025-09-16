import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/termmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class Term extends StatefulWidget {
  final TermModel? term;
  const Term({super.key, this.term});

  @override
  State<Term> createState() => _TermState();
}

class _TermState extends State<Term> {
  final termname = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.term;
    if (data != null) {
      termname.text = data.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.term != null;
    final docId = widget.term?.id;

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
                    isEdit ? 'Edit Term' : 'Register Term',
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
                                controller: termname,
                                decoration: InputDecoration(
                                  labelText: "Term Name",
                                  hintText: "Enter Term Name",
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
                                    return 'Term name cannot be empty';
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

                                        String term = termname.text.trim();
                                        String id = "${value.schoolid}_${term.replaceAll(RegExp(r'\s+'), '').toLowerCase()}";
                                        final data = TermModel(
                                          id: id,
                                          name: term,
                                          schoolId: value.schoolid,
                                          timestamp: DateTime.now(),
                                        ).toMap();

                                        await value.db
                                            .collection('terms')
                                            .doc(id)
                                            .set(data, SetOptions(merge: true));
                                        await value.db.collection('schools').doc(value.schoolid)
                                            .update({
                                          "term": term,
                                          "updatedAt": DateTime.now(),
                                        });
                                        progress.dismiss();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isEdit
                                                  ? 'Term updated successfully'
                                                  : 'Term registered successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        if (!isEdit) {
                                          termname.clear();
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      isEdit ? Icons.update : Icons.save,
                                    ),
                                    label: Text(
                                      isEdit ? 'Update Term' : 'Register Term',
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
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.go(Routes.viewterm);
                                    },
                                    icon: const Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'View Terms',
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
