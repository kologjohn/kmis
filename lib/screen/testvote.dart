
import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/regionmodel.dart';
import '../controller/routes.dart';
import 'dropdown.dart';

class Testvote extends StatefulWidget {
  const Testvote({super.key});

  @override
  State<Testvote> createState() => _TestvoteState();
}

class _TestvoteState extends State<Testvote> {
  String? selectedDate;
  String? selectedRegion;
  String? season;
  String? episodeInt;
  RegionModel? selectedRegionModel;

  final regionMapping = {
    "Northern": 175,
    "Bono": 176,
    "Western": 177,
    "Volta": 178,
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.getfetchRegions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (BuildContext context, Myprovider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
              title: const Text('Update Contestants  Vote'),
              leading: IconButton(
               icon: const Icon(Icons.arrow_back, color: Colors.black12),
          onPressed: () => context.go(Routes.dashboard),
        ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Select Region
                CustomDropdown(
                  label: "Region",
                  items: value.regionList.map((r) => r.regionname).toList(),
                  value: selectedRegionModel?.regionname,
                  isLoading: value.isLoadingRegions,
                  onChanged: (val) {
                    final region = value.regionList
                        .firstWhere((r) => r.regionname == val);

                    setState(() {
                      selectedRegionModel = region;
                      selectedRegion = region.regionname;
                      episodeInt = region.episode;
                      season = region.season;
                    });

                    // 🔹 Fetch available dates using mapped regionId
                    final regionId = regionMapping[region.regionname];
                    if (regionId != null) {
                      value.loadAvailableDates(regionId.toString()).then((_) {
                        setState(() {
                          selectedDate = value.selectedDate; // ✅ sync with provider
                        });
                      });
                    }
                  },
                ),

                // 🔹 Select Date
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Date",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDate,
                  items: value.availableDates
                      .map<DropdownMenuItem<String>>((date) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDate = val;
                    });
                  },
                ),

                const SizedBox(height: 20),
                Text(value.progress),

                const SizedBox(height: 20),

                // 🔹 Fetch & Update Votes
                value.isFetchingVotes
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: (selectedDate == null ||
                      selectedRegion == null ||
                      episodeInt == null)
                      ? null
                      : () async {
                    await value.fetchVotesByDateAndUpdate(
                      selectedDate!,
                      selectedRegion!,
                      episodeInt!,
                      season!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Updated data for $selectedDate ($selectedRegion)'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Fetch & Update Votes"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
