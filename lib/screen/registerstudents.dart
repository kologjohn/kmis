
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/contestantsmodel.dart';
import '../controller/routes.dart';

class RegisterContestants extends StatefulWidget {
  final contestantData;
  const RegisterContestants({Key? key, this.contestantData}) : super(key: key);

  @override
  State<RegisterContestants> createState() => _RegisterContestantsState();
}

class _RegisterContestantsState extends State<RegisterContestants> {
  final studentname = TextEditingController();
  final studentcode = TextEditingController();
  final school = TextEditingController();
  final phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> _sex = ['Male', "Female"];
  String? selectlevel;
  String? sex;
  String? myRegion;
  String? zoner;
  String? _uploadedImageUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final provider = Provider.of<Myprovider>(context, listen: false);
      await provider.getfetchRegions();
      await provider.getfetchEpisodes();
      await provider.getfetchZones();
      await provider.getfetchLevels();
    });

    final data = widget.contestantData;
    if (data != null) {
      if (data is ContestantModel) {
        studentname.text = data.name ?? '';
        studentcode.text = data.contestantId ?? '';
        school.text = data.school ?? '';
        phone.text = data.guardianContact ?? '';
        selectlevel = data.level;
        sex = data.sex;
        myRegion = data.region;
        zoner = data.zone;
        _uploadedImageUrl = data.photoUrl ?? '';

      }

    }

  }

  @override
  void dispose() {
    studentname.dispose();
    studentcode.dispose();
    school.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.contestantData != null;

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
                    isEdit ? 'Edit Contestant' : 'Register Contestant',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: const Color(0xFF2D2F45),
                      margin: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: studentname,
                                label: "Contestant Name",
                                hint: "Enter Contestant Name",
                                validatorMsg: 'Contestant name cannot be empty',
                                fillColor: inputFill,
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: studentcode,
                                label: "Contestant Code",
                                hint: "Enter Contestant Code",
                                validatorMsg: 'Contestant code cannot be empty',
                                fillColor: inputFill,
                              ),
                              const SizedBox(height: 10),
                              buildDropdown(
                                value: sex,
                                items: _sex,
                                label: "Contestant Sex",
                                fillColor: inputFill,
                                onChanged: (v) => setState(() => sex = v),
                                validatorMsg: 'Please select sex',
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: school,
                                label: "Contestant School",
                                hint: "Enter Contestant School",
                                validatorMsg: 'Contestant school cannot be empty',
                                fillColor: inputFill,
                              ),
                              const SizedBox(height: 10),
                              buildDropdown(
                                value: myRegion,
                                items: value.regionList.map((c)=>c.regionname).toList(),
                                label: "Contestant Region",
                                fillColor: inputFill,
                                onChanged: (v) => setState(() => myRegion = v),
                                validatorMsg: 'Please select region',
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: phone,
                                label: "Contestant Guardian",
                                hint: "Enter Guardian contact",
                                validatorMsg: 'Guardian contact cannot be empty',
                                fillColor: inputFill,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 10),
                                buildDropdown(
                                value: selectlevel,
                                items: value.levelss.map((e) => e.levelname).toList(),
                                label: "Contestant Level",
                                fillColor: inputFill,
                                onChanged: (v) => setState(() => selectlevel = v),
                                validatorMsg: 'Please select level',
                              ),
                              const SizedBox(height: 10),
                               buildDropdown(
                                value: zoner,
                                items: value.zones.map((e) => e.zonename).toList(),
                                label: "Zone",
                                fillColor: inputFill,
                                onChanged: (v) => setState(() => zoner = v),
                                validatorMsg: 'Please select zone',
                              ),
                              const SizedBox(height: 10),
                              _buildImagePicker(value),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => _saveContestant(context, value, isEdit),
                                icon: Icon(isEdit ? Icons.update : Icons.save),
                                label: Text(isEdit ? 'Update Contestant' : 'Register Contestant'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String validatorMsg,
    required Color fillColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: true,
        fillColor: fillColor,
      ),
      style: const TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return validatorMsg;
        return null;
      },
    );
  }

  Widget buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required Color fillColor,
    required Function(String?) onChanged,
    required String validatorMsg,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
      dropdownColor: fillColor,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: true,
        fillColor: fillColor,
      ),
      validator: (v) => v == null || v.isEmpty ? validatorMsg : null,
    );
  }

  Widget _buildImagePicker(Myprovider value) {
    return InkWell(
      onTap: () => value.pickImageFromGallery(context),
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipOval(
          child: kIsWeb
              ? (value.imagefile != null
              ? Image.network(
            value.imagefile!.path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40, color: Colors.white),
          )
              : (_uploadedImageUrl != 'null' && _uploadedImageUrl!.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: proxyUrl(_uploadedImageUrl!),
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 40, color: Colors.white),
          )
              : const Icon(Icons.image, size: 40, color: Colors.white54)))
              : (value.imagefile != null
              ? Image.file(File(value.imagefile!.path), fit: BoxFit.cover)
              : (_uploadedImageUrl != 'null' && _uploadedImageUrl!.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: proxyUrl(_uploadedImageUrl!),
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 40, color: Colors.white),
          )
              : const Icon(Icons.image, size: 40, color: Colors.white54))),
        ),
      ),
    );
  }

  void _saveContestant(BuildContext context, Myprovider value, bool isEdit) async {
    if (!_formKey.currentState!.validate()) return;

    final progress = ProgressHUD.of(context);
    progress?.show();

    String name = studentname.text.trim();
    String contestantId = studentcode.text.trim();
    String schooltxt = school.text.trim();
    String guardianContacttxt = phone.text.trim();
    final String leveltxt = selectlevel!;
    final String sextxt = sex!;
    final String regiontxt = myRegion!;
    final String zonetxt = zoner!;

    await value.uploadImage(contestantId);

    final data = ContestantModel(
      id: contestantId,
      name: name,
      contestantId: contestantId,
      sex: sextxt,
      school: schooltxt,
      region: regiontxt,
      guardianContact: guardianContacttxt,
      level: leveltxt,
      timestamp: DateTime.now(),
      photoUrl: value.imageUrl,
      zone: zonetxt,
      votename: '',
    ).toMap();

    await value.db.collection("contestant").doc(contestantId).set(data, SetOptions(merge: true));

    progress?.dismiss();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEdit ? 'Data Updated Successfully' : 'Data Saved Successfully'),
        backgroundColor: Colors.green,
      ),
    );

    value.imagefile = null;

    if (!isEdit) {
      setState(() {
        value.imageUrl = "";
        _uploadedImageUrl = "";
      });
      studentname.clear();
      studentcode.clear();
    }
  }

  static String proxyUrl(String originalUrl) {
    return "https://api.allorigins.win/raw?url=${Uri.encodeComponent(originalUrl)}";
  }
}
