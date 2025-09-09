import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/dbmodels/episodeModel.dart';
import '../controller/dbmodels/levelmodel.dart';
import '../controller/dbmodels/weekmodel.dart';
import '../controller/dbmodels/zonemodels.dart';
import '../controller/routes.dart';
class Regionupdate extends StatefulWidget {
  final LevelModel region;

  const Regionupdate({super.key, required this.region});

  @override
  State<Regionupdate> createState() => _RegionupdateState();
}

class _RegionupdateState extends State<Regionupdate> {
  final regioncontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final inputFill = const Color(0xFF2C2C3C);
  // selected values
  String? selectedSeason;
  String? selectedWeek;
  String? selectedZone;
  String? selectedEpisode;

  @override
  void initState() {
    super.initState();
    regioncontroller.text = widget.region.levelname;
    selectedSeason = widget.region.season;
    selectedWeek = widget.region.week;
    selectedZone = widget.region.zone;
    selectedEpisode = widget.region.episode;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Consumer<Myprovider>(
        builder: (context, value, child) {
          final List<WeekModel> weeks = value.weeks;
          final List<ZoneModel> zones = value.zones;
          final List<EpisodeModel> episodes = value.episodes;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF2D2F45),
              title: const Text(
                "Update Region",
                style: TextStyle(color: Colors.white),
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
                    // region name
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

                    // Season Dropdown
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
                      onChanged: (val) {
                        setState(() => selectedSeason = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    //Week Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Week",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedWeek,
                      items: weeks
                          .map((w) => DropdownMenuItem(
                        value: w.weekname,
                        child: Text(w.weekname),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedWeek = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🔽 Zone Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Zone",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedZone,
                      items: zones
                          .map((z) => DropdownMenuItem(
                        value: z.zonename,
                        child: Text(z.zonename),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedZone = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🔽 Episode Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Episode",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedEpisode,
                      items: episodes
                          .map((e) => DropdownMenuItem(
                        value: e.episodename,
                        child: Text(e.episodename),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedEpisode = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    // buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final progress = ProgressHUD.of(context);
                              print("regionid:${widget.region.id}");
                              progress!.show();
                              final data = LevelModel(
                                id: widget.region.id,
                                levelname: regioncontroller.text.trim(),
                                time: DateTime.now(),
                                season: selectedSeason,
                                week: selectedWeek,
                                episode: selectedEpisode,
                                zone: selectedZone,
                              ).toMap();
                              await value.db
                                  .collection("regions")
                                  .doc(widget.region.id)
                                  .set(data, SetOptions(merge: true));

                              progress.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Region updated successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushNamed(context, Routes.regionlist);
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("Update Region"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.regionlist);
                          },
                          icon: const Icon(Icons.list),
                          label: const Text("Back to Regions"),
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
