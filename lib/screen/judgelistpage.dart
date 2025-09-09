
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/myprovider.dart';
import '../controller/routes.dart';

class JudgeListPage extends StatefulWidget {
  const JudgeListPage({super.key});

  @override
  State<JudgeListPage> createState() => _JudgeListPageState();
}

class _JudgeListPageState extends State<JudgeListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _sortColumn = "judge";
  bool _isAscending = true;

  /// Track which rows are expanded
  final Set<int> _expandedRows = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Myprovider>().fetchJudgeslist(reset: true);
    });
    _searchController.addListener(() => setState(() => _currentPage = 0));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _applySearchAndSort(List<Map<String, dynamic>> list) {
    final query = _searchController.text.trim().toLowerCase();

    // Filter
    var filtered = query.isEmpty
        ? List<Map<String, dynamic>>.from(list)
        : list.where((item) {
      final fields = [
        item["judge"] ?? "",
        item["region"] ?? "",
        item["level"] ?? "",
        item["episode"] ?? "",
        item["zone"] ?? "",
        item["season"] ?? "",
      ].map((e) => e.toString().toLowerCase()).toList();
      return fields.any((f) => f.contains(query));
    }).toList();

    // Sort
    filtered.sort((a, b) {
      final aVal = (a[_sortColumn] ?? "").toString();
      final bVal = (b[_sortColumn] ?? "").toString();
      return _isAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });
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
        final judges = value.judgeList;
        final filteredJudges = _applySearchAndSort(judges);

        // Pagination
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = (startIndex + _rowsPerPage).clamp(0, filteredJudges.length);
        final pageItems = filteredJudges.sublist(startIndex, endIndex);

        return Scaffold(
          backgroundColor: const Color(0xFF1B1D2A),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            backgroundColor: const Color(0xFF2D2F45),
            title: const Text(
              "Judges List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: value.isLoadingjudgelist
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: maxWidth,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search Judges",
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white60,
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              /*
              Expanded(
                child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, idx) {
                    final index = idx + startIndex;
                    final item = pageItems[idx];
                    final levels = (item["level"] is List)
                        ? (item["level"] as List).map((l) => l.toString()).toList()
                        : [item["level"].toString()];
                    final components = (item["components"] as List?)
                        ?.map((c) => c["name"].toString())
                        .toList() ??
                        [];

                    final isExpanded = _expandedRows.contains(index);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedRows.remove(index);
                          } else {
                            _expandedRows.add(index);
                          }
                        });
                      },
                      child: Card(
                        color: const Color(0xFF2D2F45),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row summary
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${index + 1}. ${item["judge"] ?? ""}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text("Region: ${item["region"] ?? ""}",
                                      style: const TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 12),
                                  Text("Episode: ${item["episode"] ?? ""}",
                                      style: const TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 12),
                                  Text("Zone: ${item["zone"] ?? ""}",
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),

                              // Expanded section
                              if (isExpanded) ...[
                                const Divider(color: Colors.white38, height: 16),
                                Text("Levels:",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: levels
                                      .map((lvl) => Chip(
                                    label: Text(lvl,
                                        style: const TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.blueGrey.shade700,
                                  ))
                                      .toList(),
                                ),
                                const SizedBox(height: 8),
                                Text("Components:",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                components.isNotEmpty
                                    ? Wrap(
                                  spacing: 8,
                                  children: components
                                      .map((comp) => Chip(
                                    label: Text(comp,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    backgroundColor:
                                    Colors.deepPurple.shade700,
                                  ))
                                      .toList(),
                                )
                                    : const Text("No Components",
                                    style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                      onPressed: () {
                                        context.push(Routes.judgesetup, extra: item);
                                      },
                                    ),
                                    /*
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: const Color(0xFF2D2F45),
                                            title: const Text("Confirm Delete",
                                                style: TextStyle(color: Colors.white)),
                                            content: Text(
                                              "Are you sure you want to delete Judge '${item["judge"]}'?",
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text("Cancel",
                                                    style:
                                                    TextStyle(color: Colors.white70)),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red),
                                                child: const Text("Delete",
                                                    style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await value.deleteJudge(
                                            item["judge"] as String,
                                            item["season"] as String,
                                            item["episode"] as String,
                                            item["zone"] as String,
                                            item["region"] as String,
                                            List<String>.from(item["level"]),
                                          );
                                        }
                                      },
                                    ),
                                    */
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: const Color(0xFF2D2F45),
                                            title: const Text("Confirm Delete",
                                                style: TextStyle(color: Colors.white)),
                                            content: Text(
                                              "Are you sure you want to delete Judge '${item["judge"]}'?",
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                            actions: [
                                              TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: const Text("Cancel",
                                                    style: TextStyle(color: Colors.white70)),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                child: const Text("Delete",
                                                    style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await value.deleteJudge(
                                              item["judge"] as String,
                                              item["season"] as String,
                                              item["episode"] as String,
                                              item["zone"] as String,
                                              item["region"] as String,
                                              List<String>.from(item["level"]),
                                            );


                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Judge '${item["judge"]}' deleted successfully"),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(seconds: 3),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString().replaceAll("Exception: ", "")),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(seconds: 4),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              */
              Expanded(
                child: pageItems.isEmpty
                    ? const Center(
                  child: Text(
                    "No Judges Found",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, idx) {
                    final index = idx + startIndex;
                    final item = pageItems[idx];
                    final levels = (item["level"] is List)
                        ? (item["level"] as List).map((l) => l.toString()).toList()
                        : [item["level"].toString()];
                    final components = (item["components"] as List?)
                        ?.map((c) => c["name"].toString())
                        .toList() ??
                        [];

                    final isExpanded = _expandedRows.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedRows.remove(index);
                          } else {
                            _expandedRows.add(index);
                          }
                        });
                      },
                      child: Card(
                        color: const Color(0xFF2D2F45),
                        margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row summary
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${index + 1}. ${item["judge"] ?? ""}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text("Region: ${item["region"] ?? ""}",
                                      style:
                                      const TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 12),
                                  Text("Episode: ${item["episode"] ?? ""}",
                                      style:
                                      const TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 12),
                                  Text("Zone: ${item["zone"] ?? ""}",
                                      style:
                                      const TextStyle(color: Colors.white70)),
                                ],
                              ),

                              // Expanded section
                              if (isExpanded) ...[
                                const Divider(color: Colors.white38, height: 16),
                                Text("Levels:",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: levels
                                      .map((lvl) => Chip(
                                    label: Text(lvl,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    backgroundColor:
                                    Colors.blueGrey.shade700,
                                  ))
                                      .toList(),
                                ),
                                const SizedBox(height: 8),
                                Text("Components:",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                components.isNotEmpty
                                    ? Wrap(
                                  spacing: 8,
                                  children: components
                                      .map((comp) => Chip(
                                    label: Text(comp,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    backgroundColor: Colors
                                        .deepPurple.shade700,
                                  ))
                                      .toList(),
                                )
                                    : const Text("No Components",
                                    style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blueAccent),
                                      onPressed: () {
                                        context.push(Routes.judgesetup,
                                            extra: item);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final confirm =
                                        await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:
                                            const Color(0xFF2D2F45),
                                            title: const Text("Confirm Delete",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            content: Text(
                                              "Are you sure you want to delete Judge '${item["judge"]}'?",
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text("Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white70)),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red),
                                                child: const Text("Delete",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await value.deleteJudge(
                                              item["judge"] as String,
                                              item["season"] as String,
                                              item["episode"] as String,
                                              item["zone"] as String,
                                              item["region"] as String,
                                              List<String>.from(item["level"]),
                                            );

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Judge '${item["judge"]}' deleted successfully"),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString().replaceAll(
                                                      "Exception: ", "")),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                      seconds: 4),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                    _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                  Text(
                    "Page ${_currentPage + 1} of ${((filteredJudges.length - 1) / _rowsPerPage).floor() + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: endIndex < filteredJudges.length
                        ? () => setState(() => _currentPage++)
                        : null,
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
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
