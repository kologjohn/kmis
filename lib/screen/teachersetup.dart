import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/myprovider.dart';
import '../controller/dbmodels/componentmodel.dart';
import '../controller/dbmodels/subjectmodel.dart';
import '../controller/dbmodels/staffmodel.dart';
import '../controller/routes.dart';
import 'dropdown.dart';

/// Multi-select model
class MultiSelectItem<T> {
  final T value;
  final String label;
  MultiSelectItem({required this.value, required this.label});
}
class MultiSelectField<T> extends StatelessWidget {
  final String label;
  final List<MultiSelectItem<T>> items;
  final List<T> selectedValues;
  final void Function(List<T>) onConfirm;
  final String hintText;

  const MultiSelectField({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedValues,
    required this.onConfirm,
    this.hintText = '',
  }) : super(key: key);

  Future<void> _openDialog(BuildContext context) async {
    final temp = List<T>.from(selectedValues);
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2D2F45),
              title: Text(label, style: const TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    final isSelected = temp.contains(item.value);
                    return CheckboxListTile(
                      activeColor: Colors.blueAccent,
                      checkColor: Colors.white,
                      value: isSelected,
                      title: Text(item.label,
                          style: const TextStyle(color: Colors.white70)),
                      onChanged: (checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            temp.add(item.value);
                          } else {
                            temp.remove(item.value);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.pop(ctx),
                ),
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    onConfirm(temp);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabels = items
        .where((it) => selectedValues.contains(it.value))
        .map((it) => it.label)
        .toList();

    return InkWell(
      onTap: () => _openDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2F45),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedLabels.isNotEmpty
                    ? selectedLabels.join(", ")
                    : (hintText.isNotEmpty ? hintText : "Select $label"),
                style: const TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

/// Teacher Setup Page (Multi)
class TeacherSetupPage extends StatefulWidget {
  const TeacherSetupPage({Key? key}) : super(key: key);

  @override
  _TeacherSetupPageState createState() => _TeacherSetupPageState();
}

class _TeacherSetupPageState extends State<TeacherSetupPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> selectedSubjects = [];
  List<String> selectedLevels = [];
  List<ComponentModel> selectedComponents = [];
  List<String> selectedTeachers = [];
  String? _selectclass;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.fetchomponents();
      provider.fetchdepart();
      provider.fetchsubjects();
      provider.fetchstaff();
      provider.fetchclass();
    });
  }

  ButtonStyle _btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void _showMsg(BuildContext ctx, String msg, bool isError) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final subjectItems = value.subjectList
            .map<MultiSelectItem<String>>(
                (s) => MultiSelectItem(value: s.id, label: s.name))
            .toList();

        final levelItems = value.departments
            .map<MultiSelectItem<String>>(
                (lvl) => MultiSelectItem(value: lvl.id!, label: lvl.name))
            .toList();

        final teacherItems = value.stafflist
            .map<MultiSelectItem<String>>(
                (t) => MultiSelectItem(value: t.id!, label: t.name))
            .toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            title: const Text("Teacher Setup (Multi)",
                style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ChoiceChip(
                    label: Text("${value.year } - ${value.term}"),
                    selected: true,
                    selectedColor: Colors.blueAccent,
                    labelStyle: const TextStyle(color: Colors.white),
                    onSelected: (_) {},
                  ),
                  const SizedBox(height: 15),
                  // Teachers
                  MultiSelectField<String>(
                    label: "Teachers",
                    items: teacherItems,
                    selectedValues: selectedTeachers,
                    hintText: "Select Teachers",
                    onConfirm: (val) {
                      setState(() => selectedTeachers = val);
                    },
                  ),
                  const SizedBox(height: 15),
                  // Subjects
                  MultiSelectField<String>(
                    label: "Subjects",
                    items: subjectItems,
                    selectedValues: selectedSubjects,
                    hintText: "Select Subjects",
                    onConfirm: (val) {
                      setState(() => selectedSubjects = val);
                    },
                  ),
                  const SizedBox(height: 15),
                  // Levels
                  MultiSelectField<String>(
                    label: "Levels",
                    items: levelItems,
                    selectedValues: selectedLevels,
                    hintText: "Select Levels",
                    onConfirm: (val) {
                      setState(() => selectedLevels = val);
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectclass,
                    items: value.classdata.map((cat) {
                      return DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: inputFill,
                    onChanged: (val) => setState(() => _selectclass = val),
                    decoration: _inputDecoration("class", null, inputFill),
                    validator: (value) => value == null ? 'Please select class' : null,
                  ),
                  // Components (CA, Exams, etc.)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: value.accessComponents.map((comp) {
                      final isSelected = selectedComponents.contains(comp);
                      return ChoiceChip(
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(comp.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            Text("Mark: ${comp.totalMark}",
                                style: const TextStyle(
                                    color: Colors.yellowAccent, fontSize: 11)),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: Colors.blueAccent,
                        backgroundColor: const Color(0xFF2D2F45),
                        onSelected: (sel) {
                          setState(() {
                            if (sel) {
                              selectedComponents.add(comp);
                            } else {
                              selectedComponents.remove(comp);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: value.savingSetup
                        ? null: () async {
                      if ( selectedTeachers.isEmpty ||
                          selectedSubjects.isEmpty ||
                          selectedLevels.isEmpty ||
                          selectedComponents.isEmpty) {
                        _showMsg(context, "Fill all fields", true);
                        return;
                      }

                      try {
                        value.savingSetup = true;
                        await value.saveTeacherSetupMulti(
                          teacherIds: selectedTeachers,
                          schoolId: value.schoolid,
                          academicYear: value.year,
                          term: value.term,
                          levels: value.departments
                              .where(
                                  (lvl) => selectedLevels.contains(lvl.id))
                              .toList(),
                          subjects: value.subjectList
                              .where((s) =>
                              selectedSubjects.contains(s.id))
                              .toList(),
                          components: selectedComponents,
                          classes: _selectclass!,
                        );
                        _showMsg(context, "Setup saved", false);
                      } catch (e) {
                        _showMsg(context, "Error: $e", true);
                      } finally {
                        value.savingSetup = false;
                      }
                    },
                    icon: value.savingSetup
                        ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save),
                    label: Text(
                        value.savingSetup ? "Saving..." : "Save Teacher Setup"),
                    style: _btnStyle(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
