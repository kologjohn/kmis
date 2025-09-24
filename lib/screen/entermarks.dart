/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/scoremodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class MarksEntryPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const MarksEntryPage({super.key, required this.args});
  @override
  State<MarksEntryPage> createState() => _MarksEntryPageState();
}

class _MarksEntryPageState extends State<MarksEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController caController = TextEditingController();
  final TextEditingController examsController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<Myprovider>();
      provider.scoringconfig(provider.schoolid);
    });
  }

  @override
  void dispose() {
    caController.dispose();
    examsController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void _calculateTotal(ScoremodelConfig? config) {
    if (config == null) {
      totalController.text = "0.0";
      return;
    }

    final ca = double.tryParse(caController.text) ?? 0;
    final exams = double.tryParse(examsController.text) ?? 0;

    final maxContinuous = double.tryParse(config.maxContinuous ?? "100") ?? 100;
    final maxExam = double.tryParse(config.maxExam ?? "100") ?? 100;

    final continuousWeight = double.tryParse(config.continuous ?? "0") ?? 0;
    final examWeight = double.tryParse(config.exam ?? "0") ?? 0;

    final caConverted = (ca / maxContinuous) * continuousWeight;
    final examConverted = (exams / maxExam) * examWeight;

    final total = caConverted + examConverted;
    totalController.text = total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Myprovider>(context, listen: false);
    final studentId = widget.args['studentId'] ?? '';
    final studentName = widget.args['studentName'] ?? '';
    final classId = widget.args['class'] ?? '';
    final photoUrl = widget.args['photoUrl'] ?? '';
    final subject = widget.args['subject'] ?? '';

    final imageUrl = (photoUrl.isNotEmpty) ? photoUrl : (provider.imageUrl ?? '');

    const inputFill = Color(0xFF2C2C3C);

    return Consumer<Myprovider>(
      builder: (BuildContext context, Myprovider value, Widget? child) {
        final config = value.scoreConfigList.isNotEmpty
            ? value.scoreConfigList.first
            : null;

        final minContinuous = double.tryParse(config?.minContinuous ?? "0") ?? 0;
        final maxContinuous =
            double.tryParse(config?.maxContinuous ?? "100") ?? 100;
        final minExam = double.tryParse(config?.minExam ?? "0") ?? 0;
        final maxExam = double.tryParse(config?.maxExam ?? "100") ?? 100;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.scores),
            ),
            title: Text(
              "${value.name}~${value.auth.currentUser?.email ?? "No user"}~${value.academicyrid}~${value.term}-$subject",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: const Color(0xFF1E1E2C),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (imageUrl.isNotEmpty)
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/images/bookwormlogo.jpg')
                        as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        "ID: $studentId",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "Class: $classId",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "Subject: $subject",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // CA Field
                  TextFormField(
                    controller: caController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText:
                      "Continuous Assessment (Max $maxContinuous, Min $minContinuous)",
                      filled: true,
                      fillColor: inputFill,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Required';
                      }
                      final value = double.tryParse(val.trim());
                      if (value == null) return 'Enter a valid number';
                      if (value < minContinuous || value > maxContinuous) {
                        return 'Must be between $minContinuous and $maxContinuous';
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotal(config),
                  ),
                  const SizedBox(height: 16),
                  // Exams Field
                  TextFormField(
                    controller: examsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Exams (Max $maxExam, Min $minExam)",
                      filled: true,
                      fillColor: inputFill,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Required';
                      }
                      final value = double.tryParse(val.trim());
                      if (value == null) return 'Enter a valid number';
                      if (value < minExam || value > maxExam) {
                        return 'Must be between $minExam and $maxExam';
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotal(config),
                  ),
                  const SizedBox(height: 16),

                  // Total Field
                  TextFormField(
                    controller: totalController,
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Total Score (Weighted)",
                      filled: true,
                      fillColor: inputFill,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Save button
                 /*
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ca = double.tryParse(caController.text) ?? 0;
                        final exams = double.tryParse(examsController.text) ?? 0;

                        final maxContinuous =
                            double.tryParse(config?.maxContinuous ?? "0") ??
                                0;
                        final maxExam =
                            double.tryParse(config?.maxExam ?? "100") ?? 100;

                        final continuousWeight =
                            double.tryParse(config?.continuous ?? "0") ?? 0;
                        final examWeight =
                            double.tryParse(config?.exam ?? "0") ?? 0;

                        final caConverted =
                            (ca / maxContinuous) * continuousWeight;
                        final examConverted =
                            (exams / maxExam) * examWeight;
                        final total = caConverted + examConverted;

                        try {

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Marks saved successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.go(Routes.scores);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save Marks"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  */
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ca = double.tryParse(caController.text) ?? 0;
                        final exams = double.tryParse(examsController.text) ?? 0;

                        try {
                          await context.read<Myprovider>().saveStudentMarks(
                            studentId: studentId,
                            subject: subject,
                            ca: ca,
                            exams: exams,
                            academicYearId: provider.academicyrid,
                            term: provider.term,
                            department: classId, // optional
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Marks saved successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          context.go(Routes.scores);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save Marks"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/scoremodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class MarksEntryPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const MarksEntryPage({super.key, required this.args});

  @override
  State<MarksEntryPage> createState() => _MarksEntryPageState();
}

class _MarksEntryPageState extends State<MarksEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController caController = TextEditingController();
  final TextEditingController examsController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<Myprovider>();
      provider.scoringconfig(provider.schoolid);
    });
  }

  @override
  void dispose() {
    caController.dispose();
    examsController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void _calculateTotal(ScoremodelConfig? config) {
    if (config == null) {
      totalController.text = "0.0";
      return;
    }

    final ca = double.tryParse(caController.text) ?? 0;
    final exams = double.tryParse(examsController.text) ?? 0;

    final maxContinuous = double.tryParse(config.maxContinuous ?? "100") ?? 100;
    final maxExam = double.tryParse(config.maxExam ?? "100") ?? 100;

    final continuousWeight = double.tryParse(config.continuous ?? "0") ?? 0;
    final examWeight = double.tryParse(config.exam ?? "0") ?? 0;

    final caConverted = (ca / maxContinuous) * continuousWeight;
    final examConverted = (exams / maxExam) * examWeight;
    final total = caConverted + examConverted;

    totalController.text = total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Myprovider>(context, listen: false);

    final studentId = widget.args['studentId'] ?? '';
    final studentName = widget.args['studentName'] ?? '';
    final classId = widget.args['class'] ?? '';
    final photoUrl = widget.args['photoUrl'] ?? '';
    final subject = widget.args['subject'] ?? '';
    final imageUrl = (photoUrl.isNotEmpty) ? photoUrl : (provider.imageUrl ?? '');

    const inputFill = Color(0xFF2C2C3C);

    return Consumer<Myprovider>(
      builder: (context, value, _) {
        // ✅ pick first config safely
        final config = value.scoreConfigList.isNotEmpty ? value.scoreConfigList.first : null;

        final minContinuous = double.tryParse(config?.minContinuous ?? "0") ?? 0;
        final maxContinuous = double.tryParse(config?.maxContinuous ?? "100") ?? 100;
        final minExam = double.tryParse(config?.minExam ?? "0") ?? 0;
        final maxExam = double.tryParse(config?.maxExam ?? "100") ?? 100;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.scores),
            ),
            title: Text(
              "${value.name} ~ ${value.auth.currentUser?.email ?? "No user"} ~ ${value.academicyrid} ~ ${value.term} - $subject",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          backgroundColor: const Color(0xFF1E1E2C),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (imageUrl.isNotEmpty)
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(studentName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                      Text("ID: $studentId", style: const TextStyle(color: Colors.white70)),
                      Text("Class: $classId", style: const TextStyle(color: Colors.white70)),
                      Text("Subject: $subject", style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // CA Field
                  TextFormField(
                    controller: caController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Continuous Assessment (Max $maxContinuous, Min $minContinuous)",
                      filled: true,
                      fillColor: inputFill,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Required';
                      final value = double.tryParse(val.trim());
                      if (value == null) return 'Enter a valid number';
                      if (value < minContinuous || value > maxContinuous) {
                        return 'Must be between $minContinuous and $maxContinuous';
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotal(config),
                  ),
                  const SizedBox(height: 16),

                  // Exams Field
                  TextFormField(
                    controller: examsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Exams (Max $maxExam, Min $minExam)",
                      filled: true,
                      fillColor: inputFill,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Required';
                      final value = double.tryParse(val.trim());
                      if (value == null) return 'Enter a valid number';
                      if (value < minExam || value > maxExam) {
                        return 'Must be between $minExam and $maxExam';
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotal(config),
                  ),
                  const SizedBox(height: 16),

                  // Total Field
                  TextFormField(
                    controller: totalController,
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Total Score (Weighted)",
                      filled: true,
                      fillColor: inputFill,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                   /*
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ca = double.tryParse(caController.text) ?? 0;
                        final exams = double.tryParse(examsController.text) ?? 0;

                        final maxContinuous =
                            double.tryParse(config?.maxContinuous ?? "0") ??
                                0;
                        final maxExam =
                            double.tryParse(config?.maxExam ?? "100") ?? 100;

                        final continuousWeight =
                            double.tryParse(config?.continuous ?? "0") ?? 0;
                        final examWeight =
                            double.tryParse(config?.exam ?? "0") ?? 0;

                        final caConverted =
                            (ca / maxContinuous) * continuousWeight;
                        final examConverted =
                            (exams / maxExam) * examWeight;
                        final total = caConverted + examConverted;
                        try {
                          await provider.saveStudentMarks(
                            studentId: studentId,
                            subject: subject,
                            ca: ca,
                            exams: exams,
                            academicYearId: provider.academicyrid,
                            term: provider.term,
                            department: classId, // optional
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Marks saved successfully"), backgroundColor: Colors.green),
                          );

                          context.go(Routes.scores);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save Marks"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  */
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ca = double.tryParse(caController.text) ?? 0;
                        final exams = double.tryParse(examsController.text) ?? 0;

                        final maxContinuous =
                            double.tryParse(config?.maxContinuous ?? "0") ?? 0;
                        final maxExam =
                            double.tryParse(config?.maxExam ?? "100") ?? 100;

                        final continuousWeight =
                            double.tryParse(config?.continuous ?? "0") ?? 0;
                        final examWeight =
                            double.tryParse(config?.exam ?? "0") ?? 0;

                        final caConverted = (ca / maxContinuous) * continuousWeight;
                        final examConverted = (exams / maxExam) * examWeight;
                        final total = caConverted + examConverted;

                        try {
                          //Fetch grading system (default)
                          final gradingSystem = await provider.fetchGradingSystem(provider.schoolid, department: classId);
                          String? grade;
                          String? remark;
                          if (gradingSystem != null && gradingSystem['gradingsystem'] != null) {
                            final gsMap = gradingSystem['gradingsystem'] as Map<String, dynamic>;
                            gsMap.forEach((gradeKey, value) {
                              final min = double.tryParse(value['min'].toString()) ?? 0;
                              final max = double.tryParse(value['max'].toString()) ?? 0;
                              if (total >= min && total <= max) {
                                grade = gradeKey;
                                remark = value['remark'];
                              }
                            });
                          }
                          if (grade == null || remark == null) {
                            throw Exception("No grade/remark found for score $total");
                          }
                          await provider.saveStudentMarks(
                            studentId: studentId,
                            subject: subject,
                            ca: ca.toString(),
                            exams: exams.toString(),
                            academicYearId: provider.academicyrid,
                            term: provider.term,
                            department: classId,
                            grade: grade.toString(),
                            total: total.toString(),
                            examConverted:examConverted.toString() ,
                            caConverted: caConverted.toString(),
                            remark: remark.toString(),
                              caw:continuousWeight.toString(),
                              examsw:examWeight.toString(),
                              maxca:maxContinuous.toString(),
                              maxexams:maxExam.toString()
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Marks saved successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          context.go(Routes.scores);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save Marks"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

