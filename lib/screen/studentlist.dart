import 'package:ksoftsms/controller/routes.dart';
import 'package:ksoftsms/screen/registerstudents.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


import '../controller/dbmodels/contestantsmodel.dart';
import '../controller/myprovider.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _sortColumn = "name";
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchstudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StudentModel> _applySearchAndSort(List<StudentModel> list) {
    final query = _searchController.text.trim().toLowerCase();
    var filtered = query.isEmpty
        ? List<StudentModel>.from(list)
        : list.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.studentid.toLowerCase().contains(query) ||
          s.region.toLowerCase().contains(query) ||
          s.level.toLowerCase().contains(query) ||
          s.phone.toLowerCase().contains(query);
    }).toList();

    int Function(StudentModel a, StudentModel b) compare;
    switch (_sortColumn) {
      case "studentid":
        compare = (a, b) => a.studentid.compareTo(b.studentid);
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

    filtered.sort((a, b) => _isAscending ? compare(a, b) : compare(b, a));
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
        final students = value.studentlist;
        final filteredStudents = _applySearchAndSort(students);

        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = (startIndex + _rowsPerPage).clamp(
          0,
          filteredStudents.length,
        );
        final pageItems = filteredStudents.sublist(startIndex, endIndex);

        return Scaffold(
          backgroundColor: const Color(0xFF1B1D2A),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            backgroundColor: const Color(0xFF2D2F45),
            title: const Text(
              "Students List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // 🔹 Floating Action Button to add a new student
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              context.push(Routes.registerstudent); // no extra = new registration
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),

          body: value.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
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
                      labelText: "Search Students",
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
                        "studentid": 2,
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
                          label: const Text('Student Name',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("name"),
                        ),
                        DataColumn(
                          label: const Text('Student ID',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("studentid"),
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
                        DataColumn(
                          label: const Text('Status',
                              style: TextStyle(color: Colors.white)),
                          onSort: (_, __) => _toggleSort("status"),
                        ),
                        const DataColumn(
                          label: Text('Action',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      rows: pageItems.asMap().entries.map((entry) {
                        final index = entry.key + startIndex;
                        final StudentModel item = entry.value;

                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}',
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(Text(item.name,
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(Text(item.studentid,
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(
                              item.photourl.isNotEmpty
                                  ? CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Colors.grey.shade200,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: item.photourl,
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
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(Text(item.region,
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(Text(item.status,
                                style:
                                const TextStyle(color: Colors.white))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      context.push(
                                        Routes.registerstudent,
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
                                            "students", item.id);
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
                    "Page ${_currentPage + 1} of ${((filteredStudents.length - 1) / _rowsPerPage).floor() + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: endIndex < filteredStudents.length
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
