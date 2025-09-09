import 'dart:convert';

import 'package:ksoftsms/controller/myprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'dbmodels/staffmodel.dart';

class StatsProvider extends Myprovider {
  final db = FirebaseFirestore.instance;
 int totaltempaltes=0;
 int totalscored=0;
  List<Map<String, dynamic>> revenues = [];
  List<Map<String, dynamic>> filteredRevenues = [];
  String my_selected_region = "";
  String totalvotes="0";
  int totalcontestants = 0;
  int totaljugdes = 0;
  bool adminshow=false;
  bool superadminshow=false;
  bool judgeshow=false;
  StatsProvider(){
    gettotalvotes();
    showaccess();
    countContestantsWithTotal();
  }
  // Future<void> getVotes() async {
  //   try {
  //     final url = Uri.parse(
  //       'http://localhost:5000/bookworm-458ab/us-central1/speakuppPollsNotify',
  //     );
  //
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({"regionId": "175"}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final results = data['results'] as List<dynamic>;
  //       for (var choice in results) {
  //         final results2 = choice['poll_choices'] as List<dynamic>;
  //         for(var r in results2){
  //           String name= r['choice_text'];
  //           String short_code= r['short_code_text'];
  //           String photoUrl= r['image'];
  //           // print('$name - $short_code');
  //           if(short_code.isNotEmpty)
  //           {
  //             try{
  //               print('Updating $short_code with name $name');
  //               await db.collection("contestant").doc(short_code).update({"id_code":short_code, "name_stage":name,"photoUrl":photoUrl,"status":"active"});
  //
  //             }catch(e){
  //               print('Error updating $short_code: $e');
  //             }
  //
  //           }
  //         }
  //
  //         // print(results2);
  //
  //       }
  //
  //
  //       // assuming poll_choices is a list inside the response
  //       // if (data[0]['poll_choices'] != null && data[0]['poll_choices'].isNotEmpty) {
  //       //   print(data[0]['poll_choices'][0]);
  //       // } else {
  //       //   print('No poll choices available');
  //       // }
  //     } else {
  //       print('Error: ${response.statusCode} → ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //   }
  // }



  //List<Map<String, dynamic>> staffList = [];
  List<Staff> staffList = [];
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  showaccess()async{
    await getdata();
    if(accesslevel=="Super Admin"){
      adminshow=true;
      superadminshow=true;
      judgeshow=true;
    }
    else if(accesslevel=="Admin"){
      adminshow=true;
      superadminshow=true;
      judgeshow=true;
    }


  }
  setSelectedRegion(String regn) async{
    await getdata();
    my_selected_region = regn;
    notifyListeners();
  }
  Future<void> studentdata() async {
    try {
      isLoading = true;
      notifyListeners();
      QuerySnapshot snapshot;
      if (accesslevel == "Admin") {
        snapshot = await db.collection('contestant').where('region',isEqualTo: regionName).orderBy('level').limit(50).get();
      }
      else if (my_selected_region.isNotEmpty) {

        snapshot = await db.collection('contestant').where('region', isEqualTo: my_selected_region).get(const GetOptions(source: Source.cache));
      }
      else {
        // Normal user with no region filter
        snapshot = await db.collection('contestant').get();
      }

      String safeToString(dynamic value) {
        if (value == null) return '';
        if (value is List) return value.join(' ');
        return value.toString();
      }

      final data = snapshot.docs.map((doc) {
        final contestant = doc.data() as Map<String, dynamic>;
        return {
          'id': safeToString(contestant['id']),
          'name': safeToString(contestant['name']),
          'code': safeToString(contestant['contestantId']),
          //'photoUrl': safeToString(contestant['photoUrl'] ?? "No Photo"),
          'sex': safeToString(contestant['sex']),
          'region': safeToString(contestant['region']),
          'level': safeToString(contestant['level']),
          'episode': safeToString(contestant['episode']),
          'season': safeToString(contestant['season']),
          'school': safeToString(contestant['school']),
          'guardianContact': safeToString(contestant['guardianContact']),
          'zone': safeToString(contestant['zone']),
        };
      }).toList();

      revenues = data;
      filteredRevenues = data;
    } catch (e) {
      print("Error fetching student data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void filterRevenues(String query) {
    if (query.isEmpty) {
      filteredRevenues = revenues;
    } else {
      final lowerQuery = query.toLowerCase();
      filteredRevenues = revenues.where((item) {
        return item['name'].toString().toLowerCase().contains(lowerQuery) ||
            item['code'].toString().toLowerCase().contains(lowerQuery) ||
            item['region'].toString().toLowerCase().contains(lowerQuery) ||
            item['level'].toString().toLowerCase().contains(lowerQuery) ||
            item['school'].toString().toLowerCase().contains(lowerQuery) ||
            item['zone'].toString().toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
  Future<Map<String, int>> getLevelDistribution() async {
    await getdata();
    QuerySnapshot querySnapshot;
    if(accesslevel=="Super Admin"){
      querySnapshot = await FirebaseFirestore.instance.collection('regionLevelCounts').get();
    }else if(accesslevel=="Admin"){
      querySnapshot = await FirebaseFirestore.instance.collection('regionLevelCounts').where('region',isEqualTo: regionName).get();
    }
    else
      {
        querySnapshot = await FirebaseFirestore.instance.collection('regionLevelCounts').where('region',isEqualTo: "").get();

      }
 //   final snapshot = await FirebaseFirestore.instance.collection('regionLevelCounts').get();
    final Map<String, int> levelTotals = {};

    for (final doc in querySnapshot.docs) {
      final levels = Map<String, dynamic>.from(doc['levels'] ?? {});
      levels.forEach((level, count) {
        levelTotals[level] = (levelTotals[level] ?? 0) + (count as int);
      });
    }
    return levelTotals;
  }
  gettotalvotes()async{
   await getdata();
   // print(accesslevel);
    try {
      QuerySnapshot querySnapshot;
      if(accesslevel=="Super Admin") {
        querySnapshot = await db.collection('votesSummary').get();
      }
      else if(accesslevel=="Admin")
      {
        querySnapshot = await db.collection('votesSummary').where('region',isEqualTo: regionName).get();
      }
      else
        {
          querySnapshot = await db.collection('votesSummary').where('region',isEqualTo: "").get();
        }

      int tt = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        String totalval = doc['total'].toString();
        tt += int.parse(totalval);
      }
      if (tt >= 1000) {
        double getk = (tt / 1000).toDouble();
        totalvotes = "${getk.toStringAsFixed(1)}k";
      }
      else {
        totalvotes = tt.toString();
      }
      //totalvotes=tt.toString();

    }catch(e){
      print(e);
    }
  }

}
