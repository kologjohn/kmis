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
  final staffData;
  const Regstaff({Key? key, this.staffData}) : super(key: key);

  @override
  State<Regstaff> createState() => _RegstaffState();
}

class _RegstaffState extends State<Regstaff> {
  final name = TextEditingController();
  final phone = TextEditingController();
  late final sex = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> _sex = ['Male', "Female"];
  String? myRegion;
  String? _selectedSex;
  String? level; // Access level selection
  String? episode;
  String? week;
  String? zone;
  String? _selectedAccessLevel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().getfetchRegions();
    });
    final data = widget.staffData;
    if (data != null) {
      if (data is Staff) {
        name.text = data.name ?? '';
        phone.text = data.phone ?? '';
        _selectedSex = data.sex;
        myRegion = data.region;
        _selectedAccessLevel = data.accessLevel;
       }
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
                  backgroundColor: Color(0xFF2D2F45),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed:(){
                      context.go(Routes.dashboard);
                    },
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isEdit ? 'Edit Staff' : 'Register Staff',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: name,
                                  decoration: InputDecoration(
                                    labelText: "Staff Name",
                                    hintText: "Enter Staff Name",
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
                                    focusedBorder: OutlineInputBorder(
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
                                      return 'Enter staff name cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: phone,
                                  readOnly: isEdit,
                                  decoration: InputDecoration(
                                    labelText: "Phone",
                                    hintText: "Enter Phone Number Here",
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
                                      return 'Phone number can not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: _selectedSex,
                                  items: _sex
                                      .map(
                                        (cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(
                                        cat,
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
                                      _selectedSex = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Sex Category",
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    filled: true,
                                    fillColor: inputFill,
                                  ),
                                  validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please select a category'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: "Upper East",
                                  items: value.regionList
                                      .map(
                                        (cat) => DropdownMenuItem(
                                      value: cat.regionname,
                                      child: Text(
                                        cat.regionname,
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
                                      myRegion = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Staff Region",
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
                                      ? 'Please select a category'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                //level
                                DropdownButtonFormField<String>(
                                  value: _selectedAccessLevel,
                                  decoration: InputDecoration(
                                    labelText: "Access Level",
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    filled: true,
                                    fillColor: inputFill,
                                  ),
                                  items: value.accessLevels.map((level) {
                                    return DropdownMenuItem(
                                      value: level,
                                      child: Text(level),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAccessLevel = value;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? 'Please select an access level'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                Visibility(
                                  visible: false,
                                  child: Column(
                                    children: [ const SizedBox(height: 20),

                                      value.isLoading
                                          ? const CircularProgressIndicator()
                                          : DropdownButtonFormField<String>(
                                        value: level,
                                        items: value.levelss
                                            .map(
                                              (cat) => DropdownMenuItem<String>(
                                            value: cat.levelname, // or cat.name depending on your model
                                            child: Text(
                                              cat.levelname, // or cat.name
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ).toList(),
                                        dropdownColor: inputFill,
                                        onChanged: (newValue) {
                                          setState(() {
                                            level = newValue;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Level",
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
                                        validator: (value) =>
                                        value == null || value.isEmpty ? 'Please select a level' : null,
                                      ),
                                      //zone
                                      value. isLoading
                                          ? const CircularProgressIndicator()
                                          : DropdownButtonFormField<String>(
                                        value: zone,
                                        items: value.zones.map(
                                              (zoneModel) => DropdownMenuItem<String>(
                                            value: zoneModel.zonename,
                                            child: Text(
                                              zoneModel.zonename,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            zone = newValue!;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Select Zone",
                                          labelStyle: TextStyle(color: Colors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                        dropdownColor: Colors.black87, // background color of dropdown
                                      ),
                                      const SizedBox(height: 20),
                                      //week
                                      value.isLoading
                                          ? const CircularProgressIndicator()
                                          : DropdownButtonFormField<String>(
                                        value: week,
                                        items: value.weeks
                                            .map(
                                              (ep) => DropdownMenuItem<String>(
                                            value: ep.weekname,
                                            child: Text(
                                              "Week ${ep.weekname}",
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
                                            week = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Week",
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
                                        validator: (value) => value == null
                                            ? 'Please select a Week'
                                            : null,
                                      ),
                                      const SizedBox(height: 20),
                                      //episode
                                      if (value.loadingEpisodes)
                                        const CircularProgressIndicator()
                                      else
                                        DropdownButtonFormField<String>(
                                          value: episode,
                                          items: value.episodes
                                              .map((ep) => DropdownMenuItem<String>(
                                              value: ep.episodename,
                                              child: Text(
                                                "Episode ${ep.episodename}",
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
                                              episode = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Episode",
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
                                          validator: (value) => value == null
                                              ? 'Please select an episode'
                                              : null,
                                        ),



                                      const SizedBox(height: 40),],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final progress = ProgressHUD.of(context);
                                          progress!.show();

                                          final String nametxt = name.text.trim();
                                          final String phonetxt = phone.text.trim();
                                          final String sexName = _selectedSex ?? "";
                                          final String accesslevel = _selectedAccessLevel ?? "";
                                          final String Level = level ?? "";
                                          final String Region = myRegion ?? "";
                                          final String Zone = zone ?? "";
                                          final String Episode = episode ?? "";
                                          final String Week = week ?? "";

                                          //Build Staff object
                                          final staff = Staff(
                                            name: nametxt,
                                            accessLevel: accesslevel,
                                            phone: phonetxt,
                                            email: "$phonetxt@bookworm.com",
                                            sex: sexName,
                                            region: Region,
                                            zone: Zone,
                                            week: Week,
                                            episode: Episode,
                                            level: Level,
                                          );

                                          final data = isEdit
                                              ? staff.toMapForUpdate()
                                              : staff.toMapForRegister();

                                          await value.db
                                              .collection('staff')
                                              .doc(phonetxt)
                                              .set(data, SetOptions(merge: true));

                                          await Future.delayed(const Duration(seconds: 1));
                                          progress.dismiss();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                isEdit ? 'Data Updated Successfully' : 'Data Saved Successfully',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );

                                          if (!isEdit) {
                                            setState(() {
                                              _selectedAccessLevel = null;
                                              _selectedSex = null;
                                              week = null;
                                              episode = null;
                                              level = null;
                                              zone = null;
                                              myRegion = null;
                                            });
                                            name.clear();
                                            phone.clear();
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        isEdit ? Icons.update : Icons.save,
                                      ),
                                      label: Text(
                                        isEdit
                                            ? 'Update Staff'
                                            : 'Register Staff',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        context.go(
                                          Routes.viewstaff,
                                        );
                                        /*
                                        if (_formKey.currentState!.validate()) {
                                          final progress = ProgressHUD.of(
                                            context,
                                          );
                                          progress!.show();
                                          final String nametxt = name.text.trim();
                                          final String phonetxt = phone.text.trim();
                                          final String sexName = _selectedSex ?? "";
                                          final String accesslevel = _selectedAccessLevel ?? "";
                                          final String Level = level ?? "";
                                          final String Region = myRegion ?? "";
                                          final String Zone = zone ?? "";
                                          final String Episode = episode ?? "";
                                          final String Week = week ?? " ";
                                          final data = Staff(
                                            name: nametxt,
                                            accessLevel: accesslevel,
                                            phone: phonetxt,
                                            email: "$phonetxt@bookworm.com",
                                            sex: sexName,
                                            region: Region,
                                            zone: Zone,
                                            week: Week,
                                            episode: Episode,
                                            level: Level,
                                          ).toMap();
                                          await value.db
                                              .collection('staff')
                                              .doc(phonetxt)
                                              .set(data, SetOptions(merge: true));
                                          // Save logic here...
                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                          ); // Simulate work
                                          progress.dismiss();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Saved Successfully",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );

                                          name.clear();
                                          phone.clear();
                                          setState(() {
                                            _selectedAccessLevel = null;
                                            _selectedSex = null;
                                            week = null;
                                            episode = null;
                                            level = null;
                                            zone = null;
                                            myRegion = null;
                                          });
                                        }
                                        */
                                      },
                                      icon: const Icon(Icons.view_list),
                                      label: const Text('View Staff'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                    ),
                                    //const SizedBox(height: 20),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
