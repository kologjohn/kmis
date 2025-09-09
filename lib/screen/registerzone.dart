import 'package:ksoftsms/screen/zonelistpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class RegisterZone extends StatefulWidget {
  final Map<String,dynamic>?  zoneData;
  const RegisterZone({Key? key, this.zoneData}) : super(key: key);

  @override
  State<RegisterZone> createState() => _RegisterZoneState();
}

class _RegisterZoneState extends State<RegisterZone> {
  final TextEditingController zone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final data = widget.zoneData;
    if (data != null) {
      zone.text = data['name']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.zoneData != null;
    final docId = widget.zoneData?['name']; // Use name as ID

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (context, value, child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF2D2F45),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go(Routes.dashboard),
                  ),
                  title: Text(
                    isEdit ? 'Edit Zone' : 'Register Zone',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                            children: <Widget>[
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: zone,
                                decoration: InputDecoration(
                                  labelText: "Zone Name",
                                  hintText: "Enter Zone Name",
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
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
                                    return 'Zone category cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final progress = ProgressHUD.of(
                                          context,
                                        );
                                        progress?.show();

                                        final name = zone.text.trim();
                                        final data = {
                                          'name': name,
                                          'staff':
                                              value
                                                  .auth
                                                  .currentUser
                                                  ?.displayName ??
                                              "No Name",
                                          'timestamp': DateTime.now(),
                                        };
                                        await value.db
                                            .collection("zone")
                                            .doc(name)
                                            .set(data, SetOptions(merge: true));
                                        progress?.dismiss();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isEdit
                                                  ? 'Zone updated successfully'
                                                  : 'Zone registered successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        if (!isEdit) {
                                          setState(() {
                                            zone.clear();
                                          });
                                        }
                                      }
                                    },

                                    icon: Icon(
                                      isEdit ? Icons.update : Icons.save,
                                    ),
                                    label: Text(
                                      isEdit ? 'Update Zone' : 'Register Zone',
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
                                  const SizedBox(height: 20),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ZoneListPage(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'View Zones',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
          );
        },
      ),
    );
  }
}
