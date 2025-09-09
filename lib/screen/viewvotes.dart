
import 'package:ksoftsms/screen/singlevotepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/routes.dart';
import '../controller/myprovider.dart';

class VotesEditPage extends StatefulWidget {
  const VotesEditPage({super.key});

  @override
  State<VotesEditPage> createState() => _VotesEditPageState();
}

class _VotesEditPageState extends State<VotesEditPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Myprovider>(context, listen: false);
      provider.clearContestantDetails();
      provider.votesdata();
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
    final provider = Provider.of<Myprovider>(context, listen: false);
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900; // same width for search & table
    double colSpacing = screenWidth > 800
        ? 35
        : screenWidth > 600
        ? 25
        : 10;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, Routes.scores);
          },
        ),
        backgroundColor: const Color(0xFF2D2F45),
        title:  Text("RECORDED VOTES FOR ${provider.voteslevel}${" "}(${provider.votesepisode})",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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

          return  Padding(
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
                      minWidth: maxWidth,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columnSpacing:colSpacing,
                        columns: const [
                          DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Code', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Votes', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Photo', style: TextStyle(color: Colors.white))),
                        ],
                        rows: marks.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final mark = entry.value;
                          final imageUrl = mark['photoUrl'] ?? '';
                          final scores = mark['scores'] as Map<String, dynamic>? ?? {};

                          return DataRow(

                            onSelectChanged: (_) async{
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
                              DataCell(Text(mark['studentName'] ?? '')),
                              DataCell(Text(mark['studentId'] ?? '')),
                              DataCell(Text(mark['votes'] ?? '')),
                              DataCell(
                                CircleAvatar(
                                  backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage('assets/images/bookwormlogo.jpg') as ImageProvider,
                                  radius: 25,
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
          ),
          ),);
        },
      ),
    );
  }
}
