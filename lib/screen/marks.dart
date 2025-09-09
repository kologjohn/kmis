
import 'package:ksoftsms/screen/singlevotepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class EvictionScreen extends StatefulWidget {
  const EvictionScreen({super.key});

  @override
  State<EvictionScreen> createState() => _EvictionScreenState();
}

class _EvictionScreenState extends State<EvictionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.evictionList();
    });
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900; // same width for search & table
    double colSpacing = screenWidth > 800
        ? 56
        : screenWidth > 600
        ? 40
        : 10; // dynamic column spacing
    return Consumer<Myprovider>(
      builder: (BuildContext context,  value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go(Routes.dashboard);
              },
            ),
            title: Text(
              "Eviction Sheet for ${value.regionName} Region  ${value.zoneName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),textAlign: TextAlign.center,
            ),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child:   IconButton(
              //     tooltip: "View deleted results",
              //     color: Colors.white,
              //     icon: const Icon(Icons.add_chart_sharp),
              //     onPressed: () {
              //       Navigator.pushNamed(context, Routes.viewvotes);
              //     },
              //   ),
              // ),
            ],
          ),
          body: Consumer<Myprovider>(
            builder: (context, provider, _) {
              final marks = provider.pendingeviction.where((m) {
                final name = (m['studentName'] ?? '').toString().toLowerCase();
                final code = (m['studentId'] ?? '').toString().toLowerCase();
                return name.contains(_searchText) || code.contains(_searchText);
              }).toList();

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              Future<void> _confirmEvict(
                  BuildContext context,
                  Map<String, dynamic> mark,
                  ) async {
                final provider = context.read<Myprovider>();

                // showDialog returns only when Navigator.pop is called inside
                final didEvict = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // don’t let them tap outside
                  builder: (dialogContext) {
                    bool isLoading = false;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Confirm Eviction',style: TextStyle(color: Colors.black),),
                          content: isLoading
                              ? SizedBox(
                            height: 80,
                            child: Center(child: CircularProgressIndicator()),
                          )
                              : Text(
                            'Evict ${mark['studentName']} (ID: ${mark['studentId']}) (${mark['level']})?',style: TextStyle(color: Colors.black)
                          ),
                          actions: [
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancel'),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                setState(() => isLoading = true);
                                try {
                                  //await provider.activateAllContestants();
                                 await provider.evictContestant(contestantId: mark['studentId'],
                                  );
                                  Navigator.of(dialogContext).pop(true);
                                } catch (e) {
                                  setState(() => isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error evicting: $e'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: isLoading
                                  ? const SizedBox(
                                width: 40,
                                height: 20,
                                child: const Text("wait..."),
                              )
                                  : const Text('Evict',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (didEvict == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${mark['studentName']} evicted"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }


              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topCenter,
               child:  Column(
                children: [
                  SizedBox(
                    width: maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Search Contestants name or code",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white60,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: maxWidth,
                    height: MediaQuery.of(context).size.height * 0.7,
                    color: const Color(0xFF2D2F45),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth:maxWidth,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: colSpacing,
                            headingRowColor: WidgetStateProperty.all(
                                Colors.transparent),
                            columns: const [
                              DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Contestant', style: TextStyle(color: Colors.white60))),
                              DataColumn(label: Text('Code', style: TextStyle(color: Colors.white60))),
                              DataColumn(label: Text('Action', style: TextStyle(color: Colors.white60))),
                            ],

                            rows: marks.asMap().entries.map((entry) {
                              final index = entry.key + 1;
                              final mark = entry.value;
                              final imageUrl =mark['photoUrl'] ?? '';
                              final isEvicted = mark['status'] == 'evicted';


                             return DataRow(

                                cells: [
                                  DataCell(Text(index.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: imageUrl.isNotEmpty
                                              ? NetworkImage(imageUrl)
                                              : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          mark['studentName'] ?? '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      mark['studentId'] ?? '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  // Evict action cell
                              DataCell(
                              Center(
                              child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                              color: isEvicted
                              ? Colors.red.withOpacity(0.2)
                                  : Colors.white10,
                              shape: BoxShape.circle,
                              ),
                              child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                              Icons.person_remove_alt_1,
                              color: isEvicted ? Colors.red : Colors.white,
                              size: 20,
                              ),
                              tooltip: isEvicted
                              ? 'Already evicted'
                                  : 'Evict contestant',
                              onPressed: isEvicted
                              ? null
                                  : () => _confirmEvict(context, mark),
                              ),
                              ),
                              ),
                              ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )));
            },
          ),
        );
      },

    );
  }
}
