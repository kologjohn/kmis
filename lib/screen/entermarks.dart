import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class MarksEntryPage extends StatefulWidget {
  final Map<String, dynamic>? args;
  const MarksEntryPage({super.key, required this.args});

  @override
  _MarksEntryPageState createState() => _MarksEntryPageState();
}

class _MarksEntryPageState extends State<MarksEntryPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController caController = TextEditingController();
  final TextEditingController examsController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  void dispose() {
    caController.dispose();
    examsController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final ca = double.tryParse(caController.text) ?? 0;
    final exams = double.tryParse(examsController.text) ?? 0;
    final total = ca + exams;
    totalController.text = total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Myprovider>(context, listen: false);

    final studentId = widget.args?['studentId'] ?? '';
    final studentName = widget.args?['studentName'] ?? '';
    final classId = widget.args?['classId'] ?? '';
    final photoUrl = widget.args?['photoUrl'] ?? '';

    final imageUrl = (photoUrl.isNotEmpty)
        ? photoUrl
        : (provider.imageUrl ?? '');

    const inputFill = Color(0xFF2C2C3C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.scores),
        ),
        title: const Text(
          "Marks Entry",
          style: TextStyle(
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
                ],
              ),
              const SizedBox(height: 20),

              // CA Field
              TextFormField(
                controller: caController,
                decoration: const InputDecoration(
                  labelText: "Continuous Assessment (Max 60)",
                  filled: true,
                  fillColor: inputFill,
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Required';
                  }
                  final value = double.tryParse(val.trim());
                  if (value == null || value < 0) {
                    return 'Enter a valid number';
                  }
                  if (value > 60) {
                    return 'CA cannot exceed 60';
                  }
                  return null;
                },
                onChanged: (_) => _calculateTotal(),
              ),
              const SizedBox(height: 16),

              // Exams Field
              TextFormField(
                controller: examsController,
                decoration: const InputDecoration(
                  labelText: "Exams (Max 100)",
                  filled: true,
                  fillColor: inputFill,
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Required';
                  }
                  final value = double.tryParse(val.trim());
                  if (value == null || value < 0) {
                    return 'Enter a valid number';
                  }
                  if (value > 100) {
                    return 'Exams cannot exceed 100';
                  }
                  return null;
                },
                onChanged: (_) => _calculateTotal(),
              ),
              const SizedBox(height: 16),

              // Total Field
              TextFormField(
                controller: totalController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Total Score",
                  filled: true,
                  fillColor: inputFill,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final ca = double.tryParse(caController.text) ?? 0;
                    final exams = double.tryParse(examsController.text) ?? 0;
                    final total = ca + exams;

                    try {
                      // await provider.saveStudentMarks(
                      //   studentId: studentId,
                      //   ca: ca,
                      //   exams: exams,
                      //   total: total,
                      //   context: context,
                      // );

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
                          content: Text("Error: ${e.toString()}"),
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
            ],
          ),
        ),
      ),
    );
  }
}
