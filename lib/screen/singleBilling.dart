import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:ksoftsms/controller/dbmodels/singleBilledModel.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ksoftsms/controller/dbmodels/billedModel.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/routes.dart';
import '../widgets/dropdown.dart';

class SingleBilling extends StatefulWidget {
  const SingleBilling({super.key});

  @override
  State<SingleBilling> createState() => _SingleBillingState();
}

class _SingleBillingState extends State<SingleBilling> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.getdata();
      provider.fetchterms();
      provider.fetchFess();
    });
  }

  final accountController = TextEditingController();
  final searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedTerm;
  String? selectedfee;

  @override
  void dispose() {
    accountController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFFffffff);
    return ProgressHUD(
      child: Builder(builder: (context) {
        return Consumer<Myprovider>(
          builder: (BuildContext context, value, Widget? child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF00273a),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go(Routes.dashboard),
                ),
                title: Text(
                  '${value.currentschool.toUpperCase()} MULTI STUDENT BILLING',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: "Search Student by Name",
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () => value.searchStudents(
                                        searchController.text.trim()),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (q) {
                                  if (q.isEmpty) {
                                    value.emptysearchResults();
                                  } else {
                                    value.searchStudents(q);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),

                              // Search results
                              if (value.searchResults.isNotEmpty)
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final student = value.searchResults[index];
                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2, color: Colors.grey),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(student.name ?? ""),
                                        subtitle:
                                        Text("ID: ${student.studentid}"),
                                        trailing: Icon(
                                          value.selectedStudents.any((s) =>
                                          s.studentid ==
                                              student.studentid)
                                              ? Icons.check_circle
                                              : Icons.add_circle_outline,
                                          color: value.selectedStudents.any((s) =>
                                          s.studentid ==
                                              student.studentid)
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        onTap: () {
                                          value.addStudent(student);
                                        },
                                      ),
                                    );
                                  },
                                ),

                              // Selected students
                              if (value.selectedStudents.isNotEmpty)
                                Column(
                                  children: value.selectedStudents
                                      .map(
                                        (s) => Card(
                                      color: Colors.blue[50],
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: ListTile(
                                        title: Text(s.name ?? ""),
                                        subtitle: Text(
                                            "Class: ${s.level}, Year: ${s.yeargroup}"),
                                        trailing: IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () {
                                            value.removeStudent(
                                                s.studentid);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),

                              const SizedBox(height: 20),

                              // amount field
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: accountController,
                                decoration: const InputDecoration(
                                  labelText: "Billed Amount",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Amount is required"
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // fees dropdown
                              buildDropdown(
                                value: selectedfee,
                                items: value.fees.map((e) => e.name).toList(),
                                label: "FEES",
                                fillColor: inputFill,
                                onChanged: (v) =>
                                    setState(() => selectedfee = v),
                                validatorMsg: 'Select Fees',
                              ),
                              const SizedBox(height: 20),

                              // term dropdown
                              buildDropdown(
                                value: selectedTerm,
                                items: value.terms.map((e) => e.name).toList(),
                                label: "Term",
                                fillColor: inputFill,
                                onChanged: (v) =>
                                    setState(() => selectedTerm = v),
                                validatorMsg: "Select Term",
                              ),
                              const SizedBox(height: 20),

                              // Save button
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00496d),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      value.selectedStudents.isNotEmpty) {
                                    final progress = ProgressHUD.of(context);
                                    progress!.show();

                                    try {
                                      String amount =
                                      accountController.text.trim();

                                      for (var student
                                      in value.selectedStudents) {
                                        String yearGroup=student.yeargroup;
                                        String department=student.department;
                                        String Level=student.level;
                                        String ids="${value.schoolid}$yearGroup$selectedTerm$department$Level$selectedfee";
                                        String id = ids.replaceAll(RegExp(r'\s+'), '').toLowerCase();

                                       // String id = "${value.schoolid}${student.studentid}$selectedTerm$selectedfee".replaceAll(RegExp(r'\s+'), '').toLowerCase();

                                        final dataexist = await value.db.collection("singlebilled").doc(id).get();

                                        if (dataexist.exists) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "${student.name} already billed for $selectedfee"),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                          progress.dismiss();
                                          return;
                                        }

                                        final data = SingleBilledModel(
                                          level: student.level,
                                          yeargroup: student.yeargroup,
                                          amount: amount,
                                          activityType: "Fee Billing",
                                          term: selectedTerm.toString(),
                                          schoolId: value.schoolid,
                                          dateCreated: DateTime.now(),
                                          feeName: selectedfee.toString(),
                                          studentId: student.studentid,
                                          studentName: student.name ?? "",
                                        ).toJson();

                                        await value.db
                                            .collection("singlebilled")
                                            .doc(id)
                                            .set(data);
                                      }

                                      progress.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text("Billing completed"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      value.clearSelectedStudents();
                                      accountController.clear();
                                      selectedfee = null;
                                      selectedTerm = null;
                                      setState(() {}); // refresh dropdowns
                                    } catch (e) {
                                      progress.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Failed: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save,
                                    color: Colors.white),
                                label: const Text("Bill Students",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
