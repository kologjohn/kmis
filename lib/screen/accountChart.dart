import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:ksoftsms/controller/dbmodels/accountsModel.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/componentmodel.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class AccountsChart extends StatefulWidget {
  final ComponentModel? component;
  const AccountsChart({super.key, this.component});

  @override
  State<AccountsChart> createState() => _RevenueGridPageState();
}

class _RevenueGridPageState extends State<AccountsChart> {
  final accountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedAccountClass;
  String? _selectedSubType;

  final List<String> _accounts = ["Assets", "Liability", "Equity", "Revenue", "Expense"];

  // Map of account classes and sub-types
  final Map<String, List<String>> accountMap = {
    "Assets": ["Current Assets", "Fixed Assets"],
    "Liability": ["Current Liabilities", "Long-term Liabilities"],
    "Equity": ["Owner's Equity", "Share Capital", "Retained Earnings", "Reserves"],
    "Revenue": ["Operating Revenue", "Non-operating Revenue"],
    "Expense": [
      "Operating Expenses",
      "Administrative Expenses",
      "Selling & Distribution Expenses",
      "Financial Expenses",
      "Depreciation & Amortization",
      "Other Expenses"
    ],
  };

  @override
  void dispose() {
    accountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFFffffff);
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Consumer<Myprovider>(
            builder: (BuildContext context, Myprovider value, Widget? child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF00273a),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go(Routes.dashboard),
                  ),
                  title: Text(
                    '${value.currentschool} Add Account Chart',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                body: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Container(
                      color: const Color(0xFFffffff),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Account Name Input
                              TextFormField(
                                controller: accountController,
                                decoration: InputDecoration(
                                  labelText: "Account Name ",
                                  hintText: "Enter Account Name",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[700]!),
                                  ),
                                ),
                                validator: (value) =>
                                value == null || value.trim().isEmpty ? "Account Name is required" : null,
                              ),
                              const SizedBox(height: 20),

                              // Account Class Dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedAccountClass,
                                items: _accounts.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAccountClass = value;
                                    _selectedSubType = null; // reset subtype
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Select Account Class ",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[700]!),
                                  ),
                                ),
                                validator: (value) => value == null ? 'Please select account class' : null,
                              ),
                              const SizedBox(height: 20),

                              // Sub-Type Dropdown (depends on Account Class)
                              if (_selectedAccountClass != null)
                                DropdownButtonFormField<String>(
                                  value: _selectedSubType,
                                  items: accountMap[_selectedAccountClass]!
                                      .map((subType) => DropdownMenuItem(
                                    value: subType,
                                    child: Text(subType),
                                  ))
                                      .toList(),
                                  onChanged: (value) => setState(() => _selectedSubType = value),
                                  decoration: InputDecoration(
                                    labelText: "Select Account Sub-Type ",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[700]!),
                                    ),
                                  ),
                                  validator: (value) => value == null ? 'Please select account sub-type' : null,
                                ),

                              const SizedBox(height: 30),

                              // Save Button
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00496d),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    progress!.show();

                                    try {
                                      String nameTxt = accountController.text.trim();
                                      String id = "${value.schoolid.toString().toLowerCase()}_${nameTxt.replaceAll(RegExp(r'\\s+'), '').toLowerCase()}";

                                      final data = CoaModel(
                                        name: nameTxt,
                                        schoolId: value.schoolid,
                                        accountType: _selectedAccountClass!,
                                        subType: _selectedSubType!, // added subtype
                                      );

                                      await value.db.collection("mainaccounts").doc(id).set(data.toJson());
                                      progress.dismiss();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Data Saved Successfully"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      accountController.clear();
                                      setState(() {
                                        _selectedAccountClass = null;
                                        _selectedSubType = null;
                                      });
                                    } catch (e) {
                                      progress.dismiss();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Failed to save data: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save, color: Colors.white),
                                label: const Text("Save Account", style: TextStyle(color: Colors.white)),
                              ),
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
