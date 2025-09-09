
 import 'package:ksoftsms/screen/registerzone.dart';
 import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
 import 'package:provider/provider.dart';
 import 'package:ksoftsms/controller/myprovider.dart';

import '../controller/routes.dart';

 class ZoneListPage extends StatefulWidget {
   const ZoneListPage({super.key});

   @override
   State<ZoneListPage> createState() => _ZoneListPageState();
 }

 class _ZoneListPageState extends State<ZoneListPage> {
   @override
   void initState() {
     super.initState();
     Future.microtask(() {
       context.read<Myprovider>().getfetchZones();
     });
   }

   @override
   Widget build(BuildContext context) {
     const double maxWidth = 900;

     return Consumer<Myprovider>(
       builder: (context, value, child) {
         return Scaffold(
           appBar: AppBar(
             title: const Text('All Zones', style: TextStyle(color: Colors.white)),
             backgroundColor: const Color(0xFF2D2F45),
             leading: IconButton(
               icon: const Icon(Icons.arrow_back, color: Colors.white),
               onPressed: () => context.go(Routes.dashboard),
             ),
           ),
           backgroundColor: const Color(0xFF1F1F2C),
           body: Center(
             child: ConstrainedBox(
               constraints: const BoxConstraints(maxWidth: maxWidth),
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: value.zones.isEmpty
                     ? const Center(
                   child: Text(
                     "No zones found",
                     style: TextStyle(color: Colors.white70, fontSize: 16),
                   ),
                 )
                     : ListView.separated(
                   itemCount: value.zones.length,
                   separatorBuilder: (_, __) =>
                   const Divider(color: Colors.grey),
                   itemBuilder: (context, index) {
                     final zone = value.zones[index];
                     final zoneName =
                     zone.zonename.isNotEmpty ? zone.zonename : '';

                     return Container(
                       decoration: BoxDecoration(
                         color: const Color(0xFF2D2F45),
                         borderRadius: BorderRadius.circular(10),
                       ),
                       padding: const EdgeInsets.symmetric(
                           horizontal: 16.0, vertical: 12.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           // Zone name
                           Expanded(
                             child: Text(
                               zoneName,
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500,
                               ),
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),

                           // Action buttons
                           Row(
                             children: [
                               IconButton(
                                 icon: const Icon(Icons.edit,
                                     color: Colors.blueAccent),
                                 tooltip: 'Edit $zoneName',
                                 onPressed: () {
                                   context.go(Routes.registerzone,extra: {
                                     "zoneData": zone.zonename
                                   });
                                   // Navigator.push(
                                   //   context,
                                   //   MaterialPageRoute(
                                   //     builder: (_) =>
                                   //         RegisterZone(zoneData: zone),
                                   //   ),
                                   // );
                                 },
                               ),
                               IconButton(
                                 icon: const Icon(Icons.delete,
                                     color: Colors.redAccent),
                                 tooltip: 'Delete $zoneName',
                                 onPressed: () async {
                                   final confirm = await showDialog<bool>(
                                     context: context,
                                     builder: (context) => AlertDialog(
                                       title: Text("Delete $zoneName?"),
                                       content: const Text(
                                           "This action cannot be undone."),
                                       actions: [
                                         TextButton(
                                           onPressed: () =>
                                               Navigator.pop(context, false),
                                           child: const Text("Cancel"),
                                         ),
                                         ElevatedButton(
                                           onPressed: () =>
                                               Navigator.pop(context, true),
                                           style: ElevatedButton.styleFrom(
                                             backgroundColor: Colors.red,
                                           ),
                                           child: const Text("Delete"),
                                         ),
                                       ],
                                     ),
                                   );
                                   if (confirm == true) {
                                     await value.deleteData(
                                       "zone",
                                       zone.id,
                                     );
                                   }
                                 },
                               ),
                             ],
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ),
             ),
           ),
         );
       },
     );
   }
 }

