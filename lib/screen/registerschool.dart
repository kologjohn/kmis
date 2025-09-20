import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';
import '../controller/dbmodels/schoolmodel.dart';

class RegisterSchool extends StatefulWidget {
  final SchoolModel? school;
  const RegisterSchool({Key? key, this.school}) : super(key: key);

  @override
  State<RegisterSchool> createState() => _RegisterSchoolState();
}

class _RegisterSchoolState extends State<RegisterSchool> {
  final _formKey = GlobalKey<FormState>();
  final schoolName = TextEditingController();
  final prefix = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final countryName = TextEditingController();
  final countryCode = TextEditingController();
  final schoolId = TextEditingController();
  bool agreedToTerms = true;

  String? _uploadedLogoUrl = '';

  @override
  void initState() {
    super.initState();
    final data = widget.school;
    if (data != null) {
      schoolName.text = data.schoolname;
      prefix.text = data.prefix;
      address.text = data.address;
      email.text = data.email;
      phone.text = data.phone;
      countryName.text = data.countryName;
      countryCode.text = data.countryCode;
      schoolId.text = data.schoolId;
      agreedToTerms = data.agreedToTerms;
      _uploadedLogoUrl = data.logoUrl;
    }
  }

  @override
  void dispose() {
    schoolName.dispose();
    prefix.dispose();
    address.dispose();
    email.dispose();
    phone.dispose();
    countryName.dispose();
    countryCode.dispose();
    schoolId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    final isEdit = widget.school != null;

    return ProgressHUD(
      child: Consumer<Myprovider>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF00273a),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go(Routes.dashboard),
              ),
              title: Text(
                isEdit ? 'Edit School' : 'Register School',
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
                  color: const Color(0xFFffffff),
                  margin: const EdgeInsets.all(30.0),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: schoolName,
                            label: "School Name",
                            hint: "Enter school name",
                            validatorMsg: 'School name cannot be empty',
                            fillColor: inputFill,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: prefix,
                            label: "School Prefix",
                            hint: "Enter unique prefix (e.g. lamp)",
                            validatorMsg: 'Prefix cannot be empty',
                            fillColor: isEdit ? Colors.grey[800]! : inputFill,
                            readOnly: isEdit,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: address,
                            label: "Address",
                            hint: "Enter school address",
                            validatorMsg: 'Address cannot be empty',
                            fillColor: inputFill,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: email,
                            label: "Email",
                            hint: "Enter school email",
                            validatorMsg: 'Email cannot be empty',
                            fillColor: inputFill,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: phone,
                            label: "Phone",
                            hint: "Enter school phone",
                            validatorMsg: 'Phone cannot be empty',
                            fillColor: inputFill,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: countryName,
                            label: "Country Name",
                            hint: "Enter country (e.g. Ghana)",
                            validatorMsg: 'Country name cannot be empty',
                            fillColor: inputFill,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: countryCode,
                            label: "Country Code",
                            hint: "Enter country code (e.g. +233)",
                            validatorMsg: 'Country code cannot be empty',
                            fillColor: inputFill,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: schoolId,
                            label: "School ID",
                            hint: "Enter school ID (e.g. KS0001)",
                            validatorMsg: 'School ID cannot be empty',
                            fillColor: inputFill,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: agreedToTerms,
                                onChanged: (val) {
                                  setState(() => agreedToTerms = val ?? false);
                                },
                                activeColor: Color(0xFF00496d),
                              ),
                              const Expanded(
                                child: Text(
                                  "I agree to the terms & conditions",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                         // _buildLogoPicker(value),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final progress = ProgressHUD.of(context);
                              progress?.show();

                              String schoolNameTxt = schoolName.text.trim();
                              String prefixTxt = prefix.text.trim().toLowerCase();
                              String addressTxt = address.text.trim();
                              String emailTxt = email.text.trim();
                              String phoneTxt = phone.text.trim();
                              String countryNameTxt = countryName.text.trim();
                              String countryCodeTxt = countryCode.text.trim();
                              String schoolIdTxt = schoolId.text.trim();

                              // Upload image if new one was picked
                              //await value.uploadImage(prefixTxt);

                              final school = SchoolModel(
                                id: widget.school?.id ?? prefixTxt,
                                schoolname: schoolNameTxt,
                                prefix: prefixTxt,
                                address: addressTxt,
                                email: emailTxt,
                                phone: phoneTxt,
                                logoUrl: "dd".isNotEmpty
                                    ? ""
                                    : _uploadedLogoUrl ?? "",
                                createdAt: DateTime.now(),
                                countryName: countryNameTxt,
                                countryCode: countryCodeTxt,
                                schoolId: schoolIdTxt,
                                agreedToTerms: agreedToTerms,
                                type: "customer",
                              );

                              await value.db
                                  .collection("schools") // 🔹 plural
                                  .doc(school.id)
                                  .set(school.toMap(), SetOptions(merge: true));

                              progress?.dismiss();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEdit
                                      ? 'School Updated Successfully'
                                      : 'School Registered Successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // value.imagefile = null;

                              // if (!isEdit) {
                              //   setState(() {
                              //     value.imageUrl = "";
                              //     _uploadedLogoUrl = "";
                              //     agreedToTerms = true;
                              //   });
                              //   schoolName.clear();
                              //   prefix.clear();
                              //   address.clear();
                              //   email.clear();
                              //   phone.clear();
                              //   countryName.clear();
                              //   countryCode.clear();
                              //   schoolId.clear();
                              // }
                            },
                            icon: Icon(isEdit ? Icons.update : Icons.save),
                            label: Text(isEdit ? 'Update School' : 'Register School'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00496d),
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
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00496d))),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: false,
        fillColor: fillColor,
      ),
      style: TextStyle(
        fontSize: 14,
        color: readOnly ? Colors.black54 : Colors.black,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return validatorMsg;
        return null;
      },
    );
  }

  // Widget _buildLogoPicker(Myprovider value) {
  //   return InkWell(
  //     onTap: () =>null, //value.pickImageFromGallery(context),
  //     borderRadius: BorderRadius.circular(50),
  //     child: SizedBox(
  //       width: 100,
  //       height: 100,
  //       child: ClipOval(
  //           child: CachedNetworkImage(
  //             imageUrl: _uploadedLogoUrl!,
  //             fit: BoxFit.cover,
  //             placeholder: (_, __) =>
  //             const Center(child: CircularProgressIndicator()),
  //             errorWidget: (_, __, ___) =>
  //             const Icon(Icons.broken_image, size: 40, color: Colors.white),
  //           )
  //
  //               ? Image.file(File(value.imagefile!.path), fit: BoxFit.cover)
  //               : (_uploadedLogoUrl != null && _uploadedLogoUrl!.isNotEmpty
  //               ? CachedNetworkImage(
  //             imageUrl: _uploadedLogoUrl!,
  //             fit: BoxFit.cover,
  //             placeholder: (_, __) =>
  //             const Center(child: CircularProgressIndicator()),
  //             errorWidget: (_, __, ___) =>
  //             const Icon(Icons.broken_image, size: 40, color: Colors.white),
  //           )
  //               : const Icon(Icons.school, size: 40, color: Colors.white54)))),
  //     ),
  //   );
  // }
}
