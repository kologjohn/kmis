import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import '../controller/routes.dart';

class Viewdepartment extends StatefulWidget {
  const Viewdepartment({super.key});

  @override
  State<Viewdepartment> createState() => _ViewdepartmentState();
}

class _ViewdepartmentState extends State<Viewdepartment> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<Myprovider>(context, listen: false).fetchdepart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (BuildContext context, Myprovider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Departments', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
          ),
          backgroundColor: const Color(0xFF1F1F2C),
          body: provider.loaddepart
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : provider.departments.isEmpty
              ? const Center(
            child: Text(
              "No departments found",
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.separated(
            itemCount: provider.departments.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final depart = provider.departments[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  depart.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        context.go(Routes.depart, extra: depart);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete ${depart.name}',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: Text(
                                "Are you sure you want to delete '${depart.name}'?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider.deleteData("department", depart.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Department deleted successfully",
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
