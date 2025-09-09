
/*
import 'dart:async';
import 'package:bookwormproject/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dropdown.dart';

class ContestantSetup extends StatefulWidget {
  const ContestantSetup({super.key});

  @override
  State<ContestantSetup> createState() => _ContestantSetupState();
}

class _ContestantSetupState extends State<ContestantSetup> {
  final _formKey = GlobalKey<FormState>();
  final _contestantController = TextEditingController();
  Timer? _debounce;
  String? episodeInt;
  String? selectedJudges;
  List<Map<String, dynamic>> selectedComponents = [];

  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) =>
      sum + (int.tryParse(comp['totalmark']?.toString() ?? "0") ?? 0),
    );
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Myprovider>(context, listen: false);
    provider.cfetchJudges();
    provider.fetchAccessComponents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _contestantController.dispose();
    super.dispose();
  }


  InputDecoration _styledDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestant = value.contestantInfo;
        final filteredComponents = value.accessComponents;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            iconTheme: IconThemeData(color: Colors.white),
            title: const Text("Judge Scoring Setup",style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Contestant ID Input
                  TextFormField(
                    controller: _contestantController,
                    decoration: InputDecoration(
                      labelText: "Enter Contestant ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final id = _contestantController.text.trim();
                          if (id.isNotEmpty) {
                            value.fetchContestantInfo(id);
                          }
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (id) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 50), () {
                            if (id.trim().isNotEmpty) {
                              value.fetchContestantInfo(id.trim());
                            }
                          });
                    },
                    onFieldSubmitted: (id) {
                      if (id.trim().isNotEmpty) {
                        value.fetchContestantInfo(id.trim());
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Contestant Info Fields
                  if (value.contestantLoading)
                    const CircularProgressIndicator()
                  else if (contestant != null) ...[
                    /// Just show a few key fields (others are still preserved in the map)
                    TextFormField(
                      initialValue: contestant["name"] ?? "",
                      decoration: _styledDecoration("Name"),
                      enabled: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: contestant["id"] ?? "",
                      decoration: _styledDecoration("ID"),
                      enabled: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: contestant["level"] ?? "",
                      decoration: _styledDecoration("Level"),
                      enabled: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: contestant["region"] ?? "",
                      decoration: _styledDecoration("Region"),
                      enabled: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: contestant["zone"] ?? "",
                      decoration: _styledDecoration("Zone"),
                      enabled: true,
                    ),
                  ] else
                    const Text("No contestant found"),

                  const SizedBox(height: 20),

                  /// Episode Dropdown
                  CustomDropdown(
                    label: "Episode",
                    items: value.episodes.map((e) => e.episodename).toList(),
                    value: episodeInt,
                    isLoading: value.loadingEpisodes,
                    onChanged: (val) => setState(() => episodeInt = val),
                  ),
                  const SizedBox(height: 20),

                  /// Judges Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedJudges,
                    items: value.contestantJudges.map<DropdownMenuItem<String>>((judge) {
                      return DropdownMenuItem<String>(
                        value: judge["phone"],
                        child: Text(judge["name"] ?? "Unknown"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedJudges = val;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Judge",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Components Multi-Select
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Components",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (filteredComponents.isEmpty)
                        const Text(
                          "No components found",
                          style: TextStyle(color: Colors.redAccent),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: filteredComponents.map((comp) {
                            bool isSelected =
                            selectedComponents.contains(comp);
                            return ChoiceChip(
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    comp['name'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  Text(
                                    "Mark: ${comp['totalmark']}",
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 11,
                                    ),
                                  ),
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
                      const SizedBox(height: 12),

                      if (selectedComponents.isNotEmpty)
                        Text(
                          "Total Selected Marks: $totalSelectedMarks",
                          style: const TextStyle(
                            color: Colors.lightGreenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Save Button
                  ElevatedButton.icon(
                    onPressed: value.contestantSaving
                        ? null
                        : () async {

                      if (_contestantController.text.isEmpty ||
                          contestant == null ||
                          episodeInt == null ||
                          selectedJudges==null ||
                          selectedComponents.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Please complete all fields")),
                        );
                        return;
                      }
                      final query = await value.db
                          .collection('episodes')
                          .where('name', isEqualTo: episodeInt)
                          .limit(1)
                          .get();

                      if (query.docs.isEmpty) {
                        _showMsg(
                            context, "Episode not found in Firestore", true);
                        return;
                      }

                      final episodeData = query.docs.first.data();
                      final int episodeTotal = int.tryParse(episodeData['totalMark']?.toString() ?? "0") ?? 0;

                      if (totalSelectedMarks > episodeTotal) {
                        _showMsg(
                          context,
                          "Total marks of components ($totalSelectedMarks) must equal episode total ($episodeTotal)",
                          true,
                        );
                        return;
                      }


                      await value.saveScoring(
                        contestant: Map<String, dynamic>.from(contestant),
                        episodeId: episodeInt!.toString(),
                        episodeTitle: episodeInt!.toString(),
                        selectedJudges: selectedJudges!,
                        selectedComponents: selectedComponents,
                        contestantId: contestant["studentId"] ?? contestant["id"] ?? "",
                        // ✅ safe ID
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("Scoring saved successfully")),
                      );
                    },
                    icon: value.contestantSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.save),
                    label: Text(value.contestantSaving ? "Saving..." : "Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
*/


/*
import 'dart:async';
import 'package:bookwormproject/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dropdown.dart';

class ContestantSetup extends StatefulWidget {
  const ContestantSetup({super.key});

  @override
  State<ContestantSetup> createState() => _ContestantSetupState();
}

class _ContestantSetupState extends State<ContestantSetup> {
  final _formKey = GlobalKey<FormState>();
  final _contestantController = TextEditingController();
  Timer? _debounce;
  String? episodeInt;
  String? selectedJudges;
  List<Map<String, dynamic>> selectedComponents = [];

  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) =>
      sum + (int.tryParse(comp['totalmark']?.toString() ?? "0") ?? 0),
    );
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Myprovider>(context, listen: false);
    provider.cfetchJudges();
    provider.fetchAccessComponents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _contestantController.dispose();
    super.dispose();
  }

  InputDecoration _styledDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestant = value.contestantInfo;
        final filteredComponents = value.accessComponents;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Judge Scoring Setup",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Contestant ID Input
                  TextFormField(
                    controller: _contestantController,
                    decoration: InputDecoration(
                      labelText: "Enter Contestant ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final id = _contestantController.text.trim();
                            value.fetchContestantInfo(id);
                          } else {
                            value.clearContestant();
                          }
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Contestant ID is required";
                      }
                      if (val.trim().length < 2) {
                        return "Enter at least 2 characters";
                      }
                      return null;
                    },
                    onChanged: (id) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        if (id.trim().isEmpty || id.trim().length < 2) {
                          value.clearContestant();
                        } else {
                          value.fetchContestantInfo(id.trim());
                        }
                      });
                    },
                    onFieldSubmitted: (id) {
                      if (_formKey.currentState?.validate() ?? false) {
                        value.fetchContestantInfo(id.trim());
                      } else {
                        value.clearContestant();
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  /// Contestant Info Fields
                  if (value.contestantLoading)
                  const CircularProgressIndicator()
                  else if (contestant != null) ...[
                    TextFormField(
                      controller: TextEditingController(
                          text: contestant["name"] ?? ""),
                      decoration: _styledDecoration("Name"),
                      enabled: true,
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller:
                      TextEditingController(text: contestant["id"] ?? ""),
                      decoration: _styledDecoration("ID"),
                      enabled: true,
                        readOnly: true
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(
                          text: contestant["level"] ?? ""),
                      decoration: _styledDecoration("Level"),
                      enabled: true,
                        readOnly: true
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(
                          text: contestant["region"] ?? ""),
                      decoration: _styledDecoration("Region"),
                      enabled: true,
                        readOnly: true
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(
                          text: contestant["zone"] ?? ""),
                      decoration: _styledDecoration("Zone"),
                      enabled: true,
                        readOnly: true
                    ),
                  ] else
                    const Text("No contestant found"),

                  const SizedBox(height: 20),

                  /// Episode Dropdown
                  CustomDropdown(
                    label: "Episode",
                    items: value.episodes.map((e) => e.episodename).toList(),
                    value: episodeInt,
                    isLoading: value.loadingEpisodes,
                    onChanged: (val) => setState(() => episodeInt = val),
                  ),
                  const SizedBox(height: 20),

                  /// Judges Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedJudges,
                    items: value.contestantJudges
                        .map<DropdownMenuItem<String>>((judge) {
                      return DropdownMenuItem<String>(
                        value: judge["phone"],
                        child: Text(judge["name"] ?? "Unknown"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedJudges = val;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Judge",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Components Multi-Select
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Components",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (filteredComponents.isEmpty)
                        const Text(
                          "No components found",
                          style: TextStyle(color: Colors.redAccent),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: filteredComponents.map((comp) {
                            bool isSelected =
                            selectedComponents.contains(comp);
                            return ChoiceChip(
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    comp['name'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  Text(
                                    "Mark: ${comp['totalmark']}",
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 11,
                                    ),
                                  ),
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
                      const SizedBox(height: 12),

                      if (selectedComponents.isNotEmpty)
                        Text(
                          "Total Selected Marks: $totalSelectedMarks",
                          style: const TextStyle(
                            color: Colors.lightGreenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Save Button
                  ElevatedButton.icon(
                    onPressed: value.contestantSaving
                        ? null
                        : () async {
                      if (_contestantController.text.isEmpty ||
                          contestant == null ||
                          episodeInt == null ||
                          selectedJudges == null ||
                          selectedComponents.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please complete all fields")),
                        );
                        return;
                      }
                      final query = await value.db
                          .collection('episodes')
                          .where('name', isEqualTo: episodeInt)
                          .limit(1)
                          .get();

                      if (query.docs.isEmpty) {
                        _showMsg(context,
                            "Episode not found in Firestore", true);
                        return;
                      }

                      final episodeData = query.docs.first.data();
                      final int episodeTotal = int.tryParse(
                          episodeData['totalMark']?.toString() ??
                              "0") ??
                          0;

                      if (totalSelectedMarks > episodeTotal) {
                        _showMsg(
                          context,
                          "Total marks of components ($totalSelectedMarks) must equal episode total ($episodeTotal)",
                          true,
                        );
                        return;
                      }

                      await value.saveScoring(
                        contestant:
                        Map<String, dynamic>.from(contestant),
                        episodeId: episodeInt!.toString(),
                        episodeTitle: episodeInt!.toString(),
                        selectedJudges: selectedJudges!,
                        selectedComponents: selectedComponents,
                        contestantId: contestant["studentId"] ??
                            contestant["id"] ??
                            "",
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Scoring saved successfully")),
                      );
                    },
                    icon: value.contestantSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.save),
                    label: Text(
                        value.contestantSaving ? "Saving..." : "Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
*/

/*
import 'dart:async';
import 'package:bookwormproject/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dropdown.dart';

class ContestantSetup extends StatefulWidget {
  const ContestantSetup({super.key});

  @override
  State<ContestantSetup> createState() => _ContestantSetupState();
}

class _ContestantSetupState extends State<ContestantSetup> {
  final _formKey = GlobalKey<FormState>();
  final _contestantController = TextEditingController();
  Timer? _debounce;

  String? episodeInt;
  List<String> selectedJudges = []; // ✅ multiple judges
  List<Map<String, dynamic>> selectedComponents = [];
  List<Map<String, dynamic>> selectedContestants = []; // ✅ multiple contestants

  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) => sum + (int.tryParse(comp['totalmark']?.toString() ?? "0") ?? 0),
    );
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Myprovider>(context, listen: false);
    provider.cfetchJudges();
    provider.fetchAccessComponents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _contestantController.dispose();
    super.dispose();
  }

  InputDecoration _styledDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestant = value.contestantInfo;
        final filteredComponents = value.accessComponents;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Judge Scoring Setup",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Contestant Search
                  TextFormField(
                    controller: _contestantController,
                    decoration: InputDecoration(
                      labelText: "Enter Contestant ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final id = _contestantController.text.trim();
                            value.fetchContestantInfo(id);
                          } else {
                            value.clearContestant();
                          }
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Contestant ID is required";
                      }
                      if (val.trim().length < 2) {
                        return "Enter at least 2 characters";
                      }
                      return null;
                    },
                    onChanged: (id) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        if (id.trim().isEmpty || id.trim().length < 2) {
                          value.clearContestant();
                        } else {
                          value.fetchContestantInfo(id.trim());
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Add Contestant to List
                  if (contestant != null) ...[
                    ListTile(
                      title: Text("${contestant["name"]} (${contestant["id"]})"),
                      subtitle: Text("${contestant["level"]} - ${contestant["region"]}, ${contestant["zone"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            if (!selectedContestants.any((c) => c["id"] == contestant["id"])) {
                              selectedContestants.add(Map<String, dynamic>.from(contestant));
                            }
                          });
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// Selected Contestants List
                  if (selectedContestants.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Selected Contestants:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...selectedContestants.map((c) => ListTile(
                          title: Text("${c["name"]} (${c["id"]})"),
                          subtitle: Text("${c["level"]} - ${c["region"]}, ${c["zone"]}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedContestants.remove(c);
                              });
                            },
                          ),
                        )),
                      ],
                    ),

                  const SizedBox(height: 20),

                  /// Episode Dropdown
                  CustomDropdown(
                    label: "Episode",
                    items: value.episodes.map((e) => e.episodename).toList(),
                    value: episodeInt,
                    isLoading: value.loadingEpisodes,
                    onChanged: (val) => setState(() => episodeInt = val),
                  ),
                  const SizedBox(height: 20),

                  /// Judges Multi-Select
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select Judges:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: value.contestantJudges.map<Widget>((judge) {
                          final phone = judge["phone"];
                          final name = judge["name"] ?? "Unknown";
                          final selected = selectedJudges.contains(phone);

                          return FilterChip(
                            label: Text(name),
                            selected: selected,
                            onSelected: (sel) {
                              setState(() {
                                if (sel) {
                                  selectedJudges.add(phone);
                                } else {
                                  selectedJudges.remove(phone);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Components Multi-Select
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select Components:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filteredComponents.map((comp) {
                          bool isSelected = selectedComponents.contains(comp);
                          return ChoiceChip(
                            label: Text("${comp['name']} (${comp['totalmark']})"),
                            selected: isSelected,
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
                      if (selectedComponents.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Total Selected Marks: $totalSelectedMarks",
                            style: const TextStyle(
                                color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Save Button
                  ElevatedButton.icon(
                    onPressed: value.contestantSaving
                        ? null
                        : () async {
                      if (selectedContestants.isEmpty ||
                          episodeInt == null ||
                          selectedJudges.isEmpty ||
                          selectedComponents.isEmpty) {
                        _showMsg(context, "Please complete all fields", true);
                        return;
                      }

                      await value.saveJudgeSetupMulti(
                        selectedJudges: selectedJudges,
                        selectedLevels: selectedContestants.map<String>((c) => c["level"].toString())
                            .toList(),
                        selectedComponents: selectedComponents,
                        selectedZone: selectedContestants.first["zone"],
                        selectedRegion: selectedContestants.first["region"],
                        episodeId: episodeInt!,
                        episodeTitle: episodeInt!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Setup saved successfully")),
                      );

                      setState(() {
                        selectedContestants.clear();
                        selectedJudges.clear();
                        selectedComponents.clear();
                        episodeInt = null;
                      });
                    },
                    icon: const Icon(Icons.save),
                    label: Text(value.contestantSaving ? "Saving..." : "Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
*/

/*
import 'dart:async';
import 'package:bookwormproject/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../controller/dbmodels/componentmodel.dart';
import 'dropdown.dart';

class ContestantSetup extends StatefulWidget {
  const ContestantSetup({super.key});

  @override
  State<ContestantSetup> createState() => _ContestantSetupState();
}

class _ContestantSetupState extends State<ContestantSetup> {
  final _formKey = GlobalKey<FormState>();
  final _contestantController = TextEditingController();
  Timer? _debounce;

  String? episodeInt;
  List<String> selectedJudges = [];
  //List<Map<String, dynamic>> selectedComponents = [];
  List<ComponentModel> selectedComponents = [];
  List<Map<String, dynamic>> selectedContestants = [];
  String? currentRegion;
  String? currentEpisode;
  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) =>
      sum + (int.tryParse(comp['totalmark']?.toString() ?? "0") ?? 0),
    );
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Myprovider>(context, listen: false);
    provider.cfetchJudges();
    provider.fetchAccessComponents();
   // final contestant = provider.contestantInfo;
   // final filteredComponents = provider.accessComponents;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _contestantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestant = value.contestantInfo;
        final filteredComponents = value.accessComponents;

        return ProgressHUD(
          child: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF2D2F45),
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Judge Scoring Setup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Contestant Search

                      TextFormField(
                        controller: _contestantController,
                        decoration: InputDecoration(
                          labelText: "Enter Contestant ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final hud = ProgressHUD.of(context);
                                hud?.showWithText("Searching...");
                                final idd = _contestantController.text.trim();
                                final id =idd.toUpperCase();
                                await value.fetchContestantInfo(id);
                                hud?.dismiss();
                              } else {
                                value.clearContestant();
                              }
                            },
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Contestant ID is required";
                          }
                          if (val.trim().length < 2) {
                            return "Enter at least 2 characters";
                          }
                          return null;
                        },
                        onChanged: (id) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 100), () async {
                                if (id.trim().isEmpty || id.trim().length < 2) {
                                  value.clearContestant();
                                } else {
                                  final hud = ProgressHUD.of(context);
                                  hud?.showWithText("Searching...");
                                  await value.fetchContestantInfo(id.trim());
                                  hud?.dismiss();
                                }
                              });
                        },
                      ),

                      const SizedBox(height: 15),

                      if (contestant != null) ...[
                        ListTile(
                          title: Text("${contestant["name"]} (${contestant["id"]})",style: TextStyle(color: Colors.white),),
                          subtitle: Text(
                              "${contestant["level"]} - ${contestant["region"]}, ${contestant["zone"]}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.green),
                            onPressed: () {
                              setState(() {
                                if (!selectedContestants.any(
                                        (c) => c["id"] == contestant["id"])) {
                                  selectedContestants
                                      .add(Map<String, dynamic>.from(contestant));
                                }
                              });
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                      if (selectedContestants.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Selected Contestants:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                             Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: selectedContestants.map((c) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                   horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFF2D2F45),
                                    // border: Border.all(
                                    //     color: Colors.deepOrange, width: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.deepOrange,
                                        child: Text(
                                          c["name"]
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("${c["name"]} (${c["id"]})",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text("${c["level"]} - ${c["region"]}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.close,
                                            color: Colors.red, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            selectedContestants.remove(c);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),
                      /// Judges Multi-Select
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Judges:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: value.contestantJudges.map<Widget>((judge) {
                              final phone = judge["phone"].toString();
                              final name = judge["name"] ?? "Unknown";
                              final selected = selectedJudges.contains(phone);

                              return FilterChip(
                                label: Text(name,style: TextStyle(color: Colors.white),),
                                selected: selected,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      selectedJudges.add(phone);
                                    } else {
                                      selectedJudges.remove(phone);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      /// Components Multi-Select
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Components:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: filteredComponents.map((comp) {
                              final compMap =
                              Map<String, dynamic>.from(comp); // normalize
                              bool isSelected = selectedComponents
                                  .any((c) => c["id"] == compMap["id"]);

                              return ChoiceChip(
                                label: Text(
                                    "${compMap['name']} (${compMap['totalmark']})",style: TextStyle(color: Colors.white),),
                                selected: isSelected,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      selectedComponents.add(compMap);
                                    } else {
                                      selectedComponents.removeWhere(
                                              (c) => c["id"] == compMap["id"]);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          if (selectedComponents.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Total Selected Marks: $totalSelectedMarks",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Save Button
                      /*
                      ElevatedButton.icon(
                        onPressed: value.contestantSaving
                            ? null
                            : () async {
                          if (selectedContestants.isEmpty ||
                              episodeInt == null ||
                              selectedJudges.isEmpty ||
                              selectedComponents.isEmpty) {
                            _showMsg(context, "Please complete all fields",
                                true);
                            return;
                          }

                          final hud = ProgressHUD.of(context);
                          hud?.showWithText("Saving...");

                          await value.saveJudgeSetupForSelectedContestants(
                            selectedJudges: selectedJudges,
                            selectedContestants: selectedContestants,
                            selectedComponents: selectedComponents,
                            episodeId: episodeInt!,
                            episodeTitle: episodeInt!,
                          );

                          hud?.dismiss();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Setup saved successfully")),
                          );

                          setState(() {
                            selectedContestants.clear();
                            selectedJudges.clear();
                            selectedComponents.clear();
                            episodeInt = null;
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: Text(
                            value.contestantSaving ? "Saving..." : "Save"),
                      ),
                      */
                     InkWell(
                          onTap: value.contestantSaving
                              ? null
                              : () async {
                            if (selectedContestants.isEmpty ||
                                episodeInt == null ||
                                selectedJudges.isEmpty ||
                                selectedComponents.isEmpty) {
                              _showMsg(context, "Please complete all fields", true);
                              return;
                            }

                            final hud = ProgressHUD.of(context);
                            hud?.showWithText("Saving...");

                            await value.saveJudgeSetupForSelectedContestants(
                              selectedJudges: selectedJudges,
                              selectedContestants: selectedContestants,
                              selectedComponents:  selectedComponents
                                .map((m) => ComponentModel.fromMap(m))
                                .toList(),

                            );

                            hud?.dismiss();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Setup saved successfully")),
                            );

                            setState(() {
                              selectedContestants.clear();
                              selectedJudges.clear();
                              selectedComponents.clear();
                              episodeInt = '';
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D2F45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  value.contestantSaving ? "Saving..." : "Save",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
}
*/
import 'dart:async';
import 'package:ksoftsms/controller/dbmodels/levelmodel.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../controller/dbmodels/componentmodel.dart';
import '../controller/routes.dart';
import 'dropdown.dart';

class ContestantSetup extends StatefulWidget {
  const ContestantSetup({super.key});

  @override
  State<ContestantSetup> createState() => _ContestantSetupState();
}

class _ContestantSetupState extends State<ContestantSetup> {
  final _formKey = GlobalKey<FormState>();
  final _contestantController = TextEditingController();
  Timer? _debounce;

  //String? episodeInt;
  List<String> selectedJudges = [];
  List<ComponentModel> selectedComponents = [];
  List<LevelModel> selectedLevels = [];
  List<Map<String, dynamic>> selectedContestants = [];

  String? currentRegion;
  String? currentEpisode;

  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) => sum + (int.tryParse(comp.totalMark) ?? 0),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.cfetchJudges();
      provider.fetchAccessComponents();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _contestantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestant = value.contestantInfo;
        final filteredComponents = value.accessComponents;

        return ProgressHUD(
          child: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF2D2F45),
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Contestant set up",
                  style: TextStyle(color: Colors.white),
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Contestant Search
                      TextFormField(
                        controller: _contestantController,
                        decoration: InputDecoration(
                          labelText: "Enter Contestant ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final hud = ProgressHUD.of(context);
                                hud?.showWithText("Searching...");
                                final idd = _contestantController.text.trim();
                                final id = idd.toUpperCase();
                                await value.fetchContestantInfo(id);
                                hud?.dismiss();
                              } else {
                               value.clearContestant();
                              }
                            },
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Contestant ID is required";
                          }
                          if (val.trim().length < 2) {
                            return "Enter at least 2 characters";
                          }
                          return null;
                        },
                        onChanged: (id) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 100), () async {
                                if (id.trim().isEmpty || id.trim().length < 2) {
                                  value.clearContestant();
                                } else {
                                  final hud = ProgressHUD.of(context);
                                  hud?.showWithText("Searching...");
                                  await value.fetchContestantInfo(id.trim().toUpperCase());
                                  hud?.dismiss();
                                }
                              });
                        },
                      ),

                      const SizedBox(height: 15),
                      if (contestant != null) ...[
                        ListTile(
                          title: Text(
                            "${contestant["name"]} (${contestant["id"]})",
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                         "${contestant["level"]} - ${contestant["region"]}, ${contestant["zone"]}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle,
                            color: Colors.green),
                            onPressed: () {
                              setState(() {
                                if (!selectedContestants.any(
                                (c) => c["id"] == contestant["id"])) {
                                  selectedContestants.add(
                                    Map<String, dynamic>.from(contestant),
                                  );
                                  final levelName = contestant["level"]?.toString();
                                  if (levelName != null && levelName.isNotEmpty) {
                                    // Try to find LevelModel in provider’s level list
                                    final levelModel = value.levelss.firstWhere(
                                          (lvl) => lvl.levelname == levelName,
                                      orElse: () => LevelModel(
                                        id: levelName, // fallback in case not found
                                        levelname: levelName,
                                      ),
                                    );

                                    // Add only if not already there
                                    if (!selectedLevels.any((lvl) => lvl.id == levelModel.id)) {
                                      selectedLevels.add(levelModel);
                                    }
                                  }
                                  // Debug
                                //  print("Selected contestants: $selectedContestants");
                                //  print("Selected levels: $selectedLevels");
                                }
                              });
                            },
                          ),


                        ),
                      ],
                      const SizedBox(height: 20),
                      if (selectedContestants.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Selected Contestants:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: selectedContestants.map((c) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.deepOrange,
                                        child: Text(
                                          c["name"]
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("${c["name"]} (${c["id"]})",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text("${c["level"]} - ${c["region"]}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.close,
                                            color: Colors.red, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            selectedContestants.remove(c);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      /// Judges Multi-Select
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Judges:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: value.contestantJudges.map<Widget>((judge) {
                              final phone = judge["phone"].toString();
                              final name = judge["name"] ?? "Unknown";
                              final selected = selectedJudges.contains(phone);

                              return FilterChip(
                                label: Text(name,
                                    style: TextStyle(color: Colors.white)),
                                selected: selected,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      selectedJudges.add(phone);
                                    } else {
                                      selectedJudges.remove(phone);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Components Multi-Select
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Components:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: filteredComponents.map((comp) {
                              final compMap =
                              Map<String, dynamic>.from(comp); // normalize
                              final compModel =
                              ComponentModel.fromMap(compMap);
                              bool isSelected = selectedComponents
                                  .any((c) => c.name == compModel.name);

                              return ChoiceChip(
                                label: Text(
                                  "${compModel.name} (${compModel.totalMark})",
                                  style: TextStyle(color: Colors.white),
                                ),
                                selected: isSelected,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      selectedComponents.add(compModel);
                                    } else {
                                      selectedComponents.removeWhere(
                                              (c) => c.name == compModel.name);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          if (selectedComponents.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Total Selected Marks: $totalSelectedMarks",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Save Button
                      InkWell(
                        onTap: value.contestantSaving
                            ? null
                            : () async {
                          if (selectedContestants.isEmpty ||
                              selectedJudges.isEmpty ||
                              selectedComponents.isEmpty) {
                            _showMsg(context,
                                "Please complete all fields", true);
                            return;
                          }

                          final hud = ProgressHUD.of(context);
                         hud?.showWithText("Saving...");


                          await value
                              .saveJudgeSetupForSelectedContestants(
                            selectedJudges: selectedJudges,
                            selectedContestants: selectedContestants,
                            selectedComponents: selectedComponents,
                            levels: selectedLevels,

                          );

                         hud?.dismiss();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text("Setup saved successfully")),
                          );

                          setState(() {
                            selectedContestants.clear();
                            selectedJudges.clear();
                            selectedComponents.clear();
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2F45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                value.contestantSaving ? "Saving..." : "Save",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
}
