
import 'package:ksoftsms/controller/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/dbmodels/regionmodel.dart';
import '../controller/myprovider.dart';

class Regionregistration extends StatefulWidget {
  final RegionModel? region;

  const Regionregistration({super.key, this.region});

  @override
  State<Regionregistration> createState() => _RegionregistrationState();
}

class _RegionregistrationState extends State<Regionregistration> {
  final regioncontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final inputFill = const Color(0xFF2C2C3C);

  String? selectedSeason;
  String? selectedWeek;
  String? selectedZone;
  String? selectedEpisode;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.getfetchZones();
      provider.getfetchSeasons();
      provider.getfetchWeeks();
      provider.getfetchEpisodes();
    });

    final data = widget.region;
    if (data != null) {
      print("✅ Editing Region: ${data.toMap()}");

      regioncontroller.text = data.regionname;
      selectedSeason = data.season;
      selectedWeek = data.week;
      selectedZone = data.zone;
      selectedEpisode = data.episode;
    } else {
      print("🆕 Registering new Region");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.region != null;
    print("isEdit = $isEdit, RegionData = ${widget.region?.toMap()}");

    return ProgressHUD(
      child: Consumer<Myprovider>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF2D2F45),
              title: Text(
                isEdit ? "Edit Region" : "Register Region",
                style: const TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
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
                    /// region name
                    TextFormField(
                      controller: regioncontroller,
                      decoration: InputDecoration(
                        labelText: "Region Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: inputFill,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Region name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// season dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Season",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedSeason,
                      items: value.seasons
                          .map((s) => DropdownMenuItem(
                        value: s.seasonname,
                        child: Text(s.seasonname),
                      ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedSeason = val),
                      validator: (val) =>
                      val == null ? "Please select a season" : null,
                    ),
                    const SizedBox(height: 20),

                    /// week dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Week",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedWeek,
                      items: value.weeks
                          .map((w) => DropdownMenuItem(
                        value: w.weekname,
                        child: Text(w.weekname),
                      ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedWeek = val),
                      validator: (val) =>
                      val == null ? "Please select a week" : null,
                    ),
                    const SizedBox(height: 20),

                    /// zone dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Zone",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedZone,
                      items: value.zones
                          .map((z) => DropdownMenuItem(
                        value: z.zonename,
                        child: Text(z.zonename),
                      ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedZone = val),
                      validator: (val) =>
                      val == null ? "Please select a zone" : null,
                    ),
                    const SizedBox(height: 20),

                    /// episode dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Episode",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedEpisode,
                      items: value.episodes
                          .map((e) => DropdownMenuItem(
                        value: e.episodename,
                        child: Text(e.episodename),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedEpisode = val),
                      validator: (val) =>
                      val == null ? "Please select an episode" : null,
                    ),
                    const SizedBox(height: 20),

                    /// buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final progress = ProgressHUD.of(context);
                              progress!.show();

                              final regionData = RegionModel(
                                id: regioncontroller.text.trim(),
                                regionname: regioncontroller.text.trim(),
                                season: selectedSeason ?? '',
                                week: selectedWeek ?? '',
                                zone: selectedZone ?? '',
                                episode: selectedEpisode ?? '',
                                time: DateTime.now(),
                              ).toMap();
                              final docId = "${regioncontroller.text.trim()}${selectedSeason ?? ''}"
                                  .replaceAll(" ", "")
                                  .toLowerCase();


                              await value.db
                                  .collection("regions")
                                  .doc(docId)
                                  .set(regionData, SetOptions(merge: true));

                              progress.dismiss();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEdit
                                      ? "Region updated successfully"
                                      : "Region registered successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              if (!isEdit) regioncontroller.clear();
                            }
                          },
                          icon: Icon(isEdit ? Icons.update : Icons.save),
                          label: Text(
                              isEdit ? "Update Region" : "Register Region"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.go(Routes.regionlist),
                          icon: const Icon(Icons.list),
                          label: const Text("View Regions"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
