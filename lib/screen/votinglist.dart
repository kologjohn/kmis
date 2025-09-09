
import 'package:ksoftsms/screen/singlevotepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class VotingList extends StatefulWidget {
  const VotingList({super.key});

  @override
  State<VotingList> createState() => _VotingListState();
}

class _VotingListState extends State<VotingList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final provider = Provider.of<Myprovider>(context, listen: false);
    //  // provider.votesdata();
    // });
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
    double maxWidth = 900;
    double colSpacing = screenWidth > 800
        ? 35
        : screenWidth > 600
        ? 25
        : 10;
    return Consumer<Myprovider>(
      builder: (BuildContext context,  value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back, color: Colors.white),
            //   onPressed: () {
            //     Navigator.pushNamed(context, Routes.judgeselect);
            //   },
            // ),
            title: Text(
              "Voting List ${value.voteslevel} - ${value.votesepisode}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),textAlign: TextAlign.center,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:   IconButton(
                  tooltip: "View Votes",
                  color: Colors.white,
                  icon: const Icon(Icons.add_chart_sharp),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.viewvotes);
                  },
                ),
              ),
            ],
          ),
          body: Consumer<Myprovider>(
            builder: (context, provider, _) {
              final marks = provider.voteList.where((m) {
                final name = (m['studentName'] ?? '').toString().toLowerCase();
                final code = (m['studentId'] ?? '').toString().toLowerCase();
                return name.contains(_searchText)|| code.contains(_searchText);
              }).toList();

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                  padding: const EdgeInsets.all(8.0),
              child: Align(
              alignment: Alignment.topCenter,
              child:
                Column(
                children: [
                  SizedBox(
                    width: maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Search Contestants",
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
                            showCheckboxColumn: false,
                            columnSpacing: colSpacing,
                            columns: const [
                              DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Contestant', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Code', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Level', style: TextStyle(color: Colors.white))),
                              DataColumn(label: Text('Votes', style: TextStyle(color: Colors.white))),
                            ],

                            rows: marks.asMap().entries.map((entry) {
                              final index = entry.key + 1;
                              final mark = entry.value;
                              final imageUrl =mark['photoUrl'] ?? '';
                              final scores = mark['scores'] as Map<String, dynamic>? ?? {};

                              return DataRow(
                                onSelectChanged: (_) {
                                  provider.clearContestantDetails();
                                  provider.clearContestantvoteDetails();
                                  provider.setContestantvoteDetails(voteslevel: mark['level'], votesepisode: mark['episode'], votesregion: mark['region'], pagekeyvote: "votes3310");
                                  provider.setContestantDetails(scoringid:mark['id'],studentId: mark['studentId'] , studentName: mark['studentName'], photoUrl: mark['photoUrl'],pagekey:'nokia3310', scores: scores,);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleVotePage(), // direct widget navigation
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(Text(index.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: imageUrl.isNotEmpty
                                              ? NetworkImage(imageUrl)
                                              : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                                          radius: 20,
                                        ),
                                        SizedBox(width: 10,),
                                        Text(mark['studentName'] ?? ''),
                                      ],)
                                  ),
                                  DataCell(Text(mark['studentId'] ?? '')),
                                  DataCell(Text(mark['level'] ?? '')),
                                  DataCell(Text(mark['votes'] ?? '0')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              ),);
            },
          ),
        );
      },

    );
  }
}
