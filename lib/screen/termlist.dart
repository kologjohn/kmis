import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/myprovider.dart';
import '../controller/routes.dart';
class Viewterms extends StatefulWidget {
  const Viewterms({super.key});

  @override
  State<Viewterms> createState() => _ViewtermsState();
}

class _ViewtermsState extends State<Viewterms> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<Myprovider>(context, listen: false).fetchterms(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (BuildContext context, Myprovider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Terms', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
          ),
          backgroundColor: const Color(0xFF1F1F2C),
          body: provider.loadterms
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : provider.terms.isEmpty
              ? const Center(
            child: Text(
              "No terms found",
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.separated(
            itemCount: provider.terms.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final term = provider.terms[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  term.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        context.go(Routes.term, extra: term);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete ${term.name}',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: Text(
                                "Are you sure you want to delete '${term.name}'?"),
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
                          await provider.deleteData("terms", term.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Term deleted successfully",
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


