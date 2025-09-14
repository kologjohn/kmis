import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/staffmodel.dart';
import '../controller/routes.dart';

class Regstaff extends StatefulWidget {
  final Staff? staffData;
  const Regstaff({Key? key, this.staffData}) : super(key: key);

  @override
  State<Regstaff> createState() => _RegstaffState();
}

class _RegstaffState extends State<Regstaff> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _sex = ['Male', "Female"];
  String? myRegion;
  String? _selectedSex;
  String? _selectedAccessLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().getfetchRegions();
    });

    final data = widget.staffData;
    if (data != null) {
      name.text = data.name ?? '';
      phone.text = data.phone ?? '';
      _selectedSex = data.sex;
      myRegion = data.region;
      _selectedAccessLevel = data.accessLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.staffData != null;

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
                    onPressed: () {
                      context.go(Routes.dashboard);
                    },
                  ),
                  title: Text(
                    isEdit ? 'Edit Staff' : 'Register Staff',
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
                      margin: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Name
                                TextFormField(
                                  controller: name,
                                  decoration: _inputDecoration("Staff Name", "Enter Staff Name", inputFill),
                                  style: const TextStyle(fontSize: 16),
                                  validator: (value) =>
                                  value == null || value.trim().isEmpty ? 'Staff name cannot be empty' : null,
                                ),
                                const SizedBox(height: 20),

                                // Phone
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  controller: phone,
                                  readOnly: isEdit,
                                  decoration: _inputDecoration("Phone", "Enter Phone Number", inputFill),
                                  style: const TextStyle(fontSize: 16),
                                  validator: (value) =>
                                  value == null || value.trim().isEmpty ? 'Phone number cannot be empty' : null,
                                ),
                                const SizedBox(height: 20),

                                // Sex
                                DropdownButtonFormField<String>(
                                  value: _selectedSex,
                                  items: _sex.map((cat) {
                                    return DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat, style: const TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  dropdownColor: inputFill,
                                  onChanged: (value) => setState(() => _selectedSex = value),
                                  decoration: _inputDecoration("Sex", null, inputFill),
                                  validator: (value) => value == null ? 'Please select sex' : null,
                                ),
                                const SizedBox(height: 20),

                                // Region
                                DropdownButtonFormField<String>(
                                  value: myRegion,
                                  items: value.regionList.map((cat) {
                                    return DropdownMenuItem(
                                      value: cat.regionname,
                                      child: Text(cat.regionname, style: const TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  dropdownColor: inputFill,
                                  onChanged: (val) => setState(() => myRegion = val),
                                  decoration: _inputDecoration("Region", null, inputFill),
                                  validator: (value) => value == null ? 'Please select region' : null,
                                ),
                                const SizedBox(height: 20),

                                // Access Level
                                DropdownButtonFormField<String>(
                                  value: _selectedAccessLevel,
                                  items: [""].map((level) {
                                    return DropdownMenuItem(value: level, child: Text(level));
                                  }).toList(),
                                  onChanged: (val) => setState(() => _selectedAccessLevel = val),
                                  decoration: _inputDecoration("Access Level", null, inputFill),
                                  validator: (value) => value == null ? 'Please select access level' : null,
                                ),
                                const SizedBox(height: 30),
                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final progress = ProgressHUD.of(context);
                                          progress!.show();

                                          final staff = Staff(
                                            name: name.text.trim(),
                                            accessLevel: _selectedAccessLevel ?? "",
                                            phone: phone.text.trim(),
                                            email: "${phone.text.trim()}",
                                            sex: _selectedSex ?? "",
                                            region: myRegion ?? "",
                                            level: '',
                                            schoolId: value.schoolid,
                                            schoolname: value.currentschool,
                                          );

                                          final data = isEdit ? staff.toMapForUpdate() : staff.toMapForRegister();

                                          await value.db
                                              .collection('staff')
                                              .doc(staff.phone)
                                              .set(data, SetOptions(merge: true));

                                          await Future.delayed(const Duration(seconds: 1));
                                          progress.dismiss();

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(isEdit ? 'Data Updated Successfully' : 'Data Saved Successfully'),
                                            backgroundColor: Colors.green,
                                          ));

                                          if (!isEdit) {
                                            setState(() {
                                              _selectedAccessLevel = null;
                                              _selectedSex = null;
                                              myRegion = null;
                                            });
                                            name.clear();
                                            phone.clear();
                                          }
                                        }
                                      },
                                      icon: Icon(isEdit ? Icons.update : Icons.save),
                                      label: Text(isEdit ? 'Update Staff' : 'Register Staff'),
                                      style: _btnStyle(),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton.icon(
                                      onPressed: () => context.go(Routes.viewstaff),
                                      icon: const Icon(Icons.view_list),
                                      label: const Text('View Staff'),
                                      style: _btnStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  InputDecoration _inputDecoration(String label, String? hint, Color fill) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      filled: true,
      fillColor: fill,
    );
  }

  ButtonStyle _btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      textStyle: const TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
    );
  }
}
