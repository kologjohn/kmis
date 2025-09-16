import 'package:ksoftsms/controller/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/subjectmodel.dart';
import '../controller/myprovider.dart';

class SubjectRegistration extends StatefulWidget {
  final SubjectModel? subject;

  const SubjectRegistration({super.key, this.subject});

  @override
  State<SubjectRegistration> createState() => _SubjectRegistrationState();
}

class _SubjectRegistrationState extends State<SubjectRegistration> {
  final subjectController = TextEditingController();
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final inputFill = const Color(0xFFffffff);

  String? selectedLevel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.fetchclass();
    });

    final data = widget.subject;
    if (data != null) {
      subjectController.text = data.name;
      codeController.text = data.code ?? '';
      selectedLevel = data.level;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.subject != null;

    return ProgressHUD(
      child: Consumer<Myprovider>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF00273a),
              title: Text(
                isEdit ? "Edit Subject" : "Register Subject",
                style: const TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go(Routes.dashboard),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: const Color(0xFFffffff),
                  margin: const EdgeInsets.all(30.0),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// subject name
                          TextFormField(
                            controller: subjectController,
                            decoration: InputDecoration(
                              labelText: "Subject Name",
                              hintText: "Subject Name",
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
                            validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "Subject name cannot be empty"
                                : null,
                          ),
                          const SizedBox(height: 20),

                          /// subject code
                          TextFormField(
                            controller: codeController,
                            decoration: InputDecoration(
                              labelText: "Subject Code",
                              hintText: "Subject Code",
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
                          ),
                          const SizedBox(height: 20),

                          /// level dropdown (from ClassModel)
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Select Level",
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
                            ),
                            value: selectedLevel,
                            items: value.classdata
                                .map((cls) => DropdownMenuItem(
                              value: cls.name,
                              child: Text(cls.name),
                            ))
                                .toList(),
                            onChanged: (val) => setState(() => selectedLevel = val),
                            validator: (val) =>
                            val == null ? "Please select a level" : null,
                          ),
                          const SizedBox(height: 20),

                          /// buttons
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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

                                        final id = "${subjectController.text.trim()}${value.schoolid.trim()}".replaceAll(" ", "") .toLowerCase();

                                        final subjectData = SubjectModel(
                                          id:id,
                                          name: subjectController.text.trim(),
                                          code: codeController.text.trim(),
                                          level: selectedLevel ?? '',
                                          schoolId: value.schoolid,
                                          timestamp: DateTime.now(),
                                        ).toMap();


                                        await value.db
                                            .collection("subjects")
                                            .doc(id)
                                            .set(subjectData, SetOptions(merge: true));

                                        progress.dismiss();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(isEdit
                                                ? "Subject updated successfully"
                                                : "Subject registered successfully"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        if (!isEdit) {
                                          subjectController.clear();
                                          codeController.clear();
                                          setState(() => selectedLevel = null);
                                        }
                                      }
                                    },
                                    icon: Icon(isEdit ? Icons.update : Icons.save),
                                    label: Text(
                                        isEdit ? "Update Subject" : "Register Subject"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF00496d),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 15,
                                      ),
                                      textStyle: const TextStyle(fontSize: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => context.go(Routes.viewsubjects),
                                    icon: const Icon(Icons.list),
                                    label: const Text("View Subjects"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF00496d),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 15,
                                      ),
                                      textStyle: const TextStyle(fontSize: 16),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
