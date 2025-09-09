import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';

class JudgeScoreTablePage extends StatefulWidget {
  final Map<String, dynamic> judgeInfo;
  const JudgeScoreTablePage({required this.judgeInfo, super.key});

  @override
  State<JudgeScoreTablePage> createState() => _JudgeScoreTablePageState();
}

class _JudgeScoreTablePageState extends State<JudgeScoreTablePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchJudgeScores(widget.judgeInfo);
    });
  }
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Myprovider>();
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 900; // same width for search & table
    double colSpacing = screenWidth > 800
        ? 35
        : screenWidth > 600
        ? 25
        : 10;
    return Scaffold(
      appBar: AppBar(
        title: Text('Judge Score Table for ${widget.judgeInfo['judge']}',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF2D2F45),
      ),
      body: provider.isLoadingScores
          ? const Center(child: CircularProgressIndicator())
          : provider.judgeScoreRows.isEmpty
          ? const Center(child: Text('No scores found'))
          :  Padding(
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
            if (provider.selectedDocIds.isNotEmpty)
          Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.delete, color: Colors.white),
        label: Text('Delete Selected (${provider.selectedDocIds.length})',style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Confirm Bulk Delete', style: TextStyle(color: Colors.black)),
              content: Text('Delete ${provider.selectedDocIds.length} selected scores?', style: TextStyle(color: Colors.black)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
             await provider.deleteSelectedScores(widget.judgeInfo['judge'], widget.judgeInfo['judge']);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deleted ${provider.selectedDocIds.length} scores'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
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
          columns: [
            const DataColumn(label: Text('Name')),
            ...provider.criteriaOrder.map(
                  (c) => DataColumn(label: Text(c)),
            ),
            const DataColumn(label: Text('Total')),
            const DataColumn(label: Text('Delete')),
          ],
          rows: provider.judgeScoreRows.map((row) {
            final isSelected = provider.selectedDocIds.contains(row['docId']);

            return DataRow(
              selected: isSelected,
              onSelectChanged: (selected) {
                provider.toggleSelection(row['docId']!, selected ?? false);
              },
              cells: [
                DataCell(Text(row['name'] ?? '')),
                ...provider.criteriaOrder.map((c) => DataCell(Text(row[c] ?? '0'))),
                DataCell(Text(row['total'] ?? '0')),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirm Delete', style: TextStyle(color: Colors.black)),
                          content: Text('Delete score for ${row['name']}?', style: TextStyle(color: Colors.black)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await provider.deleteJudgeScoreFromDoc(docId: row['docId']!, judgeId: widget.judgeInfo['judge']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${row['name']} score deleted'), backgroundColor: Colors.green),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),),),),
      ],
    ),),)
    );
  }
}
