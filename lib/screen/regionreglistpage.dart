import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';


class RegionListPage extends StatefulWidget {
  const RegionListPage({super.key});

  @override
  State<RegionListPage> createState() => _RegionListPageState();
}

class _RegionListPageState extends State<RegionListPage> {
  int? sortColumnIndex;
  bool isAscending = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<Myprovider>(context, listen: false);
      await provider.getfetchRegions();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900;
    double colSpacing =
    screenWidth > 800 ? 35 : screenWidth > 600 ? 25 : 10;

    return ProgressHUD(
      child: Consumer<Myprovider>(
        builder: (context, provider, _) {
          final regions = provider.regionList;
          final filteredRegions = regions.where((region) {
            final query = searchQuery.toLowerCase();
            return region.regionname.toLowerCase().contains(query);
          }).toList();

          return Scaffold(
            backgroundColor: const Color(0xFF2D2F45),
            appBar: AppBar(
              backgroundColor: const Color(0xFF2D2F45),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Regions List",
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go(Routes.dashboard),
              ),
            ),
            body: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: maxWidth,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                            "Search region",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          onChanged: (value) =>
                              setState(() => searchQuery = value),
                        ),
                      ),
                    ),

                    /// Table
                    Container(
                      width: maxWidth,
                      color: const Color(0xFF2D2F45),
                      child: filteredRegions.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "No matching results",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                          BoxConstraints(minWidth: maxWidth),
                          child: DataTable(
                            columnSpacing: colSpacing,
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            headingRowColor:
                            MaterialStateProperty.resolveWith(
                                    (states) =>
                                const Color(0xFF2D2F45)),
                            columns: [
                              DataColumn(
                                label: const Text("Region",
                                    style:
                                    TextStyle(color: Colors.white)),
                                onSort: (index, ascending) {
                                  setState(() {
                                    sortColumnIndex = index;
                                    isAscending = ascending;
                                    filteredRegions.sort((a, b) =>
                                    ascending
                                        ? a.regionname
                                        .compareTo(b.regionname)
                                        : b.regionname
                                        .compareTo(a.regionname));
                                  });
                                },
                              ),
                              const DataColumn(
                                label: Text("Actions",
                                    style:
                                    TextStyle(color: Colors.white)),
                              ),
                            ],
                            rows: filteredRegions.map((region) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      region.regionname,
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        /// EDIT BUTTON
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.amber),
                                          onPressed: () {
                                            context.go(
                                              Routes.regionreg,
                                              extra: {
                                                "region": region,
                                                "isEdit": true,
                                              },
                                            );
                                          },
                                        ),

                                        /// DELETE BUTTON
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            print(
                                                "DELETE CLICKED → Region: ${region.regionname} (id: ${region.id})");

                                            final confirm =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                    const Color(
                                                        0xFF2D2F45),
                                                    title: const Text(
                                                      "Delete Region",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to delete this region?",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white70),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                ctx, false),
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                ctx, true),
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );

                                            if (confirm == true) {
                                              try {
                                                await provider
                                                    .deleteRegion(
                                                    region.id);
                                                if (mounted) {
                                                  print(
                                                      "✅ Deleted Region successfully: ${region.regionname}");
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Region deleted successfully"),
                                                      backgroundColor:
                                                      Colors.green,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  print(
                                                      "❌ Failed to delete Region: $e");
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Failed to delete region: $e"),
                                                      backgroundColor:
                                                      Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
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
