
import 'package:ksoftsms/controller/routes.dart';
import 'package:ksoftsms/screen/registerstudents.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/dbmodels/contestantsmodel.dart';
import '../controller/myprovider.dart';

class ContestantsListScreen extends StatefulWidget {
  const ContestantsListScreen({super.key});

  @override
  State<ContestantsListScreen> createState() => _ContestantsListScreenState();
}

class _ContestantsListScreenState extends State<ContestantsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _sortColumn = "name";
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().contestantdata();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ContestantModel> _applySearchAndSort(List<ContestantModel> list) {
    //search
    final query = _searchController.text.trim().toLowerCase();
    var filtered = query.isEmpty
        ? List<ContestantModel>.from(list)
        : list.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.contestantId.toLowerCase().contains(query) ||
          c.region.toLowerCase().contains(query) ||
          c.level.toLowerCase().contains(query);
    }).toList();

    // Apply sort
    int Function(ContestantModel a, ContestantModel b) compare;
    switch (_sortColumn) {
      case "contestantId":
        compare = (a, b) =>
            a.contestantId.compareTo(b.contestantId);
        break;
      case "level":
        compare = (a, b) => a.level.compareTo(b.level);
        break;
      case "region":
        compare = (a, b) => a.region.compareTo(b.region);
        break;
      default:
        compare = (a, b) => a.name.compareTo(b.name);
    }

    filtered.sort((a, b) =>
    _isAscending ? compare(a, b) : compare(b, a));

    return filtered;
  }

  void _toggleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _isAscending = !_isAscending;
      } else {
        _sortColumn = column;
        _isAscending = true;
      }
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 1100;
    double colSpacing = screenWidth > 800 ? 10 : screenWidth > 600 ? 5 : 3;

    return Consumer<Myprovider>(
      builder: (context, value, child) {
        final contestants = value.contestant;
        final filteredContestants = _applySearchAndSort(contestants);

        // Pagination
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = (startIndex + _rowsPerPage).clamp(
          0,
          filteredContestants.length,
        );
        final pageItems = filteredContestants.sublist(
          startIndex,
          endIndex,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF1B1D2A),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            backgroundColor: const Color(0xFF2D2F45),
            title: const Text(
              "Contestants List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: value.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: maxWidth,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {
                      _currentPage = 0;
                    }),
                    decoration: InputDecoration(
                      labelText: "Search Contestants",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _currentPage = 0);
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white60,
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // DataTable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: maxWidth),
                    child: DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: colSpacing,
                      sortColumnIndex: {
                        "name": 1,
                        "contestantId": 2,
                        "level": 4,
                        "region": 5,
                      }[_sortColumn],
                      sortAscending: _isAscending,
                      columns: [
                        const DataColumn(
                          label: Text('No.',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DataColumn(
                          label: const Text('Contestant Name',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("name"),
                        ),
                        DataColumn(
                          label: const Text('Vote Name',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("vote name"),
                        ),
                        DataColumn(
                          label: const Text('Contestant Code',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("contestantId"),
                        ),
                        const DataColumn(
                          label: Text('Photo',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DataColumn(
                          label: const Text('Level',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("level"),
                        ),
                        DataColumn(
                          label: const Text('Region',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("region"),
                        ),
                        const DataColumn(
                          label: Text('Action',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      rows: pageItems.asMap().entries.map((entry) {
                        final index = entry.key + startIndex;
                        final ContestantModel item = entry.value;

                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(Text(item.name,
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(Text(item.votename.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(Text(item.contestantId,
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(
                              item.photoUrl.isNotEmpty
                                  ? CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Colors.grey.shade200,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: item.photoUrl,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                    placeholder: (context, url) =>
                                    const Icon(Icons.image,
                                        color: Colors.grey),
                                    errorWidget:
                                        (context, url, error) =>
                                    const Icon(
                                        Icons.broken_image,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                                  : const Icon(Icons.image,
                                  color: Colors.grey),
                            ),
                            DataCell(Text(item.level,
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(Text(item.region,
                                style: const TextStyle(
                                    color: Colors.white))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      context.push(
                                        Routes.registercontestant,
                                        extra: item,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'Delete ${item.name}',
                                    onPressed: () async {
                                      final confirm =
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: Text(
                                                  "Delete ${item.name}?"),
                                              content: const Text(
                                                  "This action cannot be undone."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child:
                                                  const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                    Colors.red,
                                                  ),
                                                  child:
                                                  const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (confirm == true) {
                                        await value.deleteData(
                                            "contestant", item.id);
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

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white),
                  ),
                  Text(
                    "Page ${_currentPage + 1} of ${( (filteredContestants.length - 1) / _rowsPerPage ).floor() + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: endIndex < filteredContestants.length
                        ? () => setState(() => _currentPage++)
                        : null,
                    icon: const Icon(Icons.chevron_right,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
