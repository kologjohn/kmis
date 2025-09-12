
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/componentmodel.dart';
import '../controller/dbmodels/regionmodel.dart';
import 'dropdown.dart';


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
        return StatefulBuilder(builder: (ctx2, setStateDialog) {
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
        });
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
                selectedLabels.isNotEmpty ? selectedLabels.join(", ") : (hintText.isNotEmpty ? hintText : "Select $label"),
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

class JudgeSetupPage extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const JudgeSetupPage({Key? key, this.staffData}) : super(key: key);

  @override
  _JudgeSetupPageState createState() => _JudgeSetupPageState();
}

class _JudgeSetupPageState extends State<JudgeSetupPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> selectedJudges = [];
  String? selectedZone;
  String? selectedRegion;
  String? season;
  String? episodeInt;
  List<String> selectedLevels = [];
  List<Map<String, dynamic>> selectedComponents = [];

  bool get isEdit => widget.staffData != null;
  RegionModel? selectedRegionModel;
  @override
  void initState() {
    super.initState();
    if (isEdit) {
      if (widget.staffData!.containsKey('judges')) {
        selectedJudges = List<String>.from(widget.staffData!['judges'] ?? []);
      } else if (widget.staffData!.containsKey('judge')) {
        final s = widget.staffData!['judge'];
        if (s != null) selectedJudges = [s.toString()];
      }

      selectedZone = widget.staffData!['zone'];
      selectedRegion = widget.staffData!['region'];
      selectedLevels =
      List<String>.from(widget.staffData!['level'] ?? <String>[]);
      episodeInt = widget.staffData!['episode'];
      selectedComponents =
      List<Map<String, dynamic>>.from(widget.staffData!['components'] ?? []);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.fetchAccessComponents();
      provider.getfetchRegions();
      provider.cfetchJudges();
      provider.getfetchLevels();
    });
  }
  /// safely parse marks
  int get totalSelectedMarks {
    return selectedComponents.fold(
      0,
          (sum, comp) =>
      sum + (int.tryParse(comp['totalmark']?.toString() ?? "0") ?? 0),
    );
  }
  ButtonStyle _btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
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
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final filteredComponents = value.accessComponents;
        final judgeItems = value.contestantJudges
            .map<MultiSelectItem<String>>((j) => MultiSelectItem<String>(
          value: (j['phone'] ?? j['id'] ?? '').toString(),
          label: (j['name'] ?? j['phone'] ?? j['id'] ?? '').toString(),
        ))
            .toList();

        // Build level items
        final levelItems = value.levelss
            .map<MultiSelectItem<String>>((lvl) => MultiSelectItem<String>(
          value: lvl.levelname,
          label: lvl.levelname,
        ))
            .toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            title: Text(
              isEdit ? 'Edit Judge' : 'Set Up Judge',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Judges multi-select
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown(
                          label: "Region",
                          items: value.regionList.map((r) => r.regionname).toList(),
                          value: selectedRegionModel?.regionname,
                          isLoading: false,
                            onChanged: (val) {
                              final region = value.regionList.firstWhere((r) => r.regionname == val);
                              setState(() {
                                selectedRegionModel = region;
                                selectedRegion = region.regionname;

                              });
                            },
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if ((selectedZone?.isNotEmpty ?? false))
                              Chip(
                                label: Text(
                                  selectedZone!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFF2D2F45),
                              ),
                            if ((episodeInt?.isNotEmpty ?? false))
                              Chip(
                                label: Text(
                                  episodeInt!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFF2D2F45),
                              ),
                          ],
                        ),
                         /*  TextFormField(
                          readOnly: true,
                          controller: episodeInt,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Episode",
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2D2F45),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Episode not found";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          readOnly: true,
                          controller: selectedZone,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Zone",
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2D2F45),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Zone not found";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),*/
                        const SizedBox(height: 12),
                        const Text("Select Judges",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        MultiSelectField<String>(
                          label: "Judges",
                          items: judgeItems,
                          selectedValues: selectedJudges,
                          hintText: "Select judges",
                          onConfirm: (newSelected) {
                            setState(() {
                              selectedJudges = newSelected;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                   const SizedBox(height: 12),
                  // Zone dropdown
                    /*   CustomDropdown(
                    label: "Zone",
                    items: value.zones.map((z)=>z.zonename).toList(),
                    value: selectedZone,
                    isLoading: value.isLoading,
                    onChanged: (val) => setState(() => selectedZone = val),
                  ),*/
                  const SizedBox(height: 12),
                  // Region dropdown


                  // Levels multi-select
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select Levels",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        MultiSelectField<String>(
                          label: "Levels",
                          items: levelItems,
                          selectedValues: selectedLevels,
                          hintText: "Select levels",
                          onConfirm: (newSelected) {
                            setState(() {
                              selectedLevels = newSelected;
                              selectedComponents.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Episode Dropdown (single select kept as before)

                  const SizedBox(height: 12),

                  // Components selection (unchanged)
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
                            bool isSelected = selectedComponents.contains(comp);
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
                  // Save + View Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: value.savingSetup
                            ? null
                            : () async {
                          if (!_formKey.currentState!.validate()) return;

                          if ([selectedZone, selectedRegion, episodeInt]
                              .contains(null) ||
                              selectedJudges.isEmpty ||
                              selectedLevels.isEmpty ||
                              selectedComponents.isEmpty) {
                            _showMsg(
                                context, "Please fill all fields", true);
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
                          try {
                            value.savingSetup = true;
                            await value.saveJudgeSetupMulti(
                              selectedJudges: selectedJudges,
                              selectedZone: selectedZone!,
                              selectedRegion: selectedRegion!,
                              episodeId: episodeInt!,
                              season: season,
                              selectedLevels: selectedLevels,
                              selectedComponents: selectedComponents.map((comp) => ComponentModel.fromMap(comp)).toList(),
                            );

                            _showMsg(context,
                                "Judge setup saved successfully.", false);

                            setState(() {
                              selectedJudges = [];
                            });
                          } catch (e) {
                            _showMsg(context, "Error: $e", true);
                          } finally {
                            value.savingSetup = false;
                          }
                        },
                        icon: value.savingSetup
                            ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save),
                        label: Text(
                            value.savingSetup ? "Saving..." : "Save Setup"),
                        style: _btnStyle(),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(Routes.judgelist);
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text("View Setup"),
                        style: _btnStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


