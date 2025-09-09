import 'dart:convert';
import 'dart:io';
import 'package:ksoftsms/controller/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../components/criterialprinterpdf.dart';
import '../components/evictionprintersheet.dart';
import '../components/scoresheet.dart';
import '../components/judgetotalscoresheet.dart';
import '../components/scoringmarkmodel.dart';
import '../components/voteplusjudgescoresheet.dart';
import '../components/weeklysheetprinter.dart';
import 'dbmodels/componentmodel.dart';
import 'dbmodels/contestantsmodel.dart';
import 'dbmodels/episodeModel.dart';
import 'dbmodels/judgemodel.dart';
import 'dbmodels/levelmodel.dart';
import 'dbmodels/regionmodel.dart';
import 'dbmodels/seasonModel.dart';
import 'dbmodels/staffmodel.dart';
import 'dbmodels/weekmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dbmodels/zonemodels.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Myprovider extends ChangeNotifier {
  int evictedCount= 0;
  int evictnumber= 0;
  int totalrecords = 0;
  double totalamount = 0;
  String judgesetup ="judgeSetupf";
  int criteriaTotal = 0;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedtime = DateFormat('kk:mm').format(DateTime.now());
  String printime = DateFormat('yyyy-MM-dd, kk:mm').format(DateTime.now());
  String judgeName = "";
  String episodeName = "0";
  String seasonName = "Season2";
  String sexName = "";
  String regionName = "";
  String levelName = "";
  String zoneName = "";
  String codeName = "";
  String userName = "";
  String imageUrl = "";
  String accesslevel = "";
  String phone = "";
  bool newRecord = true;
  String contestantName = "";
  String contestantID = "";
  bool isLoading = false;
  bool loadingLevels = true;
  bool loadingWeeks = true;
  bool loadingRegion = true;
  bool loadingEpisodes = true;
  bool loadingJudge = true;
  List<String> regs = [];
  List<String> judges = [];
  List<Staff> staffList = [];
  List<Map<String, dynamic>> pendingeviction = [];
  List<String> components = [];
  List<String> judgeLevels = [];

  String? contestantan;
  String judgeRegion = '';
  String judgeZone = '';
  String judgeLevel = '';
  String judgeID = '';
  String? selectedLevel;
  String? zone;
  String? region;
  String? selectedEpisode;
  String? selectedJudge;
  String episodeInt = "0";
  XFile? imagefile;
  int totalcontestants = 0;
  int totaljugdes = 0;
  String groupedlevel = '';
  String errorMessage = "";
  bool savingSetup = false;
  String? judgeid;
  String episode = '';
  String judgeId = '';
  String regions = '';
  String zoness = '';
  List<Map<String, dynamic>> marksList = [];
  List<Map<String, dynamic>> scoredList = [];
  List<Map<String, dynamic>> voteList = [];
  bool isLoadingm = false;
  List<ScoringMark> allScores = [];
  String? selectedRegion;
  String? selectedZone;
  List<Map<String, dynamic>> judgeData = [];
  bool loadingJudges = true;
  bool isLoadingjudge = true;
  bool isLoadingjudgevote = true;
  List<Map<String, dynamic>> tableData = [];
  List<String> judgeColumns = [];
  List<Map<String, String>> distinctMeta = [];
  List<Map<String, dynamic>> contestantsev = [];
  Map<String, Map<String, dynamic>> bestCriteriaData = {};
  bool isLoadingweeklysheet = true;
  bool isLoadingEvictionvote = true;
  List<Map<String, dynamic>> weeklysheettableData = [];
  List<Map<String, String>> weeklysheetdistinctMeta = [];
  List<Map<String, String>> EvictionWeeklyMeta2 = [];
  List<Map<String, dynamic>> tableData1 = [];

  List<String> judgeColumns1 = [];
  List<String> judgeColumns2 = [];
  List<Map<String, dynamic>> tableData2 = [];
  bool isLoadingjudgevoteev = false;
  bool isLoadingjudgevoteevp = false;
  List<Map<String, dynamic>> contestantsevp = [];
  List<Map<String, dynamic>> assignedjudges = [];

  String pagekey = '';
  String companyname ="";
  List<Map<String, dynamic>> accessComponents = [];
  bool loadingComponents = false;
  String voteslevel='';
  String votesepisode='';
  String votesregion='';
  String pagekeyvote='';
  String scoringid = "";
  String week = "";

  bool deletingJudge = false;
  bool contestantLoading = false;
  bool contestantSaving = false;
  Map<String, dynamic>? contestantInfo;
  List<Map<String, dynamic>> contestantJudges = [];
  List<Map<String, dynamic>> contestantComponents = [];
  bool isLoadingAccessComponents = false;
  bool isLoggedIn = false;
  List<String> accessLevels = ['Judge'];

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  List<Map<String, dynamic>> criteriaList = [];
  bool isEvicting = false;
  Map<String, TextEditingController> controllers = {};
  final TextEditingController totalController = TextEditingController();
  Map<String, dynamic> contestantScores = {};
  final Map<String, int> voteCache = {};
  Map<String, String?> judgeNames = {};
  Set<String> selectedDocIds = {};
  List<String> judgeLevelss = [];
  List<Map<String, String>> judgeScoreRows = [];
  List<String> criteriaOrder = [];
  bool isLoadingScores = false;
  List<ZoneModel> zones = [];
  List<WeekModel> weeks = [];
  List<LevelModel> levelss = [];
  List<SeasonModel> seasons = [];
  List<RegionModel> regionList = [];
  List<EpisodeModel> episodesp = [];
  List<EpisodeModel> episodes = [];
  List<ContestantModel> contestant = [];
  final Set<String> _selectedEpisodes = {};
  bool isLoadingMore =true;
  DocumentSnapshot? lastFetchedDoc;
  bool isLoadingstaffdata = false;
  bool isLoadingjudgelist = false;
  List<Map<String, dynamic>> judgeList = [];
  Map<String, Map<String, dynamic>> groupedStaffDetails = {};
  bool isLoadingstafflist = false;
  DocumentSnapshot? lastDocument;
  DocumentSnapshot? firstDocument;
  Myprovider() {
    getdata();
    getaccessvel();
    countContestantsWithTotal();
    //deleteVoltaRegions();
  }
   deleteVoltaRegions() async {
    // Query all docs where region == "Volta"
    final snapshot = await db.collection('scoringMark').where('region', isEqualTo: 'Volta').get();
    // Loop through and delete each one
    for (var doc in snapshot.docs) {
      await db.collection('scoringMark').doc(doc.id).delete();
    }
  }
  Future<void> updateAllZones() async {

    // Get all documents from the collection
    final snapshot = await db.collection('scoringMark').get();

    // Loop through and update each document
    for (var doc in snapshot.docs) {
      await db.collection('scoringMark').doc(doc.id).update({
        'zone': 'Zone One', // field to update
      });
    }
  }
  assignedJudges() async {
    try {
      isLoading = true;
      notifyListeners();
      await getdata();

      Query<Map<String, dynamic>> baseQuery = db.collection('judgeSetup').where('season',isEqualTo: seasonName);
      if (accesslevel == 'Admin') {
        baseQuery = baseQuery.where('region', isEqualTo: regionName);
      } else if (accesslevel == 'Super Admin') {
      }

      final snapshot = await baseQuery.get();
      assignedjudges = snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'name': data['judge'] ?? '',
          'nametext': data['name'] ?? '',
          'zone': data['zone'] ?? '',
          'episode': data['episode'] ?? '',
          'level': data['levels'] ?? '',
          'region': data['region'] ?? '',
        };
      }).toList();
       print(assignedjudges);

      final Map<String, Map<String, dynamic>> grouped = {};

      for (final item in assignedjudges) {
        final name = (item['name'] ?? '').toString().trim();
        final region = (item['region'] ?? '').toString().trim();
        final zone = item['zone'] ?? '';
        final key = '$name|$region';

        final episodeRaw = item['episode'] ?? '';
        final episodes = episodeRaw is List
            ? List<String>.from(episodeRaw)
            : episodeRaw.toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

        final levelRaw = item['level'] ?? '';
        final levels = levelRaw is List
            ? List<String>.from(levelRaw)
            : levelRaw.toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

        if (!grouped.containsKey(key)) {
          grouped[key] = {
            'name': name,
            'region': region,
            'zone': zone,
            'episodes': Set<String>.from(episodes),
            'levels': Set<String>.from(levels),
            'selectedEpisode': episodes.isNotEmpty ? episodes.first : null,
            'selectedLevel': levels.isNotEmpty ? levels.first : null,
          };
        } else {
          grouped[key]!['episodes'].addAll(episodes);
          grouped[key]!['levels'].addAll(levels);
        }
      }

      groupedStaffDetails = grouped;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error loading judges: $e');
    }
  }
  List<Map<String, dynamic>> getFilteredGroupedStaff(String searchText) {
    final lower = searchText.trim().toLowerCase();
    return groupedStaffDetails.values.where((item) {
      final name = item['name']?.toLowerCase() ?? '';
      final region = item['region']?.toLowerCase() ?? '';
      return name.contains(lower) || region.contains(lower);
    }).toList()
      ..sort((a, b) {
        final nameCompare = a['name'].compareTo(b['name']);
        return nameCompare != 0 ? nameCompare : a['region'].compareTo(b['region']);
      });
  }

  getfetchZones() async {
    try {
      isLoading = true;
      notifyListeners();
      final snapshot = await db
          .collection("zone")
          .get();
      zones= snapshot.docs.map((doc) {
        final data = doc.data();

        return ZoneModel(
          id: doc.id,
          zonename: data['name'] ?? '',
          staff: data['staff']?? '',
          time: data['timestamp'] is Timestamp
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.parse(data['timestamp'].toString()),
        );
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Failed to fetch zones: $e");
    }
  }
  Future<void> getfetchLevels() async {
    try {
      isLoadingstaffdata = true;
      notifyListeners();

      final snapshot = await db.collection("level").get();

      levelss = snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime parsedTime;

        if (data['timestamp'] is Timestamp) {
          parsedTime = (data['timestamp'] as Timestamp).toDate();
        } else if (data['timestamp'] is DateTime) {
          parsedTime = data['timestamp'];
        } else if (data['timestamp'] is String) {
          try {
            parsedTime = DateTime.parse(data['timestamp']);
          } catch (_) {
            parsedTime = DateTime.now();
          }
        } else {
          parsedTime = DateTime.now();
        }

        return LevelModel(
          id: doc.id,
          levelname: data['name'] ?? '',
          time: parsedTime,
        );
      }).toList();

      isLoadingstaffdata = false;
      notifyListeners();
    } catch (e) {
      isLoadingstaffdata = false;
      notifyListeners();
      print("Failed to fetch levels: $e");
    }
  }
  Future<void> contestantdata() async {
    try {
      isLoading = true;
      contestant.clear();
      notifyListeners();

      Query query = db.collection('contestant').orderBy('level');

      if (accesslevel == "Super Admin") {
        query = query;
      } else if(accesslevel == "Admin"){
        query = query.where('region', isEqualTo: regionName);
      }
      else if (accesslevel == "Judge") {
        notifyListeners();
        return;
      }

      DocumentSnapshot? lastDoc;
      while (true) {
        Query pageQuery = query.limit(50);

        if (lastDoc != null) {
          pageQuery = pageQuery.startAfterDocument(lastDoc);
        }

        final snapshot = await pageQuery.get(const GetOptions(source: Source.serverAndCache));

        final newContestants = snapshot.docs.map((doc) {
          final c = doc.data() as Map<String, dynamic>;
          return ContestantModel(
            id: c['id']?.toString() ?? doc.id,
            name: c['name']?.toString() ?? '',
            sex: c['sex']?.toString() ?? '',
            region: c['region']?.toString() ?? '',
            level: c['level']?.toString() ?? '',
            school: c['school']?.toString() ?? '',
            guardianContact: c['guardianContact']?.toString() ?? '',
            zone: c['zone']?.toString() ?? '',
            photoUrl: c['photoUrl']?.toString() ?? '',
            contestantId: c['contestantId']?.toString() ?? '',
            timestamp: c['timestamp'] != null
                ? (c['timestamp'] is Timestamp
                ? (c['timestamp'] as Timestamp).toDate()
                : DateTime.tryParse(c['timestamp'].toString()) ?? DateTime.now())
                : DateTime.now(),
            votename: '',
          );
        }).toList();

        contestant.addAll(newContestants);

        if (snapshot.docs.isEmpty || snapshot.docs.length < 50) {
          break;
        }

        lastDoc = snapshot.docs.last;
      }

    } catch (e) {
      debugPrint("Error fetching contestants: $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }
  getfetchSeasons() async {
    try {
      isLoading=true;
      final snapshot = await db
          .collection("seasons")
          .get();

      seasons= snapshot.docs.map((doc) {
        final data =doc.data();
        return SeasonModel (
          id: doc.id,
          seasonname: data['name']??'',
          time: data['timestamp'] is Timestamp
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.parse(data['timestamp'].toString()),

        );
      }).toList();
      isLoading =false;
      notifyListeners();
    } catch (e) {
      print("Failed to fetch seasons: $e");
    }
  }
  getfetchWeeks() async {
    try {
      isLoading =true;
      notifyListeners();
      final snapshot = await db.collection("weeks").get();
      weeks= snapshot.docs.map((doc) {
        final data= doc.data();
        return WeekModel(
          id: doc.id,
          weekname: data['name'],
          time: data['timestamp'] is Timestamp
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.parse(data['timestamp'].toString()),
        );
      }).toList();
      isLoading = true;
      notifyListeners();
    } catch (e) {
      print("Failed to fetch weeks: $e");
    }
  }
  getaccessvel() async {
    try {
      isLoading =true;
      await getdata();
      if (accesslevel == "Admin") {
        if (!accessLevels.contains("Judge")) {
          accessLevels.add("Judge");
        }
      } else if (accesslevel == "Super Admin") {
        for (var role in ["Super Admin", "Admin", "Judge"]) {
          if (!accessLevels.contains(role)) {
            accessLevels.add(role);
          }
        }
      } else {
        accessLevels = [];
      }
      isLoading = false;
      notifyListeners();
    } catch (e, stack) {
      debugPrint("Error in getaccessvel: $e");
      //debugPrint(stack.toString());
      accessLevels = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  logout(BuildContext context) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    final auth = FirebaseAuth.instance;
    await auth.signOut();
    // Remove stored judgeId
    await pref.remove('judgeId');
    await pref.remove('phone');
    await pref.remove('accesslevel') ;
    await pref.remove('level') ;
    await pref.remove('region');
    await pref.remove('zone');
    await pref.remove('episode');
    await pref.setBool('islogin',true)!;
    //await getdata();
    // Navigate to login
    context.go(Routes.login);
    notifyListeners();
  }
  countContestantsWithTotals() async {

    try {
      await getdata();
      Query<Map<String, dynamic>> baseQuery = db.collection('contestant');

      if (accesslevel == "Admin") {
        baseQuery = baseQuery.where('region', isEqualTo: regionName);
      } else if (accesslevel == "Super Admin") {

      }else{
        // No access for other roles
        totalcontestants = 0;
        evictedCount = 0;
        notifyListeners();
        return;
      }

      final totalSnapshot = await baseQuery.get();
      totalcontestants = totalSnapshot.docs.length;

      final evictedSnapshot = await baseQuery
          .where('status', isEqualTo: 'evicted')
          .get();
      evictedCount = evictedSnapshot.docs.length;

      notifyListeners();
    } catch (e) {
      debugPrint("Error counting contestants: $e");
    }
  }
  Future<void> activateAllContestants() async {
    final batch = db.batch();

    try {
      // Get all contestants
      final snapshot = await db.collection('contestant').get();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': 'active',
        });
      }

      await batch.commit();
      debugPrint("✅ All contestants updated to active.");
    } catch (e) {
      debugPrint("❌ Error updating contestants: $e");
    }
  }
  evictContestant({ required String contestantId, }) async {
    isEvicting = true;
    notifyListeners();

    final batch = db.batch();
    final evictionStamp = FieldValue.serverTimestamp();

    try {
      final [contestantSnapshot, scoringSnapshot] = await Future.wait([
        db
            .collection('contestant')
            .where('region', isEqualTo: regionName)
            .where('contestantId', isEqualTo: contestantId)
            .where('zone', isEqualTo: zoneName)
            .get(),
        db
            .collection('scoringMark')
            .where('region', isEqualTo: regionName)
            .where('studentId', isEqualTo: contestantId)
            .where('zone', isEqualTo: zoneName)
            .get(),
      ]);

      // 2. Add updates for all documents from the first query to the batch
      for (final doc in contestantSnapshot.docs) {
        batch.update(doc.reference, {
          'status': 'evicted',
          'evictedstaff': '$phone',
          'evictionTime': evictionStamp,
        });
      }

      // 3. Add updates for all documents from the second query to the batch
      for (final doc in scoringSnapshot.docs) {
        batch.update(doc.reference, {
          'status': 'evicted',
          'evictedstaff': '$phone',
          'evictionTime': evictionStamp,
        });
      }

      void _markLocallyEvicted(String contestantId) {
        final idx = pendingeviction.indexWhere(
              (m) => m['studentId'] == contestantId,
        );
        if (idx != -1) {
          pendingeviction[idx]['status'] = 'evicted';
        }
      }
      await batch.commit();
      _markLocallyEvicted(contestantId);
    } catch (e) {
      debugPrint('Error evicting contestant: $e');
      rethrow;
    } finally {
      isEvicting = false;
      notifyListeners();
    }
  }
  initializeControllers(Map<String, dynamic> scores) {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();

    for (final key in scores.keys) {
      var controller = TextEditingController(text: scores[key]?.toString() ?? '');
      if(controller.text=="0"){
         controller = TextEditingController();
      }
      controller.addListener(updateTotalScore);
      controllers[key] = controller;
    }
    updateTotalScore(); // Set initial total
  }
  void updateTotalScore() {
    double total = 0;

    for (final controller in controllers.values) {
      final value = double.tryParse(controller.text.trim()) ?? 0;
      final rounded = double.parse(value.toStringAsFixed(1));
      total += rounded;
    }

    totalController.text = total.toStringAsFixed(1);
    notifyListeners();
  }
  setContestantDetails({ required String scoringid, required String studentId, required String studentName,required String photoUrl, required String pagekey, required Map<String, dynamic> scores,  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scoringid', scoringid);
    await prefs.setString('studentId', studentId);
    await prefs.setString('studentName', studentName);
    await prefs.setString('studentphoto', photoUrl);
    await prefs.setString('pagekey', pagekey);
    await prefs.setString('scores', jsonEncode(scores));

    await contestantdetails();
    notifyListeners();
  }
  clearContestantDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('scoringid');
    await prefs.remove('studentId');
    await prefs.remove('studentName');
    await prefs.remove('studentphoto');
    await prefs.remove('pagekey');
    await prefs.remove('scores');

    contestantID = '';
    contestantName = '';
    imageUrl = '';
    pagekey = '';
    contestantScores = <String, dynamic>{};
    notifyListeners();
  }
  contestantdetails() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      scoringid = prefs.getString("scoringid") ?? '';
      contestantID = prefs.getString("studentId") ?? '';
      contestantName = prefs.getString("studentName") ?? '';
      imageUrl = prefs.getString("studentphoto") ?? '';
      pagekey = prefs.getString("pagekey") ?? '';
      final jsonString = prefs.getString("scores");
      contestantScores = jsonString != null
          ? jsonDecode(jsonString) as Map<String, dynamic>
          : {};
      //print("contestantScores:$contestantScores");
    } catch (e) {
      print("error:$e");
    }
  }
  evictionList() async {
    try {
      isLoading = true;
      notifyListeners();
      await getdata();
      late Query<Map<String, dynamic>> query;
      query = db
          .collection('contestant')
          .where("region", isEqualTo: regionName)
          .where("zone", isEqualTo: zoneName)
          .where('status', isEqualTo: 'active');

      final querySnapshot = await query.get();
      pendingeviction = await querySnapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'studentName': data['name'] ?? '',
          'studentId': data['contestantId'] ?? '',
          'level': data['level'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'region': data['region'] ?? 'N/A',
          'status': data['status'] ?? 'active',
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching scored marks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  votesdata() async {
    try {
      isLoading = true;
      notifyListeners();
      await getdata();
      late Query<Map<String, dynamic>> query;
      query = db
          .collection('scoringMark')
          .where("episodeId", isEqualTo: votesepisode)
          .where("region", isEqualTo: votesregion)
          .where("level", isEqualTo: voteslevel)
          .where("zone", isEqualTo: zoneName);


      final querySnapshot = await query.get();
      voteList = await querySnapshot.docs.map((doc) {
        final data = doc.data();
        final scores = (data[phone]?['scores'] as Map<String, dynamic>?) ?? <String, dynamic>{};

        return {
          'id': doc.id,
          'studentName': data['studentName'] ?? '',
          'studentId': data['studentId'] ?? '',
          'level': data['level'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'votes': data['votes'] ?? '0',
          'episode': data['episodeId'] ?? '',
          'region': data['region'] ?? '0',
          'scores': scores,
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching scored marks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  setContestantvoteDetails({
    required String voteslevel,
    required String votesepisode,
    required String votesregion,
    required String pagekeyvote,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voteslevel', voteslevel);
    await prefs.setString('votesepisode', votesepisode);
    await prefs.setString('votesregion', votesregion);
    await prefs.setString('pagekeyvote', pagekeyvote);

    await contestanvotetdetails();
    notifyListeners();
  }
  contestanvotetdetails() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      voteslevel = prefs.getString("voteslevel") ?? '';
      votesepisode = prefs.getString("votesepisode") ?? '';
      votesregion = prefs.getString("votesregion") ?? '';
      pagekeyvote = prefs.getString("pagekeyvote") ?? '';

      //print("contestantScores:$contestantScores");
    } catch (e) {
      print("error:$e");
    }
  }
  clearContestantvoteDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('voteslevel');
    await prefs.remove('votesepisode');
    await prefs.remove('votesregion');
    await prefs.remove('pagekeyvote');

    pagekeyvote = '';
    votesregion = '';
    votesepisode = '';
    voteslevel = '';
    notifyListeners();
  }
  setstaffmarks({required String level}) async {
    final pref = await SharedPreferences.getInstance();

    await pref.setString('level', level);

    await getdata();
    //await fetchScoringMarks();
    notifyListeners();
  }
  setContestantScore(String contestantId, String score) async {
    try {
      isLoading = true;
      notifyListeners();
      final docRef = db.collection('scoringMark').doc(contestantId);
      await docRef.update({
        'votes': score,
        'votetimestamp': FieldValue.serverTimestamp(),
      });
      voteList.removeWhere((element) => element['id'] == contestantId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating score: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
  validateAndSubmitDynamicFields(
      String studentKey, String contestantID, BuildContext context) async {    double total = 0;    for (final entry in controllers.entries) {
    final value = entry.value.text.trim();
    if (value.isEmpty || double.tryParse(value) == null || double.parse(value) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid input for ${entry.key}')),
      );

      return false;
    }
    total += double.parse(value);
  }
  // Set total to totalController
  totalController.text = total.toStringAsFixed(1);
  final Map<String, String> data = controllers.map((key, controller) {
    return MapEntry(key, controller.text.toString());
  });

  try {
    savingSetup = true;
    notifyListeners();
    final docRef = db.collection('scoringMark').doc(studentKey);
    final newScoreEntry = {
      'total$phone': total.toString(),
      '$phone': {
        'scores': data,
        'timestamp': FieldValue.serverTimestamp(),
        'totalScore': "$total",
        'criteriatotal': "$criteriaTotal",
        'status': "1",
      },
      'scored$phone': 'yes',
    };
     docRef.update(newScoreEntry);
    marksList.removeWhere((sid) => sid['studentId'] == contestantID);
    clearControllers();
    savingSetup = false;
    return true;
  } catch (e) {
    savingSetup = false;
    notifyListeners();
    return false;
  }
  }
  fetchRegion() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('regions')
          .get();
      regs = snapshot.docs.map((doc) => doc['name'].toString()).toList();
      loadingRegion = false;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  resetScoringMarks({    required String staffPhone, required String region,required String level, required String episode, }) async {

    try {
      isLoading=true;
      notifyListeners();
      final scoredField = 'scored$staffPhone';
      if(accesslevel=='Admin'){
        print('Admin access, resetting all scores');
        final query = await db
            .collection('scoringMark')
            .where(scoredField, isEqualTo: 'yes')
            .where('region', isEqualTo: region)
            .where('level', isEqualTo: level)
            .where('episodeId', isEqualTo: episode).get();

        WriteBatch batch = db.batch();

        for (final doc in query.docs) {
          final data = doc.data();
          if (data.containsKey(staffPhone)) {
            final judgeData = data[staffPhone] as Map<String, dynamic>? ?? {};
            final scores = judgeData['scores'] as Map<String, dynamic>? ?? {};
            final resetScores = {for (var key in scores.keys) key: '0'};
            print('Resetting scores for $staffPhone: $resetScores');
            final updateData = {
              staffPhone: {
                'criteriatotal': '0',
                'scores': resetScores,
                'totalScore': '0',
              },
              scoredField: 'no',
            };

            batch.update(doc.reference, updateData);
          }
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error resetting scoringMark: $e');
      rethrow;
    }finally {
      isLoading = false;
      notifyListeners();
    }

  }



  //  store a votes
  void cacheVote(String studentId, int votes) {
    voteCache[studentId] = votes;
    notifyListeners();
  }

  // Clear all cached votes
  clearVoteCache() {
    voteCache.clear();
    notifyListeners();
  }


  set isSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }

  /// Commits all cached votes to Firestore in a single batch.
  Future<void> submitAllVotes() async {
    if (voteCache.isEmpty) return;

    isSubmitting = true;
    try {
      final batch = db.batch();
      final baseCollection = db.collection('scoringMark');

      voteCache.forEach((docid, votes) {
        final docRef = baseCollection.doc(docid);
        batch.set(docRef, {'votes': "$votes"}, SetOptions(merge: true));
      });

      await batch.commit();
      // Clear cache on success
      voteCache.clear();
    } on FirebaseException catch (e) {
      debugPrint('Firestore error: ${e.message}');
      rethrow;
    } finally {
      isSubmitting = false;
    }
  }


  Future<bool> checkDuplicateScores(String judgeA, String judgeB) async {
    final snapshot = await db.collection('scoringMark').limit(15).get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final scoreA = data[judgeA]?['totalScore']?.toString() ?? '';
      final scoreB = data[judgeB]?['totalScore']?.toString() ?? '';
      if (scoreA != scoreB) return false;
    }

    return true;
  }

  submitValuesToFirestore(String CID, String skey) async {
    try {
      savingSetup = true;
      notifyListeners();
      int totaljudgescore = 0;
      int totalespisodeMark = 0;
      Map<String, dynamic> scores = {};
      for (int i = 0; i < criteriaList.length; i++) {
        final name = criteriaList[i]['name'];
        final max = criteriaList[i]['max'];
        final input = controllers[i]?.text.trim();
        int maxval = max;
        if (input!.isEmpty) {
          throw Exception('Score for "$name" is missing.');
        }

        final value = int.tryParse(input);
        if (value == null|| value<0) {
          throw Exception('Score for "$name" must be a number greater than 0.');
        }

        if (value > max) {
          throw Exception('Score for "$name" exceeds max value of $max.');
        }

        scores['$name'] = "$value";
        totaljudgescore += value;
        totalespisodeMark += maxval;
      }
      // Save to Firestore
      final docRef = db.collection('scoringMark').doc(CID);
      final newScoreEntry = {
        '$phone': {
          'scores': scores,
          'timestamp': FieldValue.serverTimestamp(),
          'totalScore': "$totaljudgescore",
          'criteriatotal': "$totalespisodeMark",
          'status': "1",
        },
        'scored$phone': 'yes',
      };
      await docRef.update(newScoreEntry);
      marksList.removeWhere((sid) => sid['studentId'] == skey);
      // scoredList.add(newScoreEntry);
      clearControllers();
    } catch (e) {
      print(e);
      throw e.toString(); // Let the UI handle the error
    } finally {
      savingSetup = false;
      notifyListeners();
    }
  }
  clearControllers() {
    totalController.clear();
    notifyListeners();
  }
  countContestantsWithTotal() async {
    final snapshot = await db
        .collection('contestant')
        .get();

    final Map<String, int> levelCounts = {};
    totalcontestants = snapshot.size;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final region = data['regions']?.toString() ?? 'Unknown';
      levelCounts[region] = (levelCounts[region] ?? 0) + 1;
    }
  }


  pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? selectedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (selectedImage == null) {
        print("No image selected");
        return;
      }

      final int fileSizeInBytes = await selectedImage.length();

      if (fileSizeInBytes > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image size exceeds 5MB. Please choose a smaller file.',
            ),
          ),
        );
        return;
      }
      imagefile = selectedImage;
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick image.')));
    }
  }
  uploadImage(String studentcode) async {
    if (imagefile == null) return;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child(
        'uploads/$fileName$studentcode.jpg',
      );
      UploadTask uploadTask;

      if (kIsWeb) {
        print("Uploading for Web");
        final Uint8List data = await imagefile!.readAsBytes();
        uploadTask = ref.putData(
          data,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        print("Uploading for iOS/Android/Mac");

        final file = File(imagefile!.path);
        uploadTask = ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl = downloadUrl;
      // print("Image URL: $imageUrl");
      notifyListeners();
    } catch (e) {
      print('Upload failed: $e');
    }
  }
  checkUser() async {
    String key = "${codeName}${seasonName}${episodeName}";
    final dbexist = await db.collection("marks").doc(key).get();
    if (dbexist.exists) {
      newRecord = false;
    } else {
      newRecord = true;
    }
    print(newRecord);
  }
  setDetails( String id, String cName, String jName,  String sexname, String rName, String lName, String codname,String image, String sName, int eName,  String zone,  ) async {
    id = id;
    judgeName = jName;
    contestantName = cName;
    sexName = sexname;
    regionName = rName;
    levelName = lName;
    episodeName = eName.toString();
    seasonName = "1";
    codeName = codname;
    imageUrl = image;
    zone = zone;
    await checkUser();
    notifyListeners();
  }
  saveJudgeSetup({ selectedJudge, selectedZone, selectedRegion,episodeInt, selectedLevels, selectedComponents,}) async {
    savingSetup = true;
    notifyListeners();

    try {
      // 🔹 Build judgeSetupId
      String judgeSetupId = '$selectedJudge$episodeInt$seasonName';

      // 🔹 Check if judge already exists for same zone/region/episode/level
      final existingQuery = await db
          .collection('judgeSetup')
          .where('region', isEqualTo: selectedRegion)
          .where('zone', isEqualTo: selectedZone)
          .where('episode', isEqualTo: episodeInt)
          .where('level', arrayContainsAny: selectedLevels)
          .get();

      bool judgeAlreadyExists = existingQuery.docs.any(
            (doc) => doc['judge'] == selectedJudge,
      );

      // block if judge has already scored
      if (judgeAlreadyExists) {
        final scoredQuery = await db
            .collection('scoringMark')
            .where('episodeId', isEqualTo: episodeInt)
            .where('zone', isEqualTo: selectedZone)
            .where('region', isEqualTo: selectedRegion)
            .where('level', whereIn: selectedLevels)
            .get();

        bool judgeHasScored = scoredQuery.docs.any((doc) {
          final judgeData = doc.data()[selectedJudge];
          if (judgeData == null) return false;

          final scores = judgeData['scores'] as Map<String, dynamic>? ?? {};
          return scores.values.any((v) {
            final val = double.tryParse(v.toString()) ?? 0;
            return val > 0.0;
          });
        });

        if (judgeHasScored) {
          throw Exception("Judge already set up and has entered marks.");
        }
      }

      // 🔹 Save or overwrite judgeSetup
      final judgeSetupRef = db.collection('judgeSetup').doc(judgeSetupId);
      final judgeSetupSnap = await judgeSetupRef.get();

      if (judgeSetupSnap.exists) {
        // 🔹 Overwrite completely
        await judgeSetupRef.update({
          'level': selectedLevels,
          'components': selectedComponents,
          'timestamp': DateTime.now(),
        });
      } else {
        await judgeSetupRef.set({
          'judge': selectedJudge,
          'zone': selectedZone,
          'region': selectedRegion,
          'level': selectedLevels,
          'episode': episodeInt,
          'components': selectedComponents,
          'timestamp': DateTime.now(),
        });
      }

      // 🔹 Update staff
      await db.collection("staff").doc(selectedJudge.toString()).set(
        {
          "episode": episodeInt,
          "level": selectedLevels[0],
          "zone": selectedZone,
          "region": selectedRegion,
        },
        SetOptions(merge: true),
      );

      // 🔹 Use components instead of criteria
      final List<Map<String, dynamic>> componentsList = selectedComponents;

      // 🔹 Fetch contestants
      final contestantsSnap = await db
          .collection('contestant')
          .where('zone', isEqualTo: selectedZone)
          .where('region', isEqualTo: selectedRegion)
          .where('level', whereIn: selectedLevels)
          .where('status', isNotEqualTo: 'evicted')
          .get();

      if (contestantsSnap.docs.isEmpty) {
        throw Exception("No contestants found for selected filters.");
        // print("No contestants found for selected filters.");
      }

      // 🔹 Batch process scoring docs
      WriteBatch batch = db.batch();
      for (var contestant in contestantsSnap.docs) {
        final studentId = contestant.id;
        final studentName = contestant['name'];
        final docId = '$studentId$seasonName$episodeInt';
        final scoreRef = db.collection('scoringMark').doc(docId.trim());
        final scoreSnap = await scoreRef.get();
        final Map<String, String> initialScores = {};
        for (var comp in componentsList) {
          initialScores[comp['name']] = "0";
        }

        if (scoreSnap.exists) {
          // 🔹 Overwrite judge’s section completely
          batch.update(scoreRef, {
            'scored$selectedJudge': "no",
            '$selectedJudge': {
              'judgeName': selectedJudge,
              'judgeZone': selectedZone,
              'judgeRegion': selectedRegion,
              'scores': initialScores,
              'timestamp': FieldValue.serverTimestamp(),
              'totalScore': 0,
            },
          });
        } else {
          // 🔹 Insert fresh doc
          batch.set(scoreRef, {
            'episodeId': episodeInt,
            'episodeTitle': episodeInt,
            'studentId': studentId,
            'studentName': studentName,
            'level': contestant['level'],
            'photoUrl': contestant.data().containsKey('photoUrl') ? contestant['photoUrl'] : '',
            'zone': selectedZone,
            'region': selectedRegion,
            'scored$selectedJudge': "no",
            '$selectedJudge': {
              'judgeName': selectedJudge,
              'judgeZone': selectedZone,
              'judgeRegion': selectedRegion,
              'scores': initialScores,
              'timestamp': FieldValue.serverTimestamp(),
              'totalScore': 0,
            },
          });
        }
      }

      await batch.commit();
    } catch (e, stack) {
      print("Error in saveJudgeSetup: $e");
      debugPrintStack(stackTrace: stack);
    } finally {
      savingSetup = false;
      notifyListeners();
    }
  }

  // fetchJudgeLevels(String judgePhone) async {
  //   try {
  //     final querySnapshot = await db
  //         .collection('judgeSetup')
  //         .where('judge', isEqualTo: judgePhone)
  //         .get();
  //
  //     List<String> levels = [];
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       final data = querySnapshot.docs.first.data();
  //
  //       // Store metadata
  //       episode = data['episode']?.toString() ?? '';
  //       judgeId = data['judge']?.toString() ?? '';
  //       regions = data['region']?.toString() ?? '';
  //       zoness = data['zone']?.toString() ?? '';
  //       // Extract levels
  //       if (data.containsKey('level')) {
  //         final lvl = data['level'];
  //         if (lvl is List) {
  //           levels.addAll(
  //             lvl.map((e) => e.toString().trim()).where((e) => e.isNotEmpty),
  //           );
  //         } else {
  //           final cleanLevel = lvl.toString().trim();
  //           if (cleanLevel.isNotEmpty) {
  //             levels.add(cleanLevel);
  //           }
  //         }
  //       }
  //     }
  //
  //     // Remove duplicates
  //     judgeLevelss = levels.toSet().toList();
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error fetching judge levels: $e");
  //   }
  // }

  fetchScoringMarks(String judgeID,String judgelevel) async {
    await getdata();
    isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await db
          .collection('scoringMark')
          .where('episodeId', isEqualTo: episodeName)
          .where('region', isEqualTo: regionName)
          .where('level', isEqualTo: judgelevel)
          .where('scored$judgeID', isEqualTo: "no").get();

      marksList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final docid=doc.id;
        final scores = (data[phone]?['scores'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        // Convert scores map to a list of entries
        final sortedScoresList = scores.entries.toList();
        sortedScoresList.sort((a, b) => a.key.compareTo(b.key));
        final sortedScoresMap = Map.fromEntries(sortedScoresList);

        return {
          'id': docid,
          'studentName': data['studentName'] ?? '',
          'studentId': data['studentId'] ?? '',
          'level': data['level'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'scores': sortedScoresMap,
        };
      }).toList();

    } catch (e) {
      print("Error fetching scoring marks: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
  fetchScoredMarks() async {
    try {
      isLoading = true;
      notifyListeners();

      await getdata();
      final query = db
          .collection('scoringMark')
          .where('episodeId', isEqualTo: episodeName)
          .where('region', isEqualTo: regionName)
          .where('level', isEqualTo: levelName)
          .where('scored$phone', isEqualTo: "yes");

      final snapshot = await query.get();

      scoredList = snapshot.docs.map((doc) {
        final data = doc.data();
        final phoneSection = data[phone];
        final rawScores =
        phoneSection is Map<String, dynamic>
            ? phoneSection['scores']
            : null;
        final totalScoreRaw =
        phoneSection is Map<String, dynamic>
            ? phoneSection['totalScore']
            : null;
        final scores = (data[phone]?['scores'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        // Convert scores map to a list of entries
        final sortedScoresList = scores.entries.toList();
        sortedScoresList.sort((a, b) => a.key.compareTo(b.key));
        final sortedScoresMap = Map.fromEntries(sortedScoresList);


        return {
          'id':         doc.id,
          'studentName': data['studentName'] ?? '',
          'studentId':   data['studentId']   ?? '',
          'level':       data['level']       ?? '',
          'photoUrl':    data['photoUrl']    ?? '',
          'totalscore':  totalScoreRaw?.toString() ?? '0',
          'scores':      sortedScoresMap,
        };
      }).toList();
    } catch (e) {
      print("Error fetching scored marks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String phone, String password, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      final staffSnapshot = await db.collection('staff').doc(phone).get();

      if (!staffSnapshot.exists) {
        errorMessage = 'This phone is not registered under Bookworm staff.';
        debugPrint(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
        return;
      }

      final staff = staffSnapshot.data();
      final status = staff!['status'].toString();
      final name = staff['name'].toString();
      final email = staff['email'].toString();
      final accesslevel = staff['accessLevel'].toString();
      final levelTxt = staff['level'].toString();
      final regionTxt = staff['region'].toString();
      final zoneTxt = staff['zone'].toString();
      final episodeTxt = staff['episode'].toString();

      if (status == "1") {
        // ✅ Try logging in
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        // 🆕 Register new user
        await auth.createUserWithEmailAndPassword(email: email, password: password);

        await db.collection("staff").doc(phone).set({
          "status": "1",
        }, SetOptions(merge: true));
      }

      await auth.currentUser!.updateDisplayName(name);

      // Save user info locally
      await pref.setString('phone', phone);
      await pref.setString('accesslevel', accesslevel);
      await pref.setString('level', levelTxt);
      await pref.setString('region', regionTxt);
      await pref.setString('zone', zoneTxt);
      await pref.setString('episode', episodeTxt);
      await pref.setString('name', name);
      await pref.setBool('islogin', true);
      await getdata();
      await getaccessvel();
      // ✅ Redirect based on access level
      if (accesslevel == "Admin" || accesslevel == "Super Admin") {
        //Navigator.pushReplacementNamed(context, Routes.dashboard);
         context.go('${Routes.dashboard}');

      } else {
       // Navigator.pushReplacementNamed(context, Routes.assignedjudges);
        context.go('${Routes.judgelandingpage}');

      }

    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth error: ${e.message}"), backgroundColor: Colors.red),
      );

    } catch (e, stack) {
      debugPrint("Unexpected error: $e");
      debugPrintStack(stackTrace: stack);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Please try again."), backgroundColor: Colors.red),
      );
    }
  }
  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      phone = pref.getString('phone') ?? "null";
      accesslevel = pref.getString('accesslevel') ?? "null";
      levelName = pref.getString('level') ?? "null";
      regionName = pref.getString('region') ?? "null";
      zoneName = pref.getString('zone') ?? "null";
      episodeName = pref.getString('episode') ?? "null";
      userName = pref.getString('name') ?? "";
      isLoggedIn=pref.getBool('islogin')!;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
  Future<List<ScoringMark>> fetchAllScores() async {
    try {
      final snapshot = await db.collection("scoringMark").get();
      return snapshot.docs
          .map((doc) => ScoringMark.fromDoc(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching all scores: $e');
      return [];
    }
  }
  fetchJudges() async {
    try {
      await getdata();
      Query<Map<String, dynamic>> scoringQuery;

      if (accesslevel == "Super Admin") {
        scoringQuery = db.collection('scoringMark');
      } else if (accesslevel == "Admin") {
        scoringQuery = db
            .collection('scoringMark')
            .where("region", isEqualTo: regionName);
      } else if (accesslevel == "Judge") {
        scoringQuery = db
            .collection('scoringMark')
            .where("scored$phone", isEqualTo: "yes");
      } else {
        // fallback: no access
        loadingJudges = false;
        judgeData = [];
        notifyListeners();
        return;
      }

      //Execute filtered query once
      final snapshot = await scoringQuery.get();
      final Map<String, Map<String, dynamic>> judgeMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();

        final String region = (data['region'] ?? '').toString();
        final String episode = (data['episodeId'] ?? '').toString();
        final String level = (data['level'] ?? '').toString();

        //Scan for judge IDs (numeric keys only)
        data.forEach((key, value) {
          if (value is Map && RegExp(r'^\d+$').hasMatch(key)) {
            final uniqueKey = '$key|$region|$episode';

            if (!judgeMap.containsKey(uniqueKey)) {
              judgeMap[uniqueKey] = {
                'judge': key,
                'region': region,
                'levels': <String>{level},
                'episode': episode,
                'selectedLevel': level,
                'hasData': true,
              };
            } else {
              (judgeMap[uniqueKey]!['levels'] as Set<String>).add(level);
              judgeMap[uniqueKey]!['hasData'] = true;
            }
          }
        });
      }

      //Convert Set → List for UI
      judgeData = judgeMap.values.map((judge) {
        return {
          ...judge,
          'levels': (judge['levels'] as Set<String>).toList(),
        };
      }).toList()
        ..sort((a, b) => (a['region'] ?? '').compareTo(b['region'] ?? ''));

      loadingJudges = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching judges: $e");
      loadingJudges = false;
      notifyListeners();
    }
  }
  generateScoreSheetForJudge(judgeInfo,context,) async {
    double _toInt(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0.0;
    try {
      final snapshot = await db
          .collection('scoringMark')
          .where('region', isEqualTo: judgeInfo['region'])
          .where('episodeId', isEqualTo: judgeInfo['episode'])
          .where('level', isEqualTo: judgeInfo['selectedLevel'])
          .get();

      //debugPrint("📄 Retrieved ${snapshot.docs.length} scoring documents.");

      final List<Map<String, String>> rows = [];


      final Set<String> allCriteria = {};
      final Map<String, double> criterionMax = {};
      double sheetTotalMarks = 0.0;


      for (final doc in snapshot.docs) {
        final data = doc.data();
        final judgeKey = judgeInfo['judge'];

        if (data.containsKey(judgeKey) && data[judgeKey] is Map) {
          final scoreMap = Map<String, dynamic>.from(data[judgeKey]);
          final scores = Map<String, dynamic>.from(scoreMap['scores'] ?? {});

          // discover criteria (exclude any accidental "totalScore" key)
          for (final k in scores.keys) {
            if (k != "totalScore") allCriteria.add(k);
          }

          // prefer a non-zero criteriatotal from any row as the sheet's totalMarks
          if (sheetTotalMarks == 0) {
            final ct = _toInt(scoreMap['criteriatotal']);
            if (ct > 0) sheetTotalMarks = ct;
          }
        }
      }

      final List<String> criteriaOrder = allCriteria.toList()..sort();
      //debugPrint("Detected criteria (${criteriaOrder.length}): $criteriaOrder");
      if (sheetTotalMarks > 0) {
        // debugPrint("Using criteriatotal from data: $sheetTotalMarks");
      }

      // Pass 2: build rows and compute per-criterion max for fallback totalMarks
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final contestantName = data['studentName']?.toString() ?? '';
        final contestantCode = data['studentId']?.toString() ?? '';
        final judgeKey = judgeInfo['judge'];

        if (data.containsKey(judgeKey) && data[judgeKey] is Map) {
          final scoreMap = Map<String, dynamic>.from(data[judgeKey]);
          final scores = Map<String, dynamic>.from(scoreMap['scores'] ?? {});

          double contestantTotal = 0;
          final Map<String, String> row = {
            "name": contestantName,
            "code": contestantCode,
          };

          for (final criteria in criteriaOrder) {
            final val = _toInt(scores[criteria]);
            contestantTotal += val;
            row[criteria] = val.toString();

            // Track per-criterion maximum for fallback totalMarks if needed
            final currentMax = criterionMax[criteria] ?? 0;
            if (val > currentMax) criterionMax[criteria] = val;
          }

          row["total"] = contestantTotal.toString();
          rows.add(row);

          // debugPrint("Row added for '$contestantName': $row");
        }
      }

      // Fallback totalMarks: if no criteriatotal was found, sum of per-criterion max
      if (sheetTotalMarks == 0) {
        sheetTotalMarks = criterionMax.values.fold(0, (a, b) => a + b);
      }

      // Build and print
      String doctitle="${judgeInfo['region']}_${judgeInfo['selectedLevel']}_${judgeInfo['episode']}".toUpperCase();
      final printer = ScoreSheetPrinter(
        companyName: doctitle,
        eventTitle: 'BOOKWORM REALITY SHOW  SEASON 2'.toUpperCase(),
        subtitle: "Judge (Phone): ${judgeInfo['judge']}".toUpperCase(),
        zone: judgeInfo['region']?.toString() ?? ''.toUpperCase(),
        episode: judgeInfo['episode']?.toString() ?? ''.toUpperCase(),
        division: judgeInfo['selectedLevel']?.toString() ?? ''.toUpperCase(),
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: rows,
        totalMarks: sheetTotalMarks.toString(),

      );

      printer.printOrPreview(context);
    } catch (e) {
      debugPrint("Error generating scoresheet: $e");
    }
  }
  double _toInt(dynamic value) {
    try {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    } catch (e) {
      debugPrint('Error converting to double (from _toInt): $e');
      return 0.0;
    }
  }

  fetchscoringData({Map<String, String>? filterMeta}) async {
    try {
      isLoadingjudge = true;
      notifyListeners();
      Query scoringQuery = db.collection('scoringMark');
      await getdata();
      if (accesslevel == "Super Admin") {
        scoringQuery = scoringQuery;
      } else if (accesslevel == "Admin") {
        scoringQuery = scoringQuery
            .where("region", isEqualTo: regionName)
            .where("zone", isEqualTo: zone);
      } else if (accesslevel == "Judge") {
        tableData = [];
        judgeColumns = [];
        distinctMeta = [];
        isLoadingjudge = false;
        notifyListeners();
        return;
      }

      final snap = await scoringQuery.get();
      final List<Map<String, dynamic>> rows = [];
      final Set<String> allJudges = {};
      final Set<String> seenMeta = {};
      final List<Map<String, String>> metaList = [];

      for (final doc in snap.docs) {
        final data = doc.data()as Map<String, dynamic>;

        // Apply filter dynamically
        if (filterMeta != null) {
          bool skip = false;
          filterMeta.forEach((key, value) {
            if (value != null && value.isNotEmpty) {
              if (data[key] != value && data["${key}Title"] != value) {
                skip = true;
              }
            }
          });
          if (skip) continue;
        }

        final contestantName = data['studentName'] ?? '';
        final code = data['studentId'] ?? '';
        Map<String, double> judgeScores = {};
        double overall = 0;

        //  Dynamically detect judges:
        for (var entry in data.entries) {
          final key = entry.key;
          final value = entry.value;

          // skip obvious non-judge fields automatically
          if ([
            "studentName",
            "studentId",
            "episodeId",
            "episodeTitle",
            "level",
            "zone",
            "region",
            "photoUrl",
            "status",
            "criteriatotal",
            "scores",
            "timestamp"
          ].contains(key)) continue;

          if (value is Map && value.containsKey("totalScore")) {
            final score = _toInt(value["totalScore"]);
            judgeScores[key] = score;
            allJudges.add(key);
            overall += score;
          }
        }

        rows.add({
          "contestant": contestantName,
          "code": code,
          "judges": judgeScores,
          "overall": overall,
          "region": data['region'] ?? "",
          "zone": data['zone'] ?? "",
          "level": data['level'] ?? "",
          "episode": data['episodeId'] ?? "",
        });

        // distinct meta row for grouping
        final metaKey =
            "${data['region']}-${data['zone']}-${data['level']}-${data['episodeId']}";
        if (!seenMeta.contains(metaKey)) {
          metaList.add({
            "region": data['region'] ?? "",
            "zone": data['zone'] ?? "",
            "level": data['level'] ?? "",
            "episode": data['episodeId'] ?? "",
          });
          seenMeta.add(metaKey);
        }
      }

      //  Update state
      tableData = rows;
      judgeColumns = allJudges.toList()..sort();
      distinctMeta = metaList ..sort((a, b) => (a['region'] ?? '').compareTo(b['region'] ?? ''));
      isLoadingjudge = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching data: $e");
      isLoadingjudge = false;
      notifyListeners();
    }
  }
  previewPDF(Map<String, String> meta) async {
    try {
      final rows = tableData
          .where(
            (row) =>
        row["region"] == (meta["region"] ?? "") &&
            row["zone"] == (meta["zone"] ?? "") &&
            row["level"] == (meta["level"] ?? "") &&
            row["episode"] == (meta["episode"] ?? ""),
      )
          .map((row) {
        return {
          "contestant": row["contestant"],
          "code": row["code"],
          "judges": row["judges"],
          "overall": row["overall"],
        };
      })
          .toList();

      //Extract judge names dynamically from first row
      final judgesFromRows = rows.isNotEmpty
          ? (rows.first["judges"] as Map<String, dynamic>).keys.toList()
          : judgeColumns;
      final regionQuery = await db.collection("regions")
          .where("name", isEqualTo: meta["region"])
          .where("episode", isEqualTo: meta["episode"])
          .where("zone", isEqualTo: meta["zone"]) .get();
      String season = '';
      String weeka = '';

      if (regionQuery.docs.isNotEmpty) {
        final regionData = regionQuery.docs.first.data();
        season = regionData["season"] ?? '';
        zone = regionData["zone"] ?? '';
        weeka = regionData["week"] ?? '';
      }
      String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}".toUpperCase();
      final printer = ScoreSheetPrinter1(
        eventTitle: 'BOOKWORM REALITY SHOW  $season'.toUpperCase(),
        subtitle: "Judge Score Sheet $weeka".toUpperCase(),
        zone: '',
        episode: meta['episode'] ?? ''.toUpperCase(),
        division: meta['level'] ?? ''.toUpperCase(),
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: rows,
        judgeColumns: judgesFromRows,
      );

      final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);

      await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,
        name: 'Score Sheet',
      );
    } catch (e, stackTrace) {
      debugPrint('Error generating PDF: $e');
      //debugPrintStack(stackTrace: stackTrace);
    }
  }
  fetchVotescoringData() async {
    try {
      isLoadingjudgevote = true;
      notifyListeners();

      final snap = await db.collection('scoringMark').get();
      final List<Map<String, dynamic>> rows = [];
      final Set<String> allJudges = {};
      final Set<String> seenMeta = {};
      final List<Map<String, String>> metaList = [];

      double maxVotes = 0;

      // First pass: find maximum vote
      for (final doc in snap.docs) {
        final data = doc.data();
        final votes = _toInt(data['votes'] ?? '0');
        if (votes > maxVotes) maxVotes = votes;
      }

      // Second pass: process rows
      for (final doc in snap.docs) {
        final data = doc.data();

        final contestantName = data['studentName'] ?? '';
        final code = data['studentId'] ?? '';
        final double votes = _toInt(data['votes'] ?? '0');
        final double criteriatotal = _toInt(data['criteriatotal'] ?? '0');

        Map<String, double> judgeScores = {};
        double totalJudgeScore = 0;

        for (var key in data.keys) {
          if (key.startsWith("scored") ||
              key == "studentName" ||
              key == "studentId" ||
              key == "episodeId" ||
              key == "episodeTitle" ||
              key == "level" ||
              key == "zone" ||
              key == "region" ||
              key == "photoUrl" ||
              key == "status" ||
              key == "criteriatotal" ||
              key == "scores" ||
              key == "votes" ||
              key == "timestamp") {
            continue;
          }

          final judgeData = data[key];
          if (judgeData is Map && judgeData.containsKey("totalScore")) {
            final score = _toInt(judgeData["totalScore"]);
            judgeScores[key] = score;
            allJudges.add(key);
            totalJudgeScore += score;
          }
        }

        // ✅ Calculate with new formula (always double for percentages)
        double judge60 = 0.0;
        if (criteriatotal > 0) {
          judge60 = (totalJudgeScore / criteriatotal) * 0.6;
        }

        double votes40 = 0.0;
        if (maxVotes > 0) {
          votes40 = (votes / maxVotes) * 0.4;
        }

        double overallTotal = judge60 + votes40;

        // ✅ Keep two decimal places consistently
        judge60 = double.parse(judge60.toStringAsFixed(2));
        votes40 = double.parse(votes40.toStringAsFixed(2));
        overallTotal = double.parse(overallTotal.toStringAsFixed(2));

        rows.add({
          "contestant": contestantName,
          "code": code,
          "judges": judgeScores,        // Map<String, int>
          "totalJudgeScore": totalJudgeScore, // int
          "criteriatotal": criteriatotal,     // int
          "votes": votes,                     // int
          "judge60": judge60,                 // double (2 decimals)
          "votes40": votes40,                 // double (2 decimals)
          "overallTotal": overallTotal,       // double (2 decimals)
          "region": data['region'] ?? "",
          "zone": data['zone'] ?? "",
          "level": data['level'] ?? "",
          "episode": data['episodeId'] ?? "",
        });

        final metaKey =
            "${data['region']}-${data['zone']}-${data['level']}-${data['episodeId']}";
        if (!seenMeta.contains(metaKey)) {
          metaList.add({
            "region": data['region'] ?? "",
            "zone": data['zone'] ?? "",
            "level": data['level'] ?? "",
            "episode": data['episodeId'] ?? "",
          });
          seenMeta.add(metaKey);
        }
      }

      tableData = rows;
      judgeColumns = allJudges.toList()..sort();
      distinctMeta = metaList;
      isLoadingjudgevote = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching data: $e");
      isLoadingjudgevote = false;
      notifyListeners();
    }
  }
  previewPDFVote(Map<String, String> meta) async {
    try {
      final rows = tableData
          .where(
            (row) =>
        row["region"] == meta["region"] &&
            row["zone"] == meta["zone"] &&
            row["level"] == meta["level"] &&
            row["episode"] == meta["episode"],
      )
          .map((row) {
        return {
          "contestant": row["contestant"],
          "judges": row["judges"],
          "overall": row["overall"],
          "votes": row["votes"],
          "judge60": row["judge60"],
          "votes40": row["votes40"],
          "Total": row["overallTotal"],
        };
      })
          .toList();
      String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}".toUpperCase();
      final printer = ScoreSheetPrinterVoteJudge(
        eventTitle: 'BOOKWORM REALITY SHOW  SEASON 2',
        subtitle: "Judge Score Sheet",
        zone: meta['zone'] ?? '',
        episode: meta['episode'] ?? '',
        division: meta['level'] ?? '',
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: rows,
        totalMarks: '120',
        judgeColumns: judgeColumns,
      );

      final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);
      final pdfUint8List = Uint8List.fromList(pdfBytes);

      await Printing.layoutPdf(
        onLayout: (_) => pdfUint8List,
        name: 'Score Sheet',
      );
    } catch (e, stackTrace) {
      debugPrint('Error generating PDF vote sheet: $e');
      // debugPrintStack(stackTrace: stackTrace);
    }
  }
  loadScores() async {
    try {
      allScores = await fetchAllScores();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error loading scores: $e');
      //debugPrintStack(stackTrace: stackTrace);
    }
  }
  fetchVotescoringDataev() async {
    isLoadingjudgevoteev = true;
    notifyListeners();

    try {
      final snapshot = await db.collection("scoringMark").get();
      contestantsev = snapshot.docs
          .map((d) => {"id": d.id, ...d.data()})
          .toList();
    } catch (e) {
      debugPrint("Error fetching scoringMark: $e");
    }
    isLoadingjudgevoteev = false;
    notifyListeners();
  }

  getfetchEpisodes() async {
    try {
      final snapshot = await db.collection("episodes").get();
      episodes = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EpisodeModel(
          time: data['timestamp'] != null
              ? DateTime.parse(data['timestamp'].toString())
              : DateTime.now(),
          totalMark: data['totalMark']?.toString(),
          cmt: data['cmt']?.toString(),
          id: doc.id,
          episodename: data['name']!.toString(),
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching episodes: $e");

    }
  }
  bool isLoadingRegions =false;
  getfetchRegions() async {
    try {
      isLoadingRegions;
      notifyListeners();
      QuerySnapshot querySnapshot;

      if (accesslevel == "Admin") {
        querySnapshot = await db
            .collection("regions")
            .where('name', isEqualTo: regionName)
            .get();
      } else if (accesslevel == "Super Admin") {
        querySnapshot = await db.collection("regions").get();
      } else {
        querySnapshot = await db
            .collection("regions")
            .where('region', isEqualTo: '')
            .get();
      }

      regionList = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        DateTime? parsedTime;
        if (data['timestamp'] != null) {
          if (data['timestamp'] is Timestamp) {
            parsedTime = (data['timestamp'] as Timestamp).toDate();
          } else {
            parsedTime = DateTime.tryParse(data['timestamp'].toString());
          }
        }

        return RegionModel(
          id: doc.id,
          regionname: data['name'] ?? '',
          season: data['season'] ?? '',
          week: data['week'] ?? '',
          zone: data['zone'] ?? '',
          episode: data['episode'] ?? '',
          time: parsedTime ?? DateTime.now(),
        );
      }).toList();
      isLoadingRegions;
      notifyListeners();
    } catch (e) {
      print("Failed to fetch regions: $e");
    }
  }
  Future<void> fetchVotescoringDataevp() async {
    isLoadingjudgevoteevp = true;
    notifyListeners();
    try {
      final snapshot = await db.collection("scoringMark").get();
      contestantsevp = snapshot.docs.map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>}).toList();
      final episodeSet = <String>{};
      for (var c in contestantsevp) {
        final ep = c["episodeId"];
        if (ep != null && ep.toString().trim().isNotEmpty) {
          episodeSet.add(ep.toString());
        }
      }
      // convert to EpisodeModel list
      episodesp = episodeSet
          .map((ep) => EpisodeModel(
        episodename: ep,
        time: DateTime.now(),
        id: '',
      ))
          .toList()
        ..sort((a, b) => a.episodename.compareTo(b.episodename));

      //debugPrint("✅ Fetch complete. Contestants: ${contestantsevp.length}, Episodes: ${episodesp.length}");
    }
    catch (e, st) {
      debugPrint("Error fetching scoringMark: $e");
    }
    isLoadingjudgevoteevp = false;
    notifyListeners();
  }
  double calculateOverallTotalp(c) {
    try {
      final contestantEpisode = c["episodeId"]?.toString();

      // default: include all
      if (_selectedEpisodes.isEmpty ||
          (contestantEpisode != null &&
              _selectedEpisodes.contains(contestantEpisode))) {
        final votes = _toIntp(c['votes']);
        final overall = _toIntp(c['overall']);
        return (overall * 0.6) + (votes * 0.4);
      }

      return 0.0;
    } catch (e, stackTrace) {
      debugPrint('Error calculating overall total: $e');
      //debugPrintStack(stackTrace: stackTrace);
      return 0.0;
    }
  }
  int _toIntp(dynamic value) {
    try {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    } catch (e) {
      debugPrint("⚠_toIntp conversion error: $e | value = $value");
      return 0;
    }
  }
  evictContestantsp( contestantIds) async {
    try {
      debugPrint("Evicting contestants: $contestantIds");
      WriteBatch batch = db.batch();

      for (var id in contestantIds) {
        final docRef = db.collection("scoringMark").doc(id);
        batch.set(docRef, {"evicted": true}, SetOptions(merge: true));
      }

      await batch.commit();
      // debugPrint("Eviction batch committed.");
      await fetchVotescoringDataevp(); // refresh UI
    } catch (e, st) {
      debugPrint("Error evicting contestants: $e");
      //debugPrint("STACKTRACE: $st");
    }
  }
  fetchAccessComponents() async {
    isLoadingAccessComponents=true;
    notifyListeners();
    try {

      final snapshot = await db
          .collection("assesscomponent")
          .orderBy("timestamp", descending: true)
          .get();

      accessComponents = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "name": data["name"] ?? "",
          "level": data["level"] ?? "",
          "totalmark": data["totalmark"] ?? "",
        };
      }).toList();
      //   print(accessComponents);
      notifyListeners();
    } catch (e) {
      print("Error fetching access components: $e");
    }finally{
      isLoadingAccessComponents = false;
      notifyListeners();
    }
  }
  updateAccessComponent(  String id, data) async {
    try {
      await db
          .collection("assesscomponent").doc(id).update(data);
      await fetchAccessComponents();
    } catch (e) {
      debugPrint("Error updating access component: $e");
    }
  }
  EvictionpreviewPDFVote2(meta) async {
    final rows = tableData2.where(
          (row) =>
      row["region"] == meta["region"] &&
          row["zone"] == meta["zone"] &&
          row["level"] == meta["level"] &&
          row["episode"] == meta["episode"],
    )
        .map((row) {
      return {
        "contestant": row["contestant"],
        "tjs": row["judges"],          // TJS
        "judge60": row["judge60"],     // 60%
        "votes": row["votes"],         // CWW
        "votes40": row["votes40"],     // 40%
        "overallTotal": row["overallTotal"], // TOTAL
      };
    })
        .toList();

    final weeks = meta['weeks'] ?? '';
    final regionquery = await db
        .collection("regions")
        .where("name", isEqualTo: meta["region"])
        .where("episode", isEqualTo: meta["episode"])
        .where("zone", isEqualTo: meta["zone"])
        .get();

    String _season = '';
    String _zone = '';
    String _week = '';

    if (regionquery.docs.isNotEmpty) {
      final regionData = regionquery.docs.first.data();
      _season = regionData["season"] ?? '';
      _zone = regionData["zone"] ?? '';
      _week = regionData["week"] ?? '';
    }
    final printer = EvictionScoreSheetPrinter(
      eventTitle: 'BOOKWORM REALITY SHOW - ${meta['region'] ?? ''}',
      subtitle: '$_season OFFICIAL EVICTION RESULTS ($_week)',
    //  zone: meta['zone'] ?? '',
      zone:  '',
      episode: meta['episode'] ?? '',
      division: meta['level'] ?? 'UPPER CATEGORY',
      logoAssetPath: 'assets/images/bookwormlogo.jpg',
      rows: rows,
    );
    String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}".toUpperCase();
    final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);
    final pdfUint8List = Uint8List.fromList(pdfBytes);
    await Printing.layoutPdf(
      onLayout: (_) => pdfUint8List,
      name: 'Eviction Results',
    );
  }
  fetchWeeklyVotescoringData() async {
    try {
      isLoadingweeklysheet = true;
      notifyListeners();

      Query scoringQuery = db.collection('scoringMark');
      if (accesslevel == "Super Admin") {
        scoringQuery = scoringQuery;
      } else if (accesslevel == "Admin") {
        scoringQuery = scoringQuery.where("region", isEqualTo: regionName);
      } else if (accesslevel == "Judge") {
        tableData1 = [];
        judgeColumns1 = [];
        weeklysheetdistinctMeta = [];
        isLoadingweeklysheet = false;
        notifyListeners();
        return;
      }

      final snap = await scoringQuery.get();
      final episodesSnap = await db.collection('episodes').get();

      final List<Map<String, dynamic>> rows = [];
      final Set<String> allJudges = {};
      final Set<String> seenMeta = {};
      final List<Map<String, String>> metaList = [];


      final Map<String, double> episodeCmtMap = {};
      for (var doc in episodesSnap.docs) {
        final data = doc.data();
        final String epName = data['name'] ?? '';
        final double cmt = _toInt(data['cmt'] ?? '0.0');
        if (epName.isNotEmpty) {
          episodeCmtMap[epName] = cmt;
         // print(episodeCmtMap[epName]);
        }
      }

      // First pass: find maximum votes per (region-zone-level-episode)
      final Map<String, double> maxVotesPerGroup = {};
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final String region = data['region'] ?? "";
        final String zone = data['zone'] ?? "";
        final String level = data['level'] ?? "";
        final String episodeId = data['episodeId'] ?? "";
        final double votes = _toInt(data['votes'] ?? '0');

        final String groupKey = "$region-$zone-$level-$episodeId";

        if (!maxVotesPerGroup.containsKey(groupKey) ||
            votes > maxVotesPerGroup[groupKey]!) {
          maxVotesPerGroup[groupKey] = votes;
        }
      }

      // Second pass: process each contestant
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final contestantName = data['studentName'] ?? '';
        final code = data['studentId'] ?? '';
        final double votes = _toInt(data['votes'] ?? '0');

        final String region = data['region'] ?? "";
        final String zone = data['zone'] ?? "";
        final String level = data['level'] ?? "";
        final String episodeId = data['episodeId'] ?? "Unknown";
        final String episodeTitle = data['episodeId'] ?? "Unknown";

        final String groupKey = "$region-$zone-$level-$episodeId";
        final double maxVotesThisGroup = maxVotesPerGroup[groupKey] ?? 0;

        Map<String, double> judgeScores = {};
        double totalJudgeScore = 0;

        for (var key in data.keys) {
          if (key == "studentName" ||
              key == "studentId" ||
              key == "episodeId" ||
              key == "episodeTitle" ||
              key == "level" ||
              key == "zone" ||
              key == "region" ||
              key == "photoUrl" ||
              key == "status" ||
              key == "scores" ||
              key == "votes" ||
              key == "timestamp" ||
              key.startsWith("scored")) {
            continue;
          }

          final judgeData = data[key];
          if (judgeData is Map) {
            final score = _toInt(judgeData["totalScore"]);
            judgeScores[key] = score;
            allJudges.add(key);

            totalJudgeScore += score;
          }
        }

        //Lookup cmt from map
        double cmt = episodeCmtMap[episodeId] ?? 0;
        // Judges part (60%)
        double judge60 = 0.0;
        if (cmt > 0) {
          judge60 = (totalJudgeScore / cmt) * 60;
        }

        // Votes part (40%) – based on region-zone-level-episode group
        double votes40 = 0.0;
        if (maxVotesThisGroup > 0) {
          votes40 = (votes / maxVotesThisGroup) * 40;
        }

        // Overall
        double overallTotal = judge60 + votes40;

        // Format to 2 decimals
        judge60 = double.parse(judge60.toStringAsFixed(2));
        votes40 = double.parse(votes40.toStringAsFixed(2));
        overallTotal = double.parse(overallTotal.toStringAsFixed(2));

        rows.add({
          "contestant": contestantName,
          "code": code,
          "judges": judgeScores,
          "TJS": totalJudgeScore,
          "cmt": cmt,
          "votes": votes,
          "judge60": judge60,
          "votes40": votes40,
          "overallTotal": overallTotal,
          "region": region,
          "zone": zone,
          "level": level,
          "episodeId": episodeId,
          "episode": episodeId,
        });

        // Distinct metadata
        final metaKey = "$region-$zone-$level-$episodeId";
        if (!seenMeta.contains(metaKey)) {
          metaList.add({
            "region": region,
            "zone": zone,
            "level": level,
            "episode": episodeId,
          });
          seenMeta.add(metaKey);
        }
      }

      tableData1 = rows;
      judgeColumns1 = allJudges.toList()..sort();
      weeklysheetdistinctMeta = metaList
        ..sort((a, b) => (a['region'] ?? '').compareTo(b['region'] ?? ''));
      isLoadingweeklysheet = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching data: $e");
      isLoadingweeklysheet = false;
      notifyListeners();
    }
  }
  weeklysheetpreviewPDFVote( meta) async {
    try {
      final rows = tableData1.where((
          row) =>
          row["region"] == meta["region"] &&
          row["zone"] == meta["zone"] &&
          row["level"] == meta["level"] &&
          row["episode"] == meta["episode"],
      )
          .toList();

      final regionQuery = await db.collection("regions")
          .where("name", isEqualTo: meta["region"])
          .where("episode", isEqualTo: meta["episode"])
          .where("zone", isEqualTo: meta["zone"])
          .get();

      String season = '';
      String zone = '';
      String weeka = '';

      if (regionQuery.docs.isNotEmpty) {
        final regionData = regionQuery.docs.first.data();
        season = regionData["season"] ?? '';
        zone = regionData["zone"] ?? '';
        weeka = regionData["week"] ?? '';
      }
      final formattedRows = rows.asMap().entries.map((entry) {
        final index = entry.key + 1; // numbering
        final row = entry.value;
        return {
          "no": index.toString(),
          "name": row["contestant"] ?? "",
          "code": row["code"] ?? "",
          "tjs": row["TJS"]?.toString() ?? "0",
          "judge60": row["judge60"]?.toString() ?? "0.0",
          "cvw": row["votes"]?.toString() ?? "0",
          "votes40": row["votes40"]?.toString() ?? "0",
          "total": row["overallTotal"]?.toString() ?? "0",
        };
      }).toList();
      String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}".toUpperCase();
      final printer = WeeklyScoreSheetPrinter(
        eventTitle: "BOOKWORM REALITY SHOW - ${meta['region'] ??''}",
        subtitle: " $season OFFICIAL RESULTS FOR  (${meta['episode'] ?? ''}) ",
       // zone: meta['zone'] ?? '',
        zone:  '',
        episode: meta['episode'] ?? '',
        division: meta['level'] ?? '',
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: formattedRows,
        totalMarks: '',
      );

      final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);
      final pdfUint8List = Uint8List.fromList(pdfBytes);

      await Printing.layoutPdf(
        onLayout: (_) => pdfUint8List,
        name: 'Score Sheet',
      );
    } catch (e, st) {
      debugPrint("Error generating PDF: $e");
      //debugPrint(st.toString());
    }
  }
  fetchBestCriteria() async {
    try {
      isLoadingjudge = true;
      notifyListeners();

      Query scoringQuery = db.collection('scoringMark');

      //Apply filters based on access level
      if (accesslevel == "Super Admin") {
        // no filter, get everything
      } else if (accesslevel == "Admin") {
        scoringQuery = scoringQuery
            .where("region", isEqualTo: regionName)
            .where("zone", isEqualTo: zone);
      } else if (accesslevel == "Judge") {
        // judge sees nothing for weekly report
        distinctMeta = [];
        isLoadingjudge = false;
        notifyListeners();
        return; // 🔹 stop here so judges get blank
      }

      final snap = await scoringQuery.get();
      final seenMeta = <String>{};
      final metaList = <Map<String, String>>[];
      final groupedScores = <String, Map<String, dynamic>>{};

      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final contestantName = data['studentName'] ?? '';
        final code = data['studentId'] ?? '';
        final metaKey =
            "${data['region'] ?? ''}-${data['zone'] ?? ''}-${data['level'] ?? ''}-${data['episodeId'] ?? ''}";

        groupedScores.putIfAbsent(metaKey, () => {
          "criteria": <String>{},
          "scores": <String, Map<String, Map<String, num>>>{},
        });

        // 🔹 Loop through judge IDs (digits only)
        for (var key in data.keys.where((k) => RegExp(r'^\d+$').hasMatch(k))) {
          final judgeData = data[key];
          if (judgeData is Map && judgeData["scores"] is Map) {
            (judgeData["scores"] as Map).forEach((criteria, value) {
              num? parsed;
              if (value is num) {
                parsed = value;
              } else {
                parsed = num.tryParse("$value");
              }

              if (parsed != null) {
                (groupedScores[metaKey]!["criteria"] as Set<String>)
                    .add(criteria);

                final scoresMap =
                groupedScores[metaKey]!["scores"] as Map<String, Map<String, Map<String, num>>>;

                final criteriaMap = scoresMap.putIfAbsent(criteria, () => {});
                final contestantMap =
                criteriaMap.putIfAbsent(contestantName, () => {});
                contestantMap[key] = parsed;
              }
            });
          }
        }

        if (seenMeta.add(metaKey)) {
          metaList.add({
            "region": data['region'] ?? '',
            "zone": data['zone'] ?? '',
            "level": data['level'] ?? '',
            "episode": data['episodeId'] ?? '',
            "metaKey": metaKey,
          });
        }
      }

      bestCriteriaData = {
        for (var e in groupedScores.entries)
          e.key: {
            "criteria": (e.value["criteria"] as Set<String>).toList(),
            "scores": e.value["scores"],
          }
      };
      // 🔹 sort by region safely
      metaList.sort((a, b) =>
          (a['region'] ?? '').compareTo(b['region'] ?? ''));
      distinctMeta = metaList;
    } catch (e) {
      debugPrint("Error fetching criteria: $e");
    } finally {
      isLoadingjudge = false;
      notifyListeners();
    }
  }
  criteriaPDF( meta, selectedCriteria,) async {
    try {
      final metaKey =
          "${meta["region"]}-${meta["zone"]}-${meta["level"]}-${meta["episode"]}";

      if (!bestCriteriaData.containsKey(metaKey)) {
        debugPrint(" No data found for $metaKey");
        return;
      }

      final criteriaData = bestCriteriaData[metaKey]!["scores"]
      as Map<String, Map<String, Map<String, num>>>;

      if (!criteriaData.containsKey(selectedCriteria)) {
        debugPrint(" Criteria $selectedCriteria not found in $metaKey");
        return;
      }

      final Map<String, Map<String, num>> contestantScores =
      criteriaData[selectedCriteria]!;

      // 🔹 Build rows
      final rows = contestantScores.entries.map((entry) {
        final contestant = entry.key.toUpperCase();
        final judgeScores = entry.value; // { judgeId: score }

        final total = judgeScores.values.fold<num>(0, (sum, v) => sum + v);

        return {
          "contestant": contestant,
          "judgeScores": judgeScores,
          "total": total,
        };
      }).toList();

      // 🔹 Collect judge columns dynamically
      final allJudgeIds = <String>{};
      for (var r in rows) {
        allJudgeIds.addAll((r["judgeScores"] as Map<String, num>).keys);
      }
      final judgeColumns = allJudgeIds.toList()..sort();

      // Fetch additional info from 'regions' collection
      final regionQuery = await db.collection("regions")
          .where("name", isEqualTo: meta["region"])
          .where("episode", isEqualTo: meta["episode"])
          .where("zone", isEqualTo: meta["zone"])
          .get();

      String season = '';
      String zone = '';
      String weekss = '';

      if (regionQuery.docs.isNotEmpty) {
        final regionData = regionQuery.docs.first.data();
        season = regionData["season"] ?? '';
        zone = regionData["zone"] ?? meta["zone"];
        week = regionData["week"] ?? '';
      }
      final printer = CriteriaPdfsheet(
        eventTitle: 'BOOKWORM REALITY SHOW $season'.toUpperCase(),
        subtitle: "$selectedCriteria $weekss".toUpperCase(),
        zone: meta['zone'] ?? ''.toUpperCase(),
        episode: meta['episode'] ?? ''.toUpperCase(),
        division: meta['level'] ?? ''.toUpperCase(),
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: rows,
        totalMarks: '',
        criteriaColumns: judgeColumns, //judge1, judge2, etc.
      );
      String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}".toUpperCase();
      final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);
      final pdfUint8List = Uint8List.fromList(pdfBytes);

      await Printing.layoutPdf(
        onLayout: (_) => pdfUint8List,
        name: 'Score Sheet - $selectedCriteria',
      );
    } catch (e, stack) {
      debugPrint("Error generating criteria PDF: $e");
      // debugPrintStack(stackTrace: stack);
    }
  }
  double _toDouble(dynamic v) {
    try {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    } catch (e) {
      debugPrint('Error converting to double: $e');
      return 0.0;
    }
  }
  fetchEvictionVotescoringData() async {
    try {
      isLoadingEvictionvote = true;
      notifyListeners();
      //final snap = await db.collection('scoringMark').get();
      Query scoringQuery = db.collection('scoringMark');
      if (accesslevel == "Super Admin") {
        scoringQuery = scoringQuery;
      } else if (accesslevel == "Admin") {
        scoringQuery = scoringQuery.where("region", isEqualTo: regionName);
      } else if (accesslevel == "Judge") {

        tableData2 = [];
        judgeColumns2 = [];
        EvictionWeeklyMeta2 = [];
        isLoadingEvictionvote = false;
        notifyListeners();
        return;
      }

      final snap = await scoringQuery.get();

      final episodesSnap = await db.collection('episodes').get();

      final List<Map<String, dynamic>> rows = [];
      final Set<String> allJudges = {};
      final Set<String> seenMeta = {};
      final List<Map<String, String>> metaList = [];

      //Build episode cmt map
      final Map<String, double> episodeCmtMap = {};
      for (var doc in episodesSnap.docs) {
        final data = doc.data();
        final String epName = data['name'] ?? '';
        final double cmt = _toInt(data['cmt'] ?? '0');
        if (epName.isNotEmpty) {
          episodeCmtMap[epName] = cmt;
        }
      }

      //1st pass: find maxVotes per (region-zone-level-episodeId)
      final Map<String, double> groupMaxVotes = {};
      for (final doc in snap.docs) {
        final data = doc.data()as Map<String, dynamic>;

        final String region = data['region'] ?? "";
        final String zone = data['zone'] ?? "";
        final String level = data['level'] ?? "";
        final String episodeId = data['episodeId'] ?? "";
        final double votes = _toInt(data['votes']);

        final String groupKey = "$region-$zone-$level-$episodeId";

        if (!groupMaxVotes.containsKey(groupKey) ||
            votes > groupMaxVotes[groupKey]!) {
          groupMaxVotes[groupKey] = votes;
        }
      }

      // process each row
      for (final doc in snap.docs) {
        final data = doc.data()as Map<String, dynamic>;

        final contestantName = data['studentName'] ?? '';
        final studentId = data['studentId'] ?? '';
        final code = data['studentId'] ?? '';
        final double votes = _toInt(data['votes']);

        final String region = data['region'] ?? "";
        final String zone = data['zone'] ?? "";
        final String level = data['level'] ?? "";
        final String episodeId = data['episodeId'] ?? "";
        final String episodeTitle = data['episodeId'] ?? "";

        Map<String, double> judgeScores = {};
        double totalJudgeScore = 0;

        for (var key in data.keys) {
          if (key.startsWith("scored") ||
              key == "studentName" ||
              key == "studentId" ||
              key == "episodeId" ||
              key == "episodeId" ||
              key == "level" ||
              key == "zone" ||
              key == "region" ||
              key == "photoUrl" ||
              key == "status" ||
              key == "criteriatotal" ||
              key == "scores" ||
              key == "votes" ||
              key == "timestamp") {
            continue;
          }

          final judgeData = data[key];
          if (judgeData is Map && judgeData.containsKey("totalScore")) {
            final score = _toInt(judgeData["totalScore"]);
            judgeScores[key] = score;
            allJudges.add(key);

            totalJudgeScore += score;
          }
        }

        // Lookup cmt from episodes
        double cmt = episodeCmtMap[episodeId] ?? 0;

        // Judges part (60%)
        double judge60 = 0.0;
        if (cmt > 0) {
          judge60 = (totalJudgeScore / cmt) * 60;
        }

        // Votes part (40%) → per (region, zone, level, episode)
        double votes40 = 0.0;
        final String groupKey = "$region-$zone-$level-$episodeId";
        final double maxVotesThisGroup = groupMaxVotes[groupKey] ?? 0;

        if (maxVotesThisGroup > 0) {
          votes40 = (votes / maxVotesThisGroup) * 40;
        }

        // Overall
        double overallTotal = judge60 + votes40;

        final String tjsStr = totalJudgeScore.toString();
        final String votesStr = votes.toString();
        final String judge60Str = judge60.toStringAsFixed(2);
        final String votes40Str = votes40.toStringAsFixed(2);
        final String overallStr = overallTotal.toStringAsFixed(2);

        //row with corrected column naming
        rows.add({
          "contestant": contestantName,
          "code": studentId,
          "judges": judgeScores,
          "TJS": tjsStr,
          "cmt": cmt.toString(),
          "60%": judge60Str,
          "CWW": votesStr,
          "40%": votes40Str,
          "TOTAL": overallStr,
          "region": region,
          "zone": zone,
          "level": level,
          "episodeId": episodeId,
          "episode": episodeId,
        });
        //Meta distinct per (region, zone, level, episode)
        final metaKey = "$region-$zone-$level-$episodeId";
        if (!seenMeta.contains(metaKey)) {
          metaList.add({
            "region": region,
            "zone": zone,
            "level": level,
            "episodeId": episodeId,
            "episode": episodeId,
          });
          seenMeta.add(metaKey);
        }
      }
      tableData2 = rows;
      judgeColumns2 = allJudges.toList()..sort();
      EvictionWeeklyMeta2 = [...metaList]
        ..sort((a, b) => a["region"]!.compareTo(b["region"]!));
      // EvictionWeeklyMeta2 = metaList;
      isLoadingEvictionvote = false;

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint("Error fetching eviction data: $e");
      // debugPrintStack(stackTrace: stackTrace);
      isLoadingEvictionvote = false;
      notifyListeners();
    }
  }
  EvictionpreviewPDFVote( meta, {selectedEpisodeIds,weeksLabel,int evictionnum = 0,}) async {
    try {
      final String? fRegion = meta["region"];
      final String? fZone = meta["zone"];
      final String? fLevel = meta["level"];
      if (fRegion == null || fZone == null || fLevel == null) {
        debugPrint("Eviction PDF: Missing essential metadata!");
        return;
      }

      // Fetch additional info from 'regions' collection
      final regionQuery = await db.collection("regions")
          .where("name", isEqualTo: meta['region'])
          .where("episode", isEqualTo: meta['episode'])
          .where("zone", isEqualTo: meta['zone'])
          .get();

      String season = '';
      String zone = '';
      String week = '';

      if (regionQuery.docs.isNotEmpty) {
        final regionData = regionQuery.docs.first.data();
        season = regionData["season"] ?? '';
        zone = regionData["zone"] ?? '';
        week = regionData["week"] ?? '';
      }

      final Set<String> selectedSet = selectedEpisodeIds?.toSet() ?? {};

      final filtered = tableData2.where((row) {
        final bool regionOk = (fRegion == null || fRegion.isEmpty)
            ? true
            : row["region"] == fRegion;
        final bool zoneOk = (fZone == null || fZone.isEmpty)
            ? true
            : row["zone"] == fZone;
        final bool levelOk = (fLevel == null || fLevel.isEmpty)
            ? true
            : row["level"] == fLevel;

        final bool episodeOk = selectedSet.isEmpty
            ? true
            : selectedSet.contains((row["episodeId"] ?? '').toString());

        return regionOk && zoneOk && levelOk && episodeOk;
      }).toList();

      final Map<String, Map<String, String>> grouped = {};

      for (final r in filtered) {
        final String sid = (r["studentId"]?.toString().trim().isNotEmpty ?? false)
            ? r["studentId"].toString()
            : (r["contestant"]?.toString().trim().isNotEmpty ?? false)
            ? r["contestant"].toString()
            : (r["code"]?.toString().trim().isNotEmpty ?? false)
            ? r["code"].toString()
            : '${r["contestant"]}_${r["episodeId"]}';


        if (!grouped.containsKey(sid)) {
          grouped[sid] = {
            "studentId": sid,
            "contestant": r["contestant"] ?? "",
            "code": r["code"] ?? "",
            "TJS": "0",
            "60%": "0.00",
            "CWW": "0",
            "40%": "0.00",
            "TOTAL": "0.00",
          };
        }

        final currentTJS = _toInt(grouped[sid]!["TJS"]);
        final current60 = _toDouble(grouped[sid]!["60%"]);
        final currentCWW = _toInt(grouped[sid]!["CWW"]);
        final current40 = _toDouble(grouped[sid]!["40%"]);
        final currentTotal = _toDouble(grouped[sid]!["TOTAL"]);

        final newTJS = currentTJS + _toInt(r["TJS"]);
        final new60 = current60 + _toDouble(r["60%"]);
        final newCWW = currentCWW + _toInt(r["CWW"]);
        final new40 = current40 + _toDouble(r["40%"]);
        final newTotal = currentTotal + _toDouble(r["TOTAL"]);

        grouped[sid]!["TJS"] = newTJS.toString();
        grouped[sid]!["60%"] = new60.toStringAsFixed(2);
        grouped[sid]!["CWW"] = newCWW.toString();
        grouped[sid]!["40%"] = new40.toStringAsFixed(2);
        grouped[sid]!["TOTAL"] = newTotal.toStringAsFixed(2);
      }

      final List<Map<String, String>> rows = grouped.values.toList()
        ..sort((a, b) =>
            _toDouble(b["TOTAL"]).compareTo(_toDouble(a["TOTAL"])));

      String finalWeeksLabel = weeksLabel ??
          filtered
              .map((e) => (e["episode"] ?? '').toString())
              .where((s) => s.isNotEmpty)
              .toSet()
              .join("+");
      final subtitleText = evictionnum == 0
          ? '$season OFFICIAL RESULTS ($finalWeeksLabel)'.toUpperCase()
          : '$season OFFICIAL EVICTION RESULTS ($finalWeeksLabel)'.toUpperCase();
      final printer = EvictionScoreSheetPrinter(
        eventTitle: 'BOOKWORM REALITY SHOW - ${meta['region'] ?? ''}',
        subtitle: subtitleText,
        division: meta['level'] ?? '',
        logoAssetPath: 'assets/images/bookwormlogo.jpg',
        rows: rows,
        zone: meta['zone'],
        highlightBottom: evictionnum,
        episode: selectedEpisodeIds?.isEmpty ?? true ? null :finalWeeksLabel.toUpperCase(),
      );
      String doctitle="${meta['region']}_${meta['level']}_${meta['episode']}_Evic".toUpperCase();
      final pdfBytes = await printer.generatePdf(PdfPageFormat.a4,doctitle);
      final pdfUint8List = Uint8List.fromList(pdfBytes);

      await Printing.layoutPdf(
        onLayout: (_) => pdfUint8List,
        name: 'Eviction Results',
      );
    } catch (e, stackTrace) {
      print('Error generating eviction PDF: $e');
      // print(stackTrace);
    }
  }
  calculateCriteriaTotal( keys) {
    try {
      int sum = 0;
      for (final key in keys) {
        final matchingComponent = accessComponents.firstWhere(
              (comp) => comp['name'] == key,
          orElse: () => {},
        );
        if (matchingComponent.isNotEmpty) {
          final totalMark = int.tryParse(matchingComponent['totalmark']?.toString() ?? '0') ?? 0;
          sum += totalMark;
        }
      }
      criteriaTotal = sum;
      notifyListeners();
    } catch (e) {
      print('Error calculating criteria total: $e');
      criteriaTotal = 0;
      notifyListeners();
    }
  }

  Future<void> fetchContestantInfo(String contestantId) async {
    contestantLoading = true;
    //final a ="w55";
    notifyListeners();
    try {
      final snap = await db.collection('contestant').doc(contestantId).get();
      if (!snap.exists) {
        contestantInfo = null;
        return;
      }

      final data = Map<String, dynamic>.from(snap.data() ?? {});
      data["id"] = snap.id;
      final rawRegion = (data["region"] ?? "").toString().trim();
      Map<String, dynamic>? rData;

      if (rawRegion.isNotEmpty) {
        final q = await db.collection("regions").where("id", isEqualTo: rawRegion).limit(1).get();
        if (q.docs.isNotEmpty) {
          rData = Map<String, dynamic>.from(q.docs.first.data());
        } else {
          final q2 = await db.collection("regions").where("name", isEqualTo: rawRegion).limit(1).get();
          if (q2.docs.isNotEmpty) {
            rData = Map<String, dynamic>.from(q2.docs.first.data());
          }
        }
      }
      if (rData != null) {
        data["regionName"] = rData["name"] ?? rawRegion;
        for (final f in const ["episode", "week", "season", "zone"]) {
          final v = rData[f];
          if (v != null && v.toString().isNotEmpty) {
            data[f] = v;
          } else {
            debugPrint("$f missing in region doc for '$rawRegion'");
          }
        }
      } else {
        debugPrint("No matching region found for '$rawRegion'");
      }

      contestantInfo = data;
      await db.collection('contactinfo').doc(contestantId).set({
        "contestantId": contestantId,
        ...data,
        "savedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e, st) {
      debugPrint("Error fetching contestant info: $e");
      //debugPrintStack(stackTrace: st);
      contestantInfo = null;
    } finally {
      contestantLoading = false;
      notifyListeners();
    }
  }
  Future<void> cfetchJudges() async {
    try {
      QuerySnapshot querySnapshot;
      if(accesslevel=="Admin")
      {
        querySnapshot = await db.collection('staff').where('accessLevel', isEqualTo: 'Judge').where('region',isEqualTo: regionName).get();

      }
      else if(accesslevel=="Super Admin"){
        querySnapshot = await db.collection('staff').where('accessLevel', isEqualTo: 'Judge').get();

      }
      else{
        querySnapshot = await db.collection('staff').where('accessLevel', isEqualTo: 'Judge').where('region',isEqualTo: "").get();

      }
      /*
      contestantJudges = querySnapshot.docs.map((doc) {
        //final data = doc.data();
        return {
          "id": doc.id,
          "name": doc["name"] ?? "",
          "phone": doc["phone"] ?? "",
          "email": doc["email"] ?? "",
          "region": doc["region"] ?? "",
          "level": doc["level"] ?? "",
          "zone": doc["zone"] ?? "",
        };
      }).toList();
      */
      if (querySnapshot.docs.isEmpty) {
        // ✅ Explicitly clear if no judges
        contestantJudges = [];
      } else {
        contestantJudges = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "name": doc["name"] ?? "",
            "phone": doc["phone"] ?? "",
            "email": doc["email"] ?? "",
            "region": doc["region"] ?? "",
            "level": doc["level"] ?? "",
            "zone": doc["zone"] ?? "",
          };
        }).toList();
      }
    }
    catch (e)
    {
      contestantJudges = [];
      debugPrint("Error fetching judges: $e");
    }
    notifyListeners();
  }
  Future<void> fetchComponents() async {
    try {
      final snap = await db.collection('components').get();
      contestantComponents = snap.docs.map((d) => {
        "name": d['name'],
        "totalmark": d['totalmark'],
      }).toList();
    } catch (e) {
      contestantComponents = [];
      debugPrint("Error fetching components: $e");
    }
    notifyListeners();
  }
  saveScoring({contestantId,contestant,episodeId,episodeTitle,selectedJudges,selectedComponents,}) async {
    contestantSaving = true;
    notifyListeners();
    try {
      final String selectedZone = contestant["zone"] ?? "";
      final String selectedRegion = contestant["region"] ?? "";
      final String docId = "$contestantId$seasonName$episodeId";
      final batch = db.batch();
      final scoreRef = db.collection('scoringMark').doc(docId.trim());
      final scoreSnap = await scoreRef.get();
      // 🔹 Initial scores map
      final Map<String, String> initialScores = {};
      for (var comp in selectedComponents) {
        initialScores[comp['name']] = "0";
      }
      final studentId = contestant["studentId"] ?? contestantId;
      final studentName = contestant["studentName"] ?? contestant["name"] ?? "";
      if (scoreSnap.exists) {
        //Overwrite judge’s section completely
        batch.update(scoreRef, {
          'scored$selectedJudges': "no",
          '$selectedJudges': {
            'judgeName': selectedJudges,
            'judgeZone': selectedZone,
            'judgeRegion': selectedRegion,
            'scores': initialScores,
            'timestamp': FieldValue.serverTimestamp(),
            'totalScore': '0',
          },
        });
      } else {
        // 🔹 Insert fresh doc
        batch.set(scoreRef, {
          'episodeId': episodeTitle,
          'episodeTitle': episodeTitle,
          'studentId': studentId,
          'studentName': studentName,
          'level': contestant['level'] ?? "",
          'photoUrl': contestant.containsKey('photoUrl') ? contestant['photoUrl'] : '',
          'zone': selectedZone,
          'region': selectedRegion,
          'scored$selectedJudges': "no",
          '$selectedJudges': {
            'judgeName': selectedJudges,
            'judgeZone': selectedZone,
            'judgeRegion': selectedRegion,
            'scores': initialScores,
            'timestamp': FieldValue.serverTimestamp(),
            'totalScore': 0,
          },
        });
      }
      //Commit batch for single contestant
      await batch.commit();
      //debugPrint("✅ Saved scoring for contestant: $docId");
    } catch (e) {
      debugPrint("Error saving scoring: $e");
    }
    finally {
      contestantSaving = false;
      notifyListeners();
    }
  }
  Future<LevelModel?> fetchRegionById(String docId) async {
    try {
      final doc = await db.collection("regions").doc(docId).get();
      if (doc.exists) {
        return LevelModel.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint("Error fetching region by ID: $e");
    }
    return null;
  }
  Future<void> fetchJudgeScores(Map<String, dynamic> judgeInfo) async {
    isLoadingScores = true;
    notifyListeners();

    try {
      final snapshot = await db
          .collection('scoringMark')
          .where('region', isEqualTo: judgeInfo['region'])
          .where('episodeId', isEqualTo: judgeInfo['episode'])
          .where('level', isEqualTo: judgeInfo['selectedLevel'])
          .get();

      final Set<String> allCriteria = {};
      final List<Map<String, String>> rows = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final judgeKey = judgeInfo['judge'];

        if (data.containsKey(judgeKey) && data[judgeKey] is Map) {
          final scoreMap = Map<String, dynamic>.from(data[judgeKey]);
          final scores = Map<String, dynamic>.from(scoreMap['scores'] ?? {});
          final name = data['studentName']?.toString() ?? '';

          for (final k in scores.keys) {
            if (k != "totalScore") allCriteria.add(k);
          }

          double total = 0;
          final Map<String, String> row = {"name": name};

          for (final c in allCriteria) {
            final val = double.tryParse(scores[c]?.toString() ?? '0') ?? 0;
            total += val;
            row[c] = val.toStringAsFixed(1);
          }

          row["total"] = total.toStringAsFixed(1);
          row["docId"] = doc.id;
          rows.add(row);
        }
      }

      criteriaOrder = allCriteria.toList()..sort();
      judgeScoreRows = rows;
    } catch (e) {
      debugPrint("Error fetching judge scores: $e");
    } finally {
      isLoadingScores = false;
      notifyListeners();
    }
  }
  void toggleSelection(String docId, bool selected) {
    if (selected) {
      selectedDocIds.add(docId);
    } else {
      selectedDocIds.remove(docId);
    }
    notifyListeners();
  }
  clearSelection() {
    selectedDocIds.clear();
    notifyListeners();
  }
  deleteContestantScore(String docId,String judgeid) async {
    try {
      final docSnapshot = await db.collection('scoringMark').doc(docId).get();
      if (!docSnapshot.exists) {

        debugPrint("Document $docId not found.");
        return;
      }
      final jid=judgeid.toString();
      if (docSnapshot.exists && docSnapshot.data()?['scored${jid}'] == "yes" || docSnapshot.data()?['scored${jid}'] == "no") {
        final originalData = docSnapshot.data();
        await db.collection('deletedScores').doc(docId).set({
          ...originalData!,
          'deletedBy': phone, // optional audit field
          'deletedAt': FieldValue.serverTimestamp(), // optional audit field
        });


        //await db.collection('scoringMark').doc(docId).delete();

        // 4️⃣ Update local state
        judgeScoreRows.removeWhere((row) => row['docId'] == docId);
        notifyListeners();

        debugPrint("✅ Score for $docId backed up and deleted.");
        return;
      }

    } catch (e) {
      debugPrint("Error deleting score: $e");
    }
  }
  deleteJudgeScoreFromDoc({ docId, judgeId,  }) async { final docRef = db.collection('scoringMark').doc(docId);
  final docSnapshot = await docRef.get();

  if (!docSnapshot.exists) return;

  final data = docSnapshot.data();
  final judgeKey = judgeId.toString();
  final scoredKey = 'scored$judgeKey';

  final hasJudgeScore = data?.containsKey(judgeKey) == true;
  final hasScoredFlag = data?.containsKey(scoredKey) == true;

  if (hasJudgeScore || hasScoredFlag) {

    final backupData = {
      'contestantId': data?['studentId'],
      'studentName': data?['studentName'],
      'region': data?['region'],
      'episodeId': data?['episodeId'],
      'level': data?['level'],
      'judgeId': judgeKey,
      'judgeScores': data?[judgeKey],
      'deletedBy': phone,
      'deletedAt': FieldValue.serverTimestamp(),
    };

    await db.collection('deletedScores').add(backupData);

    // 2️⃣ Remove judge-specific fields from original doc
    // await docRef.update({
    //   judgeKey: FieldValue.delete(),
    //   scoredKey: FieldValue.delete(),
    // });
    judgeScoreRows.removeWhere((row) => row['docId'] == docId);
    notifyListeners();
    debugPrint("Deleted judge score for $judgeKey from $docId");
  } else {
    debugPrint(" No judge score found for $judgeKey in $docId");
  }


  }
  deleteSelectedScores(String judgeId, judgeInfo) async {
    final toDelete = selectedDocIds.toList();
    for (final docId in toDelete) {
      await deleteJudgeScoreFromDoc(docId: docId, judgeId: judgeId,);
    }
    clearSelection();
  }


  getjname(String phone) async {
    try {
      final snapshot = await db
          .collection("staff")
          .where("phone", isEqualTo: phone)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        judgeNames[phone] = snapshot.docs.first.data()["name"] as String?;
      } else {
        judgeNames[phone] = null;
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching judge name: $e");
      judgeNames[phone] = null;
      notifyListeners();
    }
  }
  getJudgeName(phone) {
    return judgeNames[phone];
  }
  clearContestant() {
    contestantInfo = null;
    notifyListeners();
  }


  Future<void> saveJudgeSetupMulti({
    required List<String> selectedJudges,
    required String selectedZone,
    required String selectedRegion,
    required String episodeId,
    required season,
    required List<String> selectedLevels,
    required List<ComponentModel> selectedComponents,
    bool blockIfAnyJudgeHasScored = true,
  }) async {
    savingSetup = true;
    notifyListeners();

    //final String season = (seasonName ?? '').toString();
    const int _batchLimit = 450;

    try {
      if (selectedJudges.isEmpty) throw Exception('No judges selected.');
      if (selectedLevels.isEmpty) throw Exception('No levels selected.');
      if (episodeId.trim().isEmpty) throw Exception('Episode ID is required.');

      // normalize components safely
      final List<ComponentModel> comps = selectedComponents.map<ComponentModel>((m) {
        if (m is ComponentModel) return m;
        if (m is Map<String, dynamic>) return ComponentModel.fromMap(m as Map<String, dynamic>);
        throw Exception("Unsupported component type: ${m.runtimeType}");
      }).toList();

      // build initial scores
      final Map<String, String> initialScores = {
        for (final c in comps) c.name: "0"
      };

      final String criteriaTotalStr = comps.fold<int>(
        0,
            (sum, c) => sum + int.tryParse(c.totalMark)!,
      ).toString();

      // 🔹 PRE-CHECK (block if any judge has scored before)
      if (blockIfAnyJudgeHasScored) {
        final conflicted = await findJudgesWhoAlreadyScored(
          episodeId: episodeId,
          zone: selectedZone,
          region: selectedRegion,
          levels: selectedLevels,
          judgeIds: selectedJudges,
        );
        if (conflicted.isNotEmpty) {
          throw Exception(
            'Setup blocked. These judge(s) already entered marks: ${conflicted.join(", ")}',
          );
        }
      }

      // 🔹 PREVENT DUPLICATES: check judgeSetup collection
      for (final judgeId in selectedJudges) {
        final duplicateCheck = await db
            .collection('judgeSetup')
            .where('judgeId', isEqualTo: judgeId)
            .where('zone', isEqualTo: selectedZone)
            .where('region', isEqualTo: selectedRegion)
            .where('episodeId', isEqualTo: episodeId)
            .where('levels', arrayContainsAny: selectedLevels)
            .limit(1)
            .get();

        if (duplicateCheck.docs.isNotEmpty) {
          throw Exception(
            'Judge $judgeId is already set up for this region, zone, level, and episode.',
          );
        }
      }

      // 🔹 1. Insert scoringMark docs first
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        final QuerySnapshot contestantSnap = await db
            .collection('contestant')
            .where('zone', isEqualTo: selectedZone)
            .where('region', isEqualTo: selectedRegion)
            .where('level', whereIn: selectedLevels)
            .where('status', isNotEqualTo: 'evicted')
            .get();

        if (contestantSnap.docs.isEmpty) {
          throw Exception('No contestants found for selected filters.');
        }

        for (final contestantDoc in contestantSnap.docs) {
          final data = contestantDoc.data() as Map<String, dynamic>;
          final String studentId = contestantDoc.id;
          final String studentName = (data['name'] ?? '').toString();
          final String studentLevel = (data['level'] ?? '').toString();
          final String photoUrl = (data['photoUrl'] ?? '').toString();

          // per-judge blocks
          final Map<String, dynamic> judgeSections = {};
          for (final judgeId in selectedJudges) {
            judgeSections[judgeId] = {
              "criteriatotal": criteriaTotalStr,
              "scores": initialScores,
              "status": "1",
              "timestamp": FieldValue.serverTimestamp(),
              "totalScore": "0",
            };
            judgeSections["scored$judgeId"] = "no";
            judgeSections["total$judgeId"] = "0";
          }

          final Map<String, dynamic> scoringDoc = {
            "episodeId": episodeId,
            "studentId": studentId,
            "studentName": studentName,
            "level": studentLevel,
            "photoUrl": photoUrl,
            "zone": data['zone'],
            "region": data['region'],
            "season": season,
            "votes": '',
            "timestamp": FieldValue.serverTimestamp(),
            ...judgeSections,
          };

          final String scoringDocId = '$studentId$season$episodeId';
          final DocumentReference scoreRef =
          db.collection('scoringMark').doc(scoringDocId);

          batch.set(scoreRef, scoringDoc, SetOptions(merge: true));
          writes++;

          if (writes >= _batchLimit) {
            await batch.commit();
            batch = db.batch();
            writes = 0;
          }
        }

        if (writes > 0) await batch.commit();
      }

      // 🔹 2. Insert judgeSetup docs
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        for (final judgeId in selectedJudges) {
          final String judgeSetupId = '$judgeId$season$episodeId';
          final DocumentReference judgeSetupRef =
          db.collection('judgeSetup').doc(judgeSetupId);

          final judgeSetup = JudgeSetup(
            judgeId: judgeId,
            zone: selectedZone,
            region: selectedRegion,
            episodeId: episodeId,
            components: comps,
            complete: "no",
          );

          batch.set(
            judgeSetupRef,
            {
              ...judgeSetup.toJson(),
              "season": season,
              "levels": selectedLevels,
              "episode": episodeId,
            },
            SetOptions(merge: true),
          );
          writes++;
          final DocumentReference staffRef =
          db.collection('staff').doc(judgeId);
          batch.set(
            staffRef,
            {
              "episode": episodeId,
             // "zone": selectedZone,
            //  "region": selectedRegion,
             // "season": season,
            //  "active": true,
              "updatedAt": FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
          writes++;

          if (writes >= _batchLimit) {
            await batch.commit();
            batch = db.batch();
            writes = 0;
          }
          if (writes >= _batchLimit) {
            await batch.commit();
            batch = db.batch();
            writes = 0;
          }
        }

        if (writes > 0) await batch.commit();
      }
    } catch (e, stack) {
      debugPrint('Error in saveJudgeSetupMulti: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    } finally {
      savingSetup = false;
      notifyListeners();
    }
  }

  findJudgesWhoAlreadyScored({episodeId,zone,region,levels,judgeIds,}) async {
    final conflicted = <String>{};
    final QuerySnapshot snap = await db
        .collection('scoringMark')
        .where('episodeId', isEqualTo: episodeId)
        .where('zone', isEqualTo: zone)
        .where('region', isEqualTo: region)
        .where('level', whereIn: levels)
        .get();

    for (final doc in snap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      for (final judgeId in judgeIds) {
        final String scoredKey = 'scored$judgeId';
        if (data[scoredKey] == 'yes') {
          conflicted.add(judgeId);
        }
      }
    }

    return conflicted.toList();
  }

  Future<void> saveJudgeSetupForSelectedContestants({
    required List<String> selectedJudges,
    levels,
    required List<Map<String, dynamic>> selectedContestants,
    required List<ComponentModel> selectedComponents,
  }) async {  contestantSaving = true;    notifyListeners();    const int _batchLimit = 450;    try {      if (selectedJudges.isEmpty) throw Exception("No judges selected.");
      if (selectedContestants.isEmpty) throw Exception("No contestants selected.");

      // normalize components
      final comps = selectedComponents.map<ComponentModel>((m) {
        if (m is ComponentModel) return m;
        if (m is Map<String, dynamic>) return ComponentModel.fromMap(m as Map<String, dynamic>);
        throw Exception("Unsupported component type: ${m.runtimeType}");
      }).toList();

      final Map<String, String> initialScores = {
        for (final c in comps) c.name: "0"
      };

      final String criteriaTotalStr = comps.fold<int>(
        0,
            (sum, c) => sum + int.tryParse(c.totalMark)!,
      ).toString();

      int writes = 0;
      WriteBatch batch = db.batch();

      for (final contestant in selectedContestants) {
        final String studentId = contestant["id"];
        final String studentName = (contestant["name"] ?? "").toString();
        final String studentLevel = (contestant["level"] ?? "").toString();
        final String photoUrl = (contestant["photoUrl"] ?? "").toString();
        final String region = (contestant["region"] ?? "").toString();
        final String zone = (contestant["zone"] ?? "").toString();
        final String season = (contestant["season"] ?? "").toString();
        final String episodeId = (contestant["episode"] ?? "").toString();
        final String week = (contestant["week"] ?? "").toString();

        // if (episodeId.isEmpty || season.isEmpty) {
        //   throw Exception("Missing episode/season info for contestant $studentId");
        // }

        // check if contestant already exists
        final scoringDocId = "$studentId$season$episodeId";
        final scoreRef = db.collection("scoringMark").doc(scoringDocId);
        final scoreSnap = await scoreRef.get();

        if (scoreSnap.exists) {
          final existing = scoreSnap.data() as Map<String, dynamic>;
          // If any judge already scored, block
          bool hasScores = selectedJudges.any(
                (j) => existing["scored$j"]?.toString() == "yes",
          );
          if (hasScores) {
            throw Exception("Marks already entered for contestant $studentId.");
          }
        }

        // duplicate judge setup prevention
        for (final judgeId in selectedJudges) {
          final judgeSetupId = "$judgeId$season$episodeId";
          final judgeSetupRef = db.collection("judgeSetup").doc(judgeSetupId);
          final judgeSnap = await judgeSetupRef.get();

          if (!judgeSnap.exists) {
            //create new judgeSetup if not exist
            final judgeSetup = JudgeSetup(
              judgeId: judgeId,
              zone: zone,
              region: region,
              episodeId: episodeId,
              components: comps,
              complete: "no",
              levels: levels,
            );

            batch.set(judgeSetupRef, {
              ...judgeSetup.toJson(),
              "season": season,
              "week": week,
              "createdAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            final DocumentReference staffRef =
            db.collection('staff').doc(judgeId);
            batch.set(
              staffRef,
              {
                "episode": episodeId,
               // "zone": selectedZone,
              //  "region": selectedRegion,
              //  "season": season,
                "active": true,
                "updatedAt": FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true),
            );
            writes++;
          }
        }


        final Map<String, dynamic> judgeSections = {};
        for (final judgeId in selectedJudges) {
          judgeSections[judgeId] = {
            "criteriatotal": criteriaTotalStr,
            "scores": initialScores,
            "status": "1",
            "timestamp": FieldValue.serverTimestamp(),
            "totalScore": "0",
          };
          judgeSections["scored$judgeId"] = "no";
          judgeSections["total$judgeId"] = "0";
        }

        final Map<String, dynamic> scoringDoc = {
          "episodeId": episodeId,
          "studentId": studentId,
          "studentName": studentName,
          "level": studentLevel,
          "photoUrl": photoUrl,
          "zone": zone,
          "region": region,
          "season": season,
          "week": week,
          "votes":'',
          "timestamp": FieldValue.serverTimestamp(),
          ...judgeSections,
        };

        batch.set(scoreRef, scoringDoc, SetOptions(merge: true));
        writes++;

        if (writes >= _batchLimit) {
          await batch.commit();
          batch = db.batch();
          writes = 0;
        }
      }

      if (writes > 0) await batch.commit();
    } catch (e, stack) {
      debugPrint("Error in saveJudgeSetupForSelectedContestants: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    } finally {
      contestantSaving = false;
      notifyListeners();
    }
  }
  Future<void> deleteRegion(String docId) async {
    try {
      await db.collection("regions").doc(docId).delete();
      regionList.removeWhere((r) => r.id == docId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting region: $e");
    }
  }
  deletedocument( collection,  id) async {
    try {
      getfetchEpisodes();
      await db.collection(collection).doc(id).delete();
      notifyListeners();
    } catch (e) {
      print("Failed to delete from $collection: $e");
    }
  }

  // deleteJudge(judgeId,season,episode,zone,region,level) async {
  //   deletingJudge = true;
  //   notifyListeners();
  //   try {
  //     final judgeSetupId = '$judgeId$season$episode';
  //
  //     final scoringQuery = await db
  //         .collection('scoringMarkf')
  //         .where('season', isEqualTo: season)
  //         .where('episodeId', isEqualTo: episode)
  //         .where('zone', isEqualTo: zone)
  //         .where('region', isEqualTo: region)
  //         .where('level', isEqualTo: level)
  //         .get();
  //
  //     WriteBatch batch = db.batch();
  //     bool hasUpdates = false;
  //     for (final doc in scoringQuery.docs) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       final updates = <String, dynamic>{};
  //       // 🔹 Remove judge map
  //       if (data.containsKey(judgeId)) {
  //         updates[judgeId] = FieldValue.delete();
  //       }
  //       final scoredKey = 'scored$judgeId';
  //       if (data.containsKey(scoredKey)) {
  //         updates[scoredKey] = FieldValue.delete();
  //       }
  //       if (updates.isNotEmpty) {
  //         batch.update(doc.reference, updates);
  //         hasUpdates = true;
  //       }
  //     }
  //
  //     if (hasUpdates) {
  //       await batch.commit();
  //     }
  //     await db.collection('judgeSetupf').doc(judgeSetupId).delete();
  //   } catch (e) {
  //     debugPrint('Error deleting judge: $e');
  //     rethrow;
  //   }
  //   finally {
  //     deletingJudge = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteJudge(judgeId,season,episode,zone,region, List<String> levels, ) async {
    fetchJudgeslist(reset: true);
    deletingJudge = true;
    notifyListeners();

    try {
      final judgeSetupId = '$judgeId$season$episode';

      bool judgeHasScored = false;
      WriteBatch batch = db.batch();

      for (final level in levels) {
        // 🔹 Fetch scoring docs for each level
        final scoringQuery = await db
            .collection('scoringMarkf')
            .where('season', isEqualTo: season)
            .where('episodeId', isEqualTo: episode)
            .where('zone', isEqualTo: zone)
            .where('region', isEqualTo: region)
            .where('level', isEqualTo: level)
            .get();

        for (final doc in scoringQuery.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final updates = <String, dynamic>{};

          final scoredKey = 'scored$judgeId';
          final totalKey = 'total$judgeId';

          // 🔍 Check if judge has already scored
          if (data[scoredKey] == "yes") {
            judgeHasScored = true;
            debugPrint("❌ Judge $judgeId already scored for student ${data['studentId']}");
            break;
          }

          // ✅ Mark fields for removal
          if (data.containsKey(scoredKey)) updates[scoredKey] = FieldValue.delete();
          if (data.containsKey(totalKey)) updates[totalKey] = FieldValue.delete();
          if (data.containsKey(judgeId)) updates[judgeId] = FieldValue.delete();

          if (updates.isNotEmpty) {
            batch.update(doc.reference, updates);
            debugPrint("🔹 Judge $judgeId marked for removal in student ${data['studentId']}");
          }
        }

        if (judgeHasScored) break; // stop checking other levels
      }

      if (judgeHasScored) {
        throw Exception("Judge $judgeId has already entered marks, cannot delete.");
      }

      // 🔹 Commit batch
      await batch.commit();
      // 🔹Delete judgeSetup entry
      await db.collection('judgeSetupf').doc(judgeSetupId).delete();

      debugPrint("Judge $judgeId fully removed.");
    } catch (e) {
      debugPrint("Error deleting judge: $e");
      rethrow;
    } finally {
      deletingJudge = false;
      notifyListeners();
    }
  }

  deleteAccessComponent(String id) async {
    try {
      await db
          .collection("assesscomponent").doc(id).delete();
      accessComponents.removeWhere((element) => element["id"] == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting access component: $e");
    }
  }
  Future<void> deleteData(String collection, String documentId) async {
    try {
      loadata();
      notifyListeners();
      await db.collection(collection).doc(documentId).delete();
      debugPrint('Document $documentId deleted from $collection.');
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
  addsex(String name) async {
    final data = {"name": name};
    await db.collection("sex").doc(name.toString()).set(data);
  }


  bool isloadingvotetest = false;
  bool isLoadingvote = false;
  int? loadingRegionId;
  List<dynamic> fetchedPolls = [];
  List<Map<String, dynamic>> regionsvote = [];
  loadata() async {
    try {

      isLoadingstafflist = true;
      notifyListeners();

      QuerySnapshot snap;

      if (accesslevel == "Super Admin") {
        snap = await db.collection('staff').get();
      }
      else if (accesslevel == "Admin") {
        snap = await db.collection('staff').where('region', isEqualTo: regionName).get();
      }
      else if (accesslevel == "Judge") {
        staffList = [];
        isLoadingstafflist = false;
        notifyListeners();
        return;
      }
      else {
        staffList = [];
        isLoadingstafflist = false;
        notifyListeners();
        return;
      }

      if (snap.docs.isEmpty) {
        print("No staff found");
        staffList = [];
        isLoadingstafflist = false;
        notifyListeners();
        return;
      }

      staffList = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Staff(
          id: doc.id,
          name: data['name'] ?? '',
          accessLevel: data['accessLevel']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          sex: data['sex']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          zone: data['zone']?.toString() ?? '',
          week: data['week']?.toString() ?? '',
          episode: data['episode']?.toString() ?? '',
          level: data['level']?.toString() ?? '',
          status: data['status']?.toString() ?? '0',
        );
      }).toList();

      isLoadingstafflist = false;
      notifyListeners();

    } catch (e) {
      print("Error loading staff: $e");
      isLoadingstafflist = false;
      notifyListeners();
    }
  }
  Future<void> fetchJudgeslist({int limit = 10, bool reset = false, bool nextPage = true,}) async {try {
    isLoadingjudgelist = true;
    notifyListeners();

    Query query = db.collection("judgeSetupf")
        .orderBy("timestamp", descending: false)
        .limit(limit);

    if (!reset && lastDocument != null && nextPage) {
      query = query.startAfterDocument(lastDocument!);
    } else if (!reset && firstDocument != null && !nextPage) {
      query = query.endBeforeDocument(firstDocument!).limitToLast(limit);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      // Save pagination cursors
      firstDocument = snapshot.docs.first;
      lastDocument = snapshot.docs.last;

      judgeList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          "name": data["name"] ?? "",
          "level": (data["levels"] is List)
              ? List<String>.from(data["levels"])
              : [data["levels"].toString()],
          "totalmark": data["totalmark"] ?? "",
          "episode": data["episode"] ?? "",
          "judge": data["judge"] ?? "",
          "region": data["region"] ?? "",
          "zone": data["zone"] ?? "",
          "season": data["season"] ?? "",
          "status": data["status"] ?? "",
          "timestamp": data["timestamp"],
          "components": data["components"] ?? [],
        };
      }).toList();
    } else {
      judgeList = [];
    }
  } catch (e) {
    debugPrint("Error fetching judges: $e");
  } finally {
    isLoadingjudgelist = false;
    notifyListeners();
  }
  }


  List availableDates = [];
  String? selectedDate;
  bool isFetchingVotes = false;
  loadAvailableDates(String regionId) async {
    isLoadingvote = true;
    notifyListeners();
    try {
      final url = "https://us-central1-bookworm-458ab.cloudfunctions.net/speakuppPollsNotify";
      // Send POST request with regionId
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"regionId": regionId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final results = data["results"] ?? [];

        //extract unique dates from date_created field
        final Set<String> dates = results
            .map<String>((r) => (r["date_created"] as String).split("T").first)
            .toSet();

        // sort by latest first
        availableDates = dates.toList()
          ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
        if (availableDates.isNotEmpty) {
          selectedDate = availableDates.first;
        }
      }

      isLoadingvote = false;
      notifyListeners();
    } catch (e) {
      print("Error loading dates: $e");
      isLoadingvote = false;
      notifyListeners();
    }
  }

  /*
  Future<void> fetchVotesByDateAndUpdate(String date) async {
    try {
      isFetchingVotes = true;
      notifyListeners();
      final url = "https://us-central1-bookworm-458ab.cloudfunctions.net/speakuppPollsNotify?date=$date";
      print("🔄 Fetching polls for date: $date");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // 🔹 Save raw JSON snapshot under rawvotes_by_date/{date}
        // await db.collection("rawvotes_by_date").doc(date).set({
        //   "createdAt": FieldValue.serverTimestamp(),
        //   ...data,
        // });

        final List results = data["results"] ?? [];

        for (var poll in results) {
          final List pollChoices = poll["poll_choices"] ?? [];

          for (var choice in pollChoices) {
            String code = (choice["short_code_text"] ?? "").toString().trim();
            String choicetext = (choice["choice_text"] ?? "").toString().trim();
            final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;
            final id = "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}";
            await db.collection("datevotes").doc(id).set({
              "id": choice["id"],
              "short_code_text": code,
              "choice_text": choicetext,
              "description": choice["description"],
              "num_of_votes": votes,
              "audio": choice["audio"],
              "image": choice["image"],
              "votedate": date,
              "result_percent": choice["result_percent"],
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            print("Saved $id (${choice['choice_text']}) with $votes votes");
          }
        }
      } else {
        print("Failed to fetch polls for $date: ${response.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
      }
    } catch (e, st) {
      print(" Error fetching polls for $date: $e");
      print(st);
    }
  }

  Future<void> fetchVotesByDateAndUpdate(String date) async {
    try {
      isFetchingVotes = true;
      notifyListeners();

      final url =
          "https://us-central1-bookworm-458ab.cloudfunctions.net/speakuppPollsNotify?date=$date";
      print("🔄 Fetching polls for date: $date");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List results = data["results"] ?? [];

        print("Found ${results.length} polls for $date");

        for (var poll in results) {
          print("Found ${poll.toString()} polls for $date");
          final String? regionName = poll["region"] ?? "Unknown";
          final String? regionId = poll["region_id"]?.toString() ?? "0";

          final List pollChoices = poll["poll_choices"] ?? [];

          for (var choice in pollChoices) {
            String code = (choice["short_code_text"] ?? "").toString().trim();
            String choicetext = (choice["choice_text"] ?? "").toString().trim();
            final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

            // Unique ID: date + choice name + region
            final id =
                "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

            if (votes > 0) {
              await db.collection("datevotess").doc(id).set({
                "id": choice["id"],
                "short_code_text": code,
                "choice_text": choicetext,
                "description": choice["description"],
                "num_of_votes": votes,
                "audio": choice["audio"],
                "image": choice["image"],
                "votedate": date,
                "region": regionName,
                "regionId": regionId,
                "result_percent": choice["result_percent"],
                "updatedAt": FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));

              print(
                  "✅ Saved $id (${choice['choice_text']}) with $votes votes for region $regionName");
            }
          }
        }
      } else {
        print("❌ Failed to fetch polls for $date: ${response.statusCode}");
      }
    } catch (e, st) {
      print("❌ Error fetching polls for $date: $e");
      print(st);
    } finally {
      isFetchingVotes = false;
      notifyListeners();
    }
  }
  */

  /*
  Future<void> fetchVotesByDateAndUpdate(String date) async {
    try {
      isFetchingVotes = true;
      notifyListeners();

      // headers
      var headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // 1️⃣ Fetch all regions first
      final regionsUrl = Uri.parse("https://www.speakupp.com/api/v1.0/all_new_polls/");
      final regionsResponse = await http.get(regionsUrl, headers: headers);

      if (regionsResponse.statusCode != 200) {
        print(" Failed to fetch regions: ${regionsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      //regions are under "results"
      final Map<String, dynamic> regionsData = json.decode(regionsResponse.body);
      final List regions = regionsData["results"] ?? [];

      print("Found ${regions.length} regions");

      //Loop through each region
      for (var region in regions) {
        final regionId = region["id"];
        final regionName = region["name"];

        print("Fetching polls for region $regionName ($regionId)");

        final pollsUrl = Uri.parse("https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/");
        final pollsResponse = await http.get(pollsUrl, headers: headers);

        if (pollsResponse.statusCode != 200) {
          print("❌ Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
          continue;
        }

        final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
        final List results = pollData["results"] ?? [];

        // 3️⃣ Filter by date_created == passed date
        final filteredResults = results.where((poll) {
          final dateCreated = (poll["date_created"] ?? "").toString().split("T").first;
          return dateCreated == date;
        }).toList();

        print("Region $regionName ($regionId) -> ${filteredResults.length} polls match date $date");

        // 4️⃣ Save each poll choice
        for (var poll in filteredResults) {
          final List pollChoices = poll["poll_choices"] ?? [];

          for (var choice in pollChoices) {
            String code = (choice["short_code_text"] ?? "").toString().trim();
            String choicetext = (choice["choice_text"] ?? "").toString().trim();
            final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

            final id = "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}";

            if(votes>0) {
              await db.collection("datevotes").doc(id).set({
                "id": choice["id"],
                "short_code_text": code ?? '',
                "choice_text": choicetext,
                "description": choice["description"],
                "num_of_votes": votes,
                "audio": choice["audio"],
                "image": choice["image"],
                "votedate": date,
                "region": regionName,
                "regionId": regionId,
                "result_percent": choice["result_percent"],
                "updatedAt": FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));

              print(
                  "✅ Saved $id (${choice['choice_text']}) with $votes votes for region $regionName");
            }
          }
        }
      }
    } catch (e, st) {
      print("Error fetching votes for $date: $e");
      print(st);
    } finally {
      isFetchingVotes = false;
      notifyListeners();
    }
  }
  */

  /*
  Future<void> fetchVotesByDateAndUpdate(String date, String selectedRegion, String episodeInt,) async {
    try {
      isFetchingVotes = true;
      notifyListeners();

      // Region mapping
      final regionMapping = {
        "Northern": 175,
        "Bono": 176,
        "Western": 177,
        "Volta": 178,
      };

      final regionId = regionMapping[selectedRegion];
      if (regionId == null) {
        print("❌ Region $selectedRegion not recognized!");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      print("🔄 Fetching polls for region $selectedRegion ($regionId) and date $date");

      final headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // Fetch polls for that region only
      final pollsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/",
      );
      final pollsResponse = await http.get(pollsUrl, headers: headers);

      if (pollsResponse.statusCode != 200) {
        print("❌ Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
      final List results = pollData["results"] ?? [];

      // Filter by date_created
      final filteredResults = results.where((poll) {
        final dateCreated = (poll["date_created"] ?? "").toString().split("T").first;
        return dateCreated == date;
      }).toList();

      print("Region $selectedRegion ($regionId) -> ${filteredResults.length} polls match date $date");

      // Save each poll choice
      for (var poll in filteredResults) {
        final List pollChoices = poll["poll_choices"] ?? [];

        for (var choice in pollChoices) {
          String code = (choice["short_code_text"] ?? "").toString().trim();
          String choicetext = (choice["choice_text"] ?? "").toString().trim();
          final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

          final id = "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

          if (votes > 0) {
            await db.collection("datevotess").doc(id).set({
              "id": choice["id"],
              "short_code_text": code,
              "choice_text": choicetext,
              "description": choice["description"],
              "num_of_votes": votes,
              "audio": choice["audio"],
              "image": choice["image"],
              "votedate": date,
              "region": selectedRegion,
              "regionId": regionId,
              "episode": episodeInt,
              "result_percent": choice["result_percent"],
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            print("✅ Saved $id (${choice['choice_text']}) with $votes votes for $selectedRegion (Ep $episodeInt)");
          }
        }
      }
    } catch (e, st) {
      print("❌ Error fetching votes for $date: $e");
      print(st);
    } finally {
      isFetchingVotes = false;
      notifyListeners();
    }
  }
*/

  /*
  Future<void> fetchVotesByDateAndUpdate( String date, String selectedRegion,  String episodeInt,      ) async {
    try {
      isFetchingVotes = true;
      notifyListeners();

      // Region mapping
      final regionMapping = {
        "Northern": 175,
        "Bono": 176,
        "Western": 177,
        "Volta": 178,
      };

      final regionId = regionMapping[selectedRegion];
      if (regionId == null) {
        print("❌ Region $selectedRegion not recognized!");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      print("🔄 Fetching polls for region $selectedRegion ($regionId) and date $date");

      final headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // 1️⃣ Fetch contestants for this region
      final contestantsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_contestants/",
      );
      final contestantsResponse = await http.get(contestantsUrl, headers: headers);

      if (contestantsResponse.statusCode != 200) {
        print("❌ Failed to fetch contestants for region $regionId: ${contestantsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> contestantsData = json.decode(contestantsResponse.body);
      final List contestants = contestantsData["results"] ?? [];

      print("✅ Found ${contestants.length} contestants for $selectedRegion");

      // 2️⃣ Fetch polls for that region only
      final pollsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/",
      );
      final pollsResponse = await http.get(pollsUrl, headers: headers);

      if (pollsResponse.statusCode != 200) {
        print("❌ Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
      final List results = pollData["results"] ?? [];

      // 3️⃣ Filter by date_created
      final filteredResults = results.where((poll) {
        final dateCreated = (poll["date_created"] ?? "").toString().split("T").first;
        return dateCreated == date;
      }).toList();

      print("Region $selectedRegion ($regionId) -> ${filteredResults.length} polls match date $date");

      // 4️⃣ Save each poll choice
      for (var poll in filteredResults) {
        final List pollChoices = poll["poll_choices"] ?? [];

        for (var choice in pollChoices) {
          String code = (choice["short_code_text"] ?? "").toString().trim();
          String choicetext = (choice["choice_text"] ?? "").toString().trim();
          final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

          // 🔎 Find matching contestantId by name_stage == choice_text
          final contestant = contestants.firstWhere(
                (c) => (c["name_stage"] ?? "").toString().trim().toLowerCase() ==
                choicetext.toLowerCase(),
            orElse: () => null,
          );

          final contestantId = contestant != null ? contestant["id"] : null;

          final id = "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

          if (votes > 0) {
            await db.collection("datevotess").doc(id).set({
              "id": choice["id"],
              "contestantId": contestantId,
              "short_code_text": code,
              "choice_text": choicetext,
              "description": choice["description"],
              "num_of_votes": votes,
              "audio": choice["audio"],
              "image": choice["image"],
              "votedate": date,
              "region": selectedRegion,
              "regionId": regionId,
              "episode": episodeInt,
              "result_percent": choice["result_percent"],
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            print(
              " Saved $id (${choice['choice_text']}) with $votes votes for $selectedRegion "
                  "(Ep $episodeInt, ContestantId: $contestantId)",
            );
          }
        }
      }
    } catch (e, st) {
      print(" Error fetching votes for $date: $e");
      print(st);
    } finally {
      isFetchingVotes = false;
      notifyListeners();
    }
  }
*/
  /*Future<void> fetchVotesByDateAndUpdate(
      String date, String selectedRegion, String episodeInt) async {
    try {
      isFetchingVotes = true;
      notifyListeners();

      // Region mapping
      final regionMapping = {
        "Northern": 175,
        "Bono": 176,
        "Western": 177,
        "Volta": 178,
      };

      final regionId = regionMapping[selectedRegion];
      if (regionId == null) {
        print("❌ Region $selectedRegion not recognized!");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      print("🔄 Fetching polls for region $selectedRegion ($regionId) and date $date");

      final headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // Fetch polls for that region only
      final pollsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/",
      );
      final pollsResponse = await http.get(pollsUrl, headers: headers);

      if (pollsResponse.statusCode != 200) {
        print("❌ Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
      final List results = pollData["results"] ?? [];

      // Filter by date_created
      final filteredResults = results.where((poll) {
        final dateCreated = (poll["date_created"] ?? "").toString().split("T").first;
        return dateCreated == date;
      }).toList();

      print("Region $selectedRegion ($regionId) -> ${filteredResults.length} polls match date $date");

      // Save each poll choice
      for (var poll in filteredResults) {
        final List pollChoices = poll["poll_choices"] ?? [];

        for (var choice in pollChoices) {
          String code = (choice["short_code_text"] ?? "").toString().trim();
          String choicetext = (choice["choice_text"] ?? "").toString().trim();
          final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

          // 🔍 Match contestant
          String? contestantId;
          try {
            final snapshot = await db
                .collection("contestants")
                .where("name_stage", isEqualTo: choicetext)
                .limit(1)
                .get();

            if (snapshot.docs.isNotEmpty) {
              contestantId = snapshot.docs.first.data()["id"];
            }
          } catch (err) {
            print("⚠️ Error fetching contestant for $choicetext: $err");
          }

          // Unique ID: date + choice + regionId
          final id = "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

          if (votes > 0) {
            await db.collection("datevotess").doc(id).set({
              "id": choice["id"],
              "contestantId": contestantId ?? "unknown",
              "short_code_text": code,
              "choice_text": choicetext,
              "description": choice["description"],
              "num_of_votes": votes,
              "audio": choice["audio"],
              "image": choice["image"],
              "votedate": date,
              "region": selectedRegion,
              "regionId": regionId,
              "episode": episodeInt,
              "result_percent": choice["result_percent"],
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            print(
                "✅ Saved $id (${choice['choice_text']}) with $votes votes for $selectedRegion (Ep $episodeInt) contestantId=$contestantId");
          }
        }
      }
    } catch (e, st) {
      print("❌ Error fetching votes for $date: $e");
      print(st);
    } finally {
      isFetchingVotes = false;
      notifyListeners();
    }
  }*/
  String progress="";
  /*
  Future<void> fetchVotesByDateAndUpdate(String date, String selectedRegion, String episodeInt,String season) async {
    try {
      print(selectedRegion);
      isFetchingVotes = true;
      notifyListeners();
      // Region mapping
      final regionMapping = {
        "Northern": 175,
        "Bono": 176,
        "Western": 177,
        "Volta": 178,
      };
      final regionId = regionMapping[selectedRegion];
      if (regionId == null) {
        progress=("Region $selectedRegion not recognized!");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }
      progress=("🔄 Fetching polls for region $selectedRegion ($regionId) and date $date");

      final headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // Fetch polls for that region only
      final pollsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/",
      );
      final pollsResponse = await http.get(pollsUrl, headers: headers);

      if (pollsResponse.statusCode != 200) {
        progress=("Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
      final List results = pollData["results"] ?? [];

      // Filter by date_created
      final filteredResults = results.where((poll) {
        final dateCreated = (poll["date_created"] ?? "").toString().split("T").first;
        return dateCreated == date;
      }).toList();

      progress=("Region $selectedRegion ($regionId) -> ${filteredResults.length} polls match date $date");

      //Preload contestants for this region
      final contestantsSnap = await db
          .collection("contestant")
          .where("region", isEqualTo: selectedRegion)
          .get();

      final contestants = contestantsSnap.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Save each poll choice
      for (var poll in filteredResults) {
        final List pollChoices = poll["poll_choices"] ?? [];

        for (var choice in pollChoices) {
          String code = (choice["short_code_text"] ?? "").toString().trim();
          String choicetext = (choice["choice_text"] ?? "").toString().trim();
          final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

          //Case-insensitive contestant match
          String? contestantId;
          for (var contestant in contestants) {
            final nameStage = (contestant["name_stage"] ?? "").toString().trim();
            if (nameStage.toLowerCase() == choicetext.toLowerCase()) {
              contestantId = contestant["id"];
              break;
            }
          }


          final id =
              "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

          String scoringid = "${contestantId?.toUpperCase()}$season$episodeInt";
          progress=("$scoringid $votes");
          notifyListeners();
          print("$scoringid $votes");
          if (votes > 0) {
            await db.collection("scoringMark").doc(scoringid).update({"vote": votes.toString()});
            await db.collection("datevotes").doc(id).set({
              "id": choice["id"],
              "contestantId": contestantId ?? "",
              "short_code_text": code,
              "choice_text": choicetext,
              "description": choice["description"],
              "num_of_votes": votes,
              "audio": choice["audio"],
              "image": choice["image"],
              "votedate": date,
              "region": selectedRegion,
              "regionId": regionId,
              "episode": episodeInt,
              "result_percent": choice["result_percent"],
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            progress=(
                "Saved $id (${choice['choice_text']}) with $votes votes for $selectedRegion (Ep $episodeInt) contestantId=$contestantId");
          }
        }
      }
      isFetchingVotes =false;
      notifyListeners();
    } catch (e, st) {
      print("Error fetching votes for $date: $e");
      //print(st);
    }
    notifyListeners();
  }
*/
  Future<void> fetchVotesByDateAndUpdate(
      String date,
      String selectedRegion,
      String episodeInt,
      String season) async {
    try {
      print(selectedRegion);
      isFetchingVotes = true;
      notifyListeners();

      // Region mapping
      final regionMapping = {
        "Northern": 175,
        "Bono": 176,
        "Western": 177,
        "Volta": 178,
      };
      final regionId = regionMapping[selectedRegion];
      if (regionId == null) {
        progress = ("Region $selectedRegion not recognized!");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      progress =
      ("🔄 Fetching polls for region $selectedRegion ($regionId) and date $date");

      final headers = {
        'Authorization': 'Token 0eee1d833ef10f885dffba7b73ec50ae2740adca',
        'Accept': 'application/json',
      };

      // Fetch polls for that region only
      final pollsUrl = Uri.parse(
        "https://www.speakupp.com/api/v1.0/all_new_polls/$regionId/get_polls/",
      );
      final pollsResponse = await http.get(pollsUrl, headers: headers);

      if (pollsResponse.statusCode != 200) {
        progress =
        ("Failed to fetch polls for region $regionId: ${pollsResponse.statusCode}");
        isFetchingVotes = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> pollData = json.decode(pollsResponse.body);
      final List results = pollData["results"] ?? [];

      // Filter by date_created
      final filteredResults = results.where((poll) {
        final dateCreated =
            (poll["date_created"] ?? "").toString().split("T").first;
        return dateCreated == date;
      }).toList();

      progress =
      ("Region $selectedRegion ($regionId) -> ${filteredResults.length} polls match date $date");

      // Preload contestants for this region
      final contestantsSnap = await db
          .collection("contestant")
          .where("region", isEqualTo: selectedRegion)
          .get();

      final contestants = contestantsSnap.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Save each poll choice
      for (var poll in filteredResults) {
        final List pollChoices = poll["poll_choices"] ?? [];

        for (var choice in pollChoices) {
          String code = (choice["short_code_text"] ?? "").toString().trim();
          String choicetext = (choice["choice_text"] ?? "").toString().trim();
          final votes = int.tryParse(choice["num_of_votes"].toString()) ?? 0;

          // Case-insensitive contestant match
          String? contestantId;
          for (var contestant in contestants) {
            final nameStage =
            (contestant["name_stage"] ?? "").toString().trim();
            if (nameStage.toLowerCase() == choicetext.toLowerCase()) {
              contestantId = contestant["id"];
              break;
            }
          }

          final id =
              "$date${choicetext.replaceAll(RegExp(r'\s+'), '').toLowerCase()}_$regionId";

          String scoringid = "${contestantId?.toUpperCase()}$season$episodeInt";
          progress = ("$scoringid $votes");
          notifyListeners();
          print("$scoringid $votes");

          if (votes > 0) {
            try {
              // ✅ Wrap in try/catch so failure won’t stop loop
              // await db
              //     .collection("scoringMark")
              //     .doc(scoringid)
              //     .update({"votes": votes.toString()});

              await db.collection("datevotes").doc(id).set({
                "id": choice["id"],
                "contestantId": contestantId ?? "",
                "short_code_text": code,
                "choice_text": choicetext,
                "description": choice["description"],
                "num_of_votes": votes,
                "audio": choice["audio"],
                "image": choice["image"],
                "votedate": date,
                "region": selectedRegion,
                "regionId": regionId,
                "episode": episodeInt,
                "result_percent": choice["result_percent"],
                "updatedAt": FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));

              progress =
              ("Saved $id (${choice['choice_text']}) with $votes votes for $selectedRegion (Ep $episodeInt) contestantId=$contestantId");
            } catch (e) {
              //  Skip this one but continue with others
              print("Skipping $scoringid due to error: $e");
              progress = ("Skipping $scoringid due to error: $e");
              notifyListeners();
              continue;
            }
          }
        }
      }

      isFetchingVotes = false;
      notifyListeners();
    } catch (e, st) {
      print("Error fetching votes for $date: $e");
      //print(st);
    }
    notifyListeners();
  }

  bool isLoadingVotes = false;
  List<Map<String, dynamic>> dataVotes = [];
  /*
  Future<void> fetchDataVotes() async {
    try {
      isLoadingVotes = true;
      notifyListeners();
      final querySnapshot =
      await db.collection("datevotes").get();

      dataVotes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": data["id"],
          "choice_text": data["choice_text"],
          "description": data["description"],
          "image": data["image"],
          "num_of_votes": data["num_of_votes"],
          "region": data["region"],
          "regionId": data["regionId"],
          "result_percent": data["result_percent"],
          "short_code_text": data["short_code_text"],
          "updatedAt": data["updatedAt"],
          "votedate": data["votedate"],
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching datavotes: $e");
    } finally {
      isLoadingVotes = false;
      notifyListeners();
    }
  }
  */
  Future<void> fetchDataVotes() async {
    try {
      isLoadingVotes = true;
      notifyListeners();

      final querySnapshot = await db.collection("datevotess").get(); // ✅ collection

      dataVotes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": data["id"],
          "contestantId": data["contestantId"], // contestantId
          "choice_text": data["choice_text"],
          "description": data["description"],
          "image": data["image"],
          "num_of_votes": data["num_of_votes"], // existing votes
          "vote": data["num_of_votes"],         // add 'vote' field
          "region": data["region"],
          "regionId": data["regionId"],
          "result_percent": data["result_percent"],
          "short_code_text": data["short_code_text"],
          "votedate": data["votedate"],
          "updatedAt": data["updatedAt"],
        };
      }).toList();
    } catch (e) {
      debugPrint("❌ Error fetching datavotes: $e");
    } finally {
      isLoadingVotes = false;
      notifyListeners();
    }
  }

}