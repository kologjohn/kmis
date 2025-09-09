import 'package:ksoftsms/controller/dbmodels/episodeModel.dart';
import 'package:ksoftsms/screen/weeklistpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/weekmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class WeekRegistration extends StatefulWidget {
  final  weekData;
  const WeekRegistration({super.key, this.weekData});

  @override
  State<WeekRegistration> createState() => _WeekRegistrationState();
}

class _WeekRegistrationState extends State<WeekRegistration> {
  final week = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.weekData;
    if (data != null) {
      week.text = data['name']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.weekData != null;
    final docId = widget.weekData?['id'];
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (BuildContext context, Myprovider value, Widget? child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF2D2F45),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go(Routes.dashboard),
                  ),
                  title: Text(
                    isEdit ? 'Edit Week' : 'Register Week',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Color(0xFF2D2F45),
                      margin: const EdgeInsets.all(30.0),
                      constraints: BoxConstraints(maxWidth: 800),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: week,
                                decoration: InputDecoration(
                                  labelText: "Week Name",
                                  hintText: "Enter Week Name",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                style: const TextStyle(fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Week category cannot be empty';
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
                                        final progress = ProgressHUD.of(
                                          context,
                                        );
                                        progress!.show();
                                        String weekName = week.text.trim();
                                        final data = WeekModel(
                                          weekname: weekName,
                                          time: DateTime.now(),
                                          id: weekName,
                                        ).toMap();

                                        await value.db
                                            .collection('weeks')
                                            .doc(weekName)
                                            .set(data, SetOptions(merge: true));

                                        progress.dismiss();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isEdit
                                                  ? 'Week updated successfully'
                                                  : 'Week registered successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        if (!isEdit) {
                                          week.clear();
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      isEdit ? Icons.update : Icons.save,
                                    ),
                                    label: Text(
                                      isEdit ? 'Update Week' : 'Register Week',
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
                                  SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => WeekListPage(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'View Week',
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
                              SizedBox(height: 20),
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
