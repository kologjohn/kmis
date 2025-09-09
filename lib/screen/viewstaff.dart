import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:ksoftsms/controller/dbmodels/staffmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  int? _sortColumnIndex;
  bool _sortAscending = true;

  //pagination
  int _rowsPerPage = 15;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      final value = context.read<Myprovider>();
      // value.getfetchRegions();
      // value.getfetchLevels();
      // value.getfetchEpisodes();
      // value.getfetchZones();
      // value.getfetchWeeks();
       value.loadata();
    });
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
        _currentPage = 0;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double maxWidth = 1100;
    double colSpacing = screenWidth > 800
        ? 10 : screenWidth > 600   ? 5 : 3;

    return Consumer<Myprovider>(
      builder: (context, value, child) {
        List<Staff> filtered = value.staffList.where((m) {
          final name = (m.name ?? '').toLowerCase();
          final phone = (m.phone ?? '').toLowerCase();
          final region = (m.region ?? '').toLowerCase();

          return name.contains(_searchText) ||
              phone.contains(_searchText) ||
              region.contains(_searchText);
        }).toList();
        if (_sortColumnIndex != null) {
          if (_sortColumnIndex == 1) {
            filtered.sort((a, b) => _sortAscending
                ? (a.name ?? '').compareTo(b.name ?? '')
                : (b.name ?? '').compareTo(a.name ?? ''));
          } else if (_sortColumnIndex == 2) {
            filtered.sort((a, b) => _sortAscending
                ? (a.phone ?? '').compareTo(b.phone ?? '')
                : (b.phone ?? '').compareTo(a.phone ?? ''));
          } else if (_sortColumnIndex == 3) {
            filtered.sort((a, b) => _sortAscending
                ? (a.region ?? '').compareTo(b.region ?? '')
                : (b.region ?? '').compareTo(a.region ?? ''));
          }
          else if (_sortColumnIndex == 4) {
            filtered.sort((a, b) => _sortAscending
                ? (a.accessLevel ?? '').compareTo(b.accessLevel ?? '')
                : (b.accessLevel ?? '').compareTo(a.accessLevel ?? ''));
          }
        }
        int totalRows = filtered.length;
        int totalPages = (totalRows / _rowsPerPage).ceil();
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = (startIndex + _rowsPerPage) > totalRows
            ? totalRows
            : (startIndex + _rowsPerPage);

        List<Staff> paginated = filtered.sublist(
          startIndex < totalRows ? startIndex : 0,
          endIndex,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF1B1D2A),
          appBar: AppBar(
            leading: InkWell(
              child: const Icon(Icons.home, color: Colors.white),
              onTap: () async {
                context.go( Routes.dashboard);
              },
            ),
            backgroundColor: const Color(0xFF2D2F45),
            title: Text(
              "Staff List ${value.userName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: value.isLoadingstafflist
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: maxWidth,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search Staff...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // scrollable table
                  Container(
                    width: maxWidth,
                    // height: MediaQuery.of(context).size.height * 0.7,
                    color: const Color(0xFF2D2F45),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columnSpacing: colSpacing,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            columns: [
                              const DataColumn(
                                label: Text(
                                  '#',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: const Text(
                                  'Staff Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _onSort(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text(
                                  'Staff Phone',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _onSort(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text(
                                  'Staff Region',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _onSort(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text(
                                  'Access',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _onSort(columnIndex, ascending),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Action',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            rows: List.generate(paginated.length, (index) {
                              final item = paginated[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      '${startIndex + index + 1}',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.name ?? '',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.phone ?? '',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.region ?? '',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.accessLevel ?? '',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blueAccent),
                                          tooltip: 'Edit Staff',
                                          onPressed: () {
                                            context.go(
                                              Routes.regstaff,
                                              extra: item,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          tooltip: 'You are about to delete staff ${item.name}',
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                backgroundColor: const Color(0xFF2D2F45), // matches dark theme
                                                title: Text(
                                                  'Confirm Deletion of ${item.name}',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete staff: ${item.name.toUpperCase()}?',
                                                  style: const TextStyle(color: Colors.white70),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                    onPressed: () => Navigator.of(ctx).pop(false),
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                    onPressed: () => Navigator.of(ctx).pop(true),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              await value.deleteData(
                                                "staff",
                                                item.id ?? '',
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Staff ${item.name} deleted successfully"),
                                                  backgroundColor: Colors.redAccent,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // pagination controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 0
                            ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                            : null,
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.white),
                      ),
                      Text(
                        "Page ${_currentPage + 1} of $totalPages",
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: _currentPage < totalPages - 1
                            ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                            : null,
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
