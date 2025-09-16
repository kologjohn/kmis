import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/componentmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';
import 'dropdown.dart';

class AccessComponent extends StatefulWidget {
  final ComponentModel? component;
  const AccessComponent({super.key,this.component});


  @override
  State<AccessComponent> createState() => _RevenueGridPageState();
}

class _RevenueGridPageState extends State<AccessComponent> {
  final componentname = TextEditingController();
  final totalmark = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? level;

  @override
  void dispose() {
    componentname.dispose();
    totalmark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFFffffff);
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
                  title: const Text(
                    'Access Components',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                                controller: componentname,
                                decoration: InputDecoration(
                                  labelText: "Component Name",
                                  hintText: "Enter Component Name",
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
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                style: const TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Component name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: totalmark,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Total Mark",
                                  hintText: "Enter Total Mark",
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
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                style: const TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Total mark cannot be empty';
                                  }
                                  if (int.tryParse(value.trim()) == null) {
                                    return 'Total mark must be a number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Save + View Buttons
                              Column(
                                children: [
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00496d),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(8),
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final progress =
                                                ProgressHUD.of(context);
                                                progress!.show();

                                                try {
                                                  String categoryName =componentname.text.trim();
                                                  String totalMark = totalmark.text.trim();
                                                  String totalMar = totalmark.text.trim();
                                                  String id = "${value.schoolid}_${totalMar.replaceAll(RegExp(r'\s+'), '').toLowerCase()}";

                                                  final data = ComponentModel(
                                                    name: categoryName,
                                                    totalMark: totalMark,
                                                    dateCreated: DateTime.now(),
                                                    schoolId: value.schoolid,
                                                  );

                                                  // Save as Map
                                                  await value.db.collection("assesscomponent").doc(id).set(data.toJson());
                                                  progress.dismiss();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Data Saved Successfully"),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );

                                                  setState(() {
                                                    level = null;
                                                  });
                                                  componentname.clear();
                                                  totalmark.clear();
                                                } catch (e) {
                                                  progress.dismiss();
                                                  debugPrint(
                                                      "❌ Error saving data: $e");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Failed to save data: $e"),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.save,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Save Access',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            context.go(Routes.accesslist),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFffffff),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Color(0xFF00496d), width: 1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.list, color: Color(0xFF00496d)),
                                              SizedBox(width: 8),
                                              Text(
                                                "View Access",
                                                style: TextStyle(
                                                  color: Color(0xFF00496d),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
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
