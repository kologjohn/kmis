// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import '../controller/myprovider.dart';
// import '../controller/routes.dart';
//
// class AccessList extends StatefulWidget {
//   const AccessList({super.key});
//
//   @override
//   State<AccessList> createState() => _AccessListState();
// }
//
// class _AccessListState extends State<AccessList> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<Myprovider>(context, listen: false).fetchAccessComponents());
//   }
//
//   Future<void> _editAccess(
//       BuildContext context, Map<String, dynamic> doc) async {
//     final nameController =
//     TextEditingController(text: doc["name"].toString());
//     final markController =
//     TextEditingController(text: doc["totalmark"].toString());
//
//     await showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: const Color(0xFF2D2F45),
//         title: const Text(
//           "Edit Access Component",
//           style: TextStyle(color: Colors.white),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: "Component Name",
//                 labelStyle: TextStyle(color: Colors.white70),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white38),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blueAccent),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white10,
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: markController,
//               decoration: const InputDecoration(
//                 labelText: "Total Mark",
//                 labelStyle: TextStyle(color: Colors.white70),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white38),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blueAccent),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white10,
//               ),
//               style: const TextStyle(color: Colors.white),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => context.pop(),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(color: Colors.redAccent),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () async {
//               await Provider.of<Myprovider>(context, listen: false)
//                   .updateAccessComponent(doc["id"], {
//                 "componentname": nameController.text.trim(),
//                 "totalmark": markController.text.trim(),
//               });
//               context.pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Updated successfully"),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// responsive grid count
//   int _getCrossAxisCount(double width) {
//     if (width > 1200) return 4;
//     if (width > 900) return 3;
//     if (width > 700) return 2;
//     return 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Consumer<Myprovider>(
//       builder: (BuildContext context, value, Widget? child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Access Components",
//               style: TextStyle(color: Colors.white),
//             ),
//             backgroundColor: const Color(0xFF2D2F45),
//             iconTheme: const IconThemeData(color: Colors.white),
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => context.go(Routes.accesscomponent),
//             ),
//           ),
//           body:  value.isLoadingstafflist
//               ? const Center(child: CircularProgressIndicator())
//               :Consumer<Myprovider>(
//             builder: (context, provider, child) {
//               final components = provider.accessComponents;
//               if (components.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No access components found",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 );
//               }
//
//               return GridView.builder(
//                 padding: const EdgeInsets.all(12),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: _getCrossAxisCount(screenWidth),
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 3.2, //adjust height
//                 ),
//                 itemCount: components.length,
//                 itemBuilder: (context, index) {
//                   final data = components[index];
//                   return Card(
//                     color: const Color(0xFF2D2F45),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 2,
//                     child: Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.blueAccent.withOpacity(0.2),
//                             child: Text(
//                               (data["name"] ?? "?").toString().isNotEmpty
//                                   ? data["name"][0].toUpperCase()
//                                   : "?",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   data["name"] ?? "",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                     color: Colors.white,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "Mark: ${data["totalmark"]}",
//                                   style: const TextStyle(
//                                       color: Colors.white70, fontSize: 13),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.edit,
//                                     color: Colors.blueAccent, size: 20),
//                                 onPressed: () => _editAccess(context, data),
//                                 tooltip: "Edit",
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete,
//                                     color: Colors.redAccent, size: 20),
//                                 onPressed: () async {
//                                   await provider.deleteAccessComponent(data["id"]);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Deleted successfully"),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 },
//                                 tooltip: "Delete",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/myprovider.dart';
import '../controller/routes.dart';

class AccessList extends StatefulWidget {
  const AccessList({super.key});

  @override
  State<AccessList> createState() => _AccessListState();
}

class _AccessListState extends State<AccessList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<Myprovider>(context, listen: false).fetchAccessComponents());
  }

  Future<void> _editAccess(
      BuildContext context, Map<String, dynamic> doc) async {
    final nameController =
    TextEditingController(text: doc["name"].toString());
    final markController =
    TextEditingController(text: doc["totalmark"].toString());

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D2F45),
        title: const Text("Edit Access Component",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: _inputDecoration("Component Name"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: markController,
              decoration: _inputDecoration("Total Mark"),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await Provider.of<Myprovider>(context, listen: false)
                  .updateAccessComponent(doc["id"], {
                "componentname": nameController.text.trim(),
                "totalmark": markController.text.trim(),
              });
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder:
      const OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
      focusedBorder:
      const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      filled: true,
      fillColor: Colors.white10,
    );
  }

  /// responsive grid count
  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Myprovider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Access Components",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D2F45),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(Routes.accesscomponent),
        ),
      ),
      body: provider.isLoadingAccessComponents
          ? const Center(child: CircularProgressIndicator())
          : provider.accessComponents.isEmpty
          ? const Center(
        child: Text(
          "No access components found",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(screenWidth),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3.2,
        ),
        itemCount: provider.accessComponents.length,
        itemBuilder: (context, index) {
          final data = provider.accessComponents[index];
          return Card(
            color: const Color(0xFF2D2F45),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                    Colors.blueAccent.withOpacity(0.2),
                    child: Text(
                      (data["name"] ?? "?").toString().isNotEmpty
                          ? data["name"][0].toUpperCase()
                          : "?",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Mark: ${data["totalmark"]}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.blueAccent, size: 20),
                        onPressed: () =>
                            _editAccess(context, data),
                        tooltip: "Edit",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          await provider.deleteAccessComponent(
                              data["id"]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("Deleted successfully"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        tooltip: "Delete",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
