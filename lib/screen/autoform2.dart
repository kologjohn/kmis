import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  List ff=[];
  double total = 0;
  @override
  void initState() {
    super.initState();
    _initializeAfterBuild();
  }

  void _initializeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.initializeControllers(provider.contestantScores);
      provider.calculateCriteriaTotal(provider.contestantScores.keys.toList());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double inputwidth = 400;
    final inputFill = Color(0xFF2C2C3C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Provider.of<Myprovider>(context, listen: false).clearControllers();
            context.go(Routes.scores);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              tooltip: "View scores",
              color: Colors.white,
              icon: const Icon(Icons.add_chart_sharp),
              onPressed: () {
                context.go(Routes.viewmarks);
              },
            ),
          ),
        ],
        title: const Text(
          "Score Sheet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E2C),
      body: Consumer<Myprovider>(
        builder: (context, value, child) {
          if (value.pagekey != "nokia3310"|| value.scoringid.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                const SizedBox(height: 12),
                const Text("Permission denied. Please select a contestant first."),
              ],
            );
          }

          if (value.isLoadingAccessComponents || value.accessComponents.isEmpty) {
            return const Center(
              child:
              Text("Loading form data..."),
            );
          }
          final imageUrl = value.imageUrl;
          final keys = value.contestantScores.keys.toList();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: const Color(0xFF2D2F45),
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: (imageUrl != null && imageUrl.trim().isNotEmpty)
                                        ? NetworkImage(imageUrl)
                                        : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    value.contestantName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Text(
                                    value.contestantID,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),


                ...keys.map((key) {

                            final matchingComponent = value.accessComponents.firstWhere(
                                  (comp) => comp['name'] == key,
                              orElse: () => {},
                            );
                            final totalMark = matchingComponent.isNotEmpty
                                ? matchingComponent['totalmark'].toString()
                                : "N/A";
                            if (matchingComponent.isEmpty || totalMark == "N/A") {
                              final errormessage = matchingComponent.isEmpty
                                  ? "$key is missing from the component setup."
                                  : "Total mark for \"$key\" is not available. Please check setup.";

                              final hintmessage = matchingComponent.isEmpty
                                  ? "This component hasn’t been configured yet.Contact your administrator."
                                  : "The total mark for \"$key\" is missing or invalid. Check the component setup for scoring details.";
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Tooltip(
                                  message: hintmessage,
                                  preferBelow: false,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  textStyle: const TextStyle(color: Colors.white),
                                  child: SizedBox(
                                    width: inputwidth,
                                    child: TextFormField(
                                      onChanged: (val){
                                        print("val");

                                        //value.updateTotalScore();
                                      },
                                      controller: value.controllers[key],
                                      decoration: InputDecoration(
                                        labelText: errormessage,
                                        labelStyle: const TextStyle(color: Colors.redAccent),
                                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        filled: true,
                                        fillColor: inputFill,
                                      ),
                                      enabled: false,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                width: inputwidth,
                                child: TextFormField(
                                  controller: value.controllers[key],
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "$key (Marks: $totalMark)",
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: inputFill,
                                  ),
                                   onChanged: (val){
                                    ff.clear();
                                    print("val");
                                    },

                                    //value.updateTotalScore();
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  //maxLength:maxchar,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Required';
                                    }

                                    final trimmedVal = val.trim();
                                    final doubleValue = double.tryParse(trimmedVal);

                                    if (doubleValue == null || doubleValue < 0) {
                                      return 'Enter a valid non-negative number';
                                    }
                                    final double maxAllowed = double.tryParse(totalMark) ?? 0;
                                    final int maxchar = totalMark.length;
                                    if (trimmedVal.contains('.')) {
                                      // Logic for decimal numbers: max length = totalMark length + 2
                                      final int adjustedMaxChar = maxchar + 2;
                                      if (trimmedVal.length > adjustedMaxChar) {
                                        return 'Maximum $adjustedMaxChar characters allowed';
                                      }
                                    } else {
                                      // Logic for non-decimal (integer) numbers: max length = 2
                                      if (trimmedVal.length > maxchar) {
                                        return 'Maximum $maxchar characters allowed';
                                      }
                                    }

                                    if (doubleValue > maxAllowed) {
                                      return 'Cannot exceed $maxAllowed';
                                    }
                                    ff.add(double.parse(trimmedVal.toString()));

                                    for(int i=0;i<ff.length;i++){

                                      total+=double.parse(ff[i].toString());
                                    }
                                    print(ff);
                                    //value.updateTotalScore();
                                     // ff.clear();
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                              inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                                ),
                              ),
                            );
                          }),


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: inputwidth,
                              child: TextFormField(
                                controller: value.totalController,
                                decoration: InputDecoration(
                                  labelText: "Total Score",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[700]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[700]!),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  filled: true,
                                  fillColor: inputFill,
                                ),
                                enabled: false,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: value.savingSetup
                                ? null
                                : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                try {
                               final success= await value.validateAndSubmitDynamicFields(value.scoringid, value.contestantID,context);
                                  if(!mounted)return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Submission successful'), backgroundColor: Colors.green),
                                    );
                                    context.go(Routes.scores);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Submission failed or invalid input'), backgroundColor: Colors.red),
                                    );
                                  }
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
                            icon: value.savingSetup
                                ? const SizedBox(
                                 width: 20,
                                  height: 20,
                                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Icon(Icons.save),
                            label: value.savingSetup
                                ? const Text('')
                                : const Text('Save Score'),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}