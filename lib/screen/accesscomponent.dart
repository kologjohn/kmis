
import 'package:ksoftsms/controller/dbmodels/assesscomponentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'dropdown.dart';

class AccessComponent extends StatefulWidget {
  const AccessComponent({super.key});

  @override
  State<AccessComponent> createState() => _RevenueGridPageState();
}

class _RevenueGridPageState extends State<AccessComponent> {
  String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<DocumentSnapshot> _revenues = [];
  List<DocumentSnapshot> _filteredRevenues = [];
  final TextEditingController _searchController = TextEditingController();
  int records = 0;
  int? episodeInt;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.getfetchLevels();
    });
    _searchController.addListener(_onSearch);
  }
  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRevenues = _revenues.where((doc) {
        final name = doc['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final componentname = TextEditingController();
  final totalmark = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? level;


  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
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
                  title: const Text(
                    'Access Components',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                            children:[
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: componentname,
                                decoration: InputDecoration(
                                  labelText: "Component Name",
                                  hintText: "Enter Component Name",
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
                                    return 'Component name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                               /*
                               DropdownButtonFormField<String>(
                                value: level,
                                items: value.levelss
                                    .map(
                                      (cat) => DropdownMenuItem(
                                    value: cat.levelname,
                                    child: Text(
                                      cat.levelname,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                    .toList(),
                                dropdownColor: inputFill,
                                onChanged: (value) {
                                  setState(() {
                                    level = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Level Category",
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a level'
                                    : null,
                              ),
                              */
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: totalmark,
                                decoration: InputDecoration(
                                  labelText: "Total Mark",
                                  hintText: "Enter Total Mark",
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
                                    return 'Totalmarks category cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              /*
                              CustomDropdown(
                                label: "Episode",
                                items: value.episodes
                                    .map((e) => e.episodename.toString())
                                    .toList(),
                                value: episodeInt?.toString(),
                                isLoading: value.loadingEpisodes,
                                onChanged: (val) {
                                  setState(() {
                                    episodeInt = int.tryParse(val!);
                                  });
                                },
                              ),
                              */
                              const SizedBox(height: 20),
                              // Save + View Buttons
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  /*
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final progress =
                                        ProgressHUD.of(context);
                                        progress!.show();
                                        String categoryName =
                                        componentname.text.trim();
                                        String totalMark =
                                        totalmark.text.trim();
                                        final String category = level!;
                                        final data = AssesscomponentModel(
                                          componentname: categoryName,
                                        //  level: category,
                                          totalmark: totalMark,
                                          time: DateTime.timestamp(),
                                        ).toMap();
                                        await value.db
                                            .collection("assesscomponent")
                                            .doc(componentname.text)
                                            .set(data);

                                        progress.dismiss();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Data Saved Successfully",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        setState(() {
                                       //   level = null;
                                        });
                                      //  componentname.clear();
                                       // totalmark.clear();
                                      }

                                    },
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save Access'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      textStyle:
                                      const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  */
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(8), // similar to ElevatedButton shape
                                    ),
                                    child: Material(
                                      color: Colors.transparent, // keep container color
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8), // match the container radius
                                        onTap: () async {
                                          if (_formKey.currentState!.validate()) {
                                            final progress = ProgressHUD.of(context);
                                            progress!.show();

                                            String categoryName = componentname.text.trim();
                                            String totalMark = totalmark.text.trim();
                                            final String category = level!;

                                            final data = AssesscomponentModel(
                                              componentname: categoryName,
                                              // level: category,
                                              totalmark: totalMark,
                                              time: DateTime.timestamp(),
                                            ).toMap();

                                            await value.db
                                                .collection("assesscomponent")
                                                .doc(componentname.text)
                                                .set(data);

                                            progress.dismiss();

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Data Saved Successfully"),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            setState(() {
                                              // level = null;
                                            });
                                            // componentname.clear();
                                            // totalmark.clear();
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.save, color: Colors.white),
                                            SizedBox(width: 8),
                                            Text(
                                              'Save Access',
                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),


                                  /*
                                  ElevatedButton.icon(
                                    onPressed: () {
                                    context.go(Routes.accesslist);
                                    },
                                    icon: const Icon(Icons.list),
                                    label: const Text('View Access'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      textStyle:
                                      const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  */
                                  InkWell(
                                    onTap: () => context.go(Routes.accesslist),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2D2F45), // theme background
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.blueAccent, width: 1), // subtle border
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.list, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            "View Access",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
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



