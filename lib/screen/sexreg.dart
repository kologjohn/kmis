import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class SexRegistrationScreen extends StatefulWidget {
  const SexRegistrationScreen({super.key});

  @override
  State<SexRegistrationScreen> createState() => _RevenueListScreenState();
}

class _RevenueListScreenState extends State<SexRegistrationScreen> {
  final sex = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF2D2F45),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go(Routes.dashboard),
              ),
              title: const Text(
                "Sex Registration",
                style: TextStyle(
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
                            controller: sex,
                            decoration: InputDecoration(
                              labelText: "Sex Name",
                              hintText: "Enter sex Name",
                              labelStyle: TextStyle(color: Colors.white),
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
                                return 'Sex category cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final progress = ProgressHUD.of(context);
                                progress!.show();

                                String sexName = sex.text.trim();
                                await Myprovider().addsex(sexName);

                                progress.dismiss();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Data Saved Successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                sex.clear();
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Save Sex'),
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
