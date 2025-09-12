import 'dart:convert';
import 'dart:io';
import 'package:ksoftsms/controller/dbmodels/termmodel.dart';
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
import 'dbmodels/departmodel.dart';
import 'dbmodels/episodeModel.dart';
import 'dbmodels/judgemodel.dart';
import 'dbmodels/levelmodel.dart';
import 'dbmodels/regionmodel.dart';
import 'dbmodels/schoolmodel.dart';
import 'dbmodels/scoremodel.dart';
import 'dbmodels/seasonModel.dart';
import 'dbmodels/staffmodel.dart';
import 'dbmodels/subjectmodel.dart';
import 'dbmodels/weekmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dbmodels/zonemodels.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Myprovider extends ChangeNotifier {
  List<TermModel> terms = [];
  List<DepartmentModel> departments = [];
  List<DepartmentModel> classdata = [];
  List<SubjectModel> subjectList = [];
  List<StudentModel> studentlist = [];
  List<SchoolModel> schoollist = [];
  List<Staff> staffList = [];
  List<RegionModel> regionList = [];
  List<ScoremodelConfig> scoreconfig = [];
  bool loadterms =false;
  bool loaddepart =false;
  bool loadclassdata =false;
  bool loadsubject =false;
  bool isLoadingRegions =false;
  bool loadStudent =false;
  bool loadschool =false;
  bool loadstaff =false;
  bool loadingsconfig = true;
  String companyid="ksoo1";
  String currentschool="lamp";





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

  List<EpisodeModel> episodesp = [];
  List<EpisodeModel> episodes = [];

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
  bool loginform = true;
  bool regform = false;
  Myprovider() {

  }
  Future<void> fetchterms() async {
    try {
      loadterms = true;
      notifyListeners();

      final snapshot = await db.collection("terms").get();

      terms = snapshot.docs.map((doc) {
        return TermModel.fromMap(doc.data(), doc.id);
      }).toList();

      loadterms = false;
      print(terms);
      notifyListeners();
    } catch (e) {
      loadterms = false;
      notifyListeners();
      print("Failed to fetch terms: $e");
    }
  }
  Future<void> fetchdepart() async {
    try {
      loaddepart = true;
      notifyListeners();
      final snapshot = await db.collection("department").get();
      departments = snapshot.docs.map((doc) {
        return DepartmentModel.fromMap(doc.data(), doc.id);
      }).toList();

      loaddepart = false;
      notifyListeners();
    } catch (e) {
      loaddepart = false;
      notifyListeners();
      print("Failed to fetch departments: $e");
    }
  }
  Future<void> fetchclass() async {
    try {
      loadclassdata = true;
      notifyListeners();
      final snapshot = await db.collection("classes").get();
      classdata = snapshot.docs.map((doc) {
        return DepartmentModel.fromMap(doc.data(), doc.id);
      }).toList();

      loadclassdata = false;
      notifyListeners();
    } catch (e) {
      loadclassdata = false;
      notifyListeners();
      print("Failed to fetch class: $e");
    }
  }
  Future<void> fetchsubjects() async {
    try {
      loadsubject = true;
      notifyListeners();
      final snapshot = await db.collection("subjects").get();
      subjectList = snapshot.docs.map((doc) {
        return SubjectModel.fromMap(doc.data(), doc.id);
      }).toList();

      loadsubject = false;
      notifyListeners();
    } catch (e) {
      loadsubject = false;
      notifyListeners();
      print("Failed to fetch class: $e");
    }
  }
  Future<void> fetchstudents() async {
    try {
      loadStudent = true;
      notifyListeners();

      final snapshot = await db.collection("students").get();

      studentlist = snapshot.docs.map((doc) {
        final data = doc.data();
        // inject Firestore docId into the map (in case it's missing)
        data['id'] = doc.id;
        return StudentModel.fromMap(data);
      }).toList();

      loadStudent = false;
      notifyListeners();
    } catch (e) {
      loadStudent = false;
      notifyListeners();
      print("Failed to fetch students: $e");
    }
  }
  Future<void> fetchschool() async {
    try {
      loadschool = true;
      notifyListeners();

      final snapshot = await db.collection("schools").get();

      schoollist = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SchoolModel.fromMap(data, doc.id);
      }).toList();

      loadschool = false;
      notifyListeners();
    } catch (e) {
      loadschool = false;
      notifyListeners();
      print("Failed to fetch schools: $e");
    }
  }
  Future<void> fetchstaff() async {
    try {
      loadstaff=true;
      notifyListeners();
      final snap = await db.collection('staff').get();
      staffList = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data, doc.id); // Use fromMap constructor
      }).toList();
      loadstaff =false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff: $e");
    }
  }
  Future<void> fetchScoreConfig() async {
    try {
      loadingsconfig = true;
      notifyListeners();
      final snap = await db.collection('scoringconfi').get();
      scoreconfig = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ScoremodelConfig.fromFirestore(data, doc.id);
      }).toList();
      loadingsconfig = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching score config: $e");
    }
  }

  Future<void> getfetchRegions() async {
    try {
      isLoadingRegions = true;
      notifyListeners();

      //fetch all regions (no restriction)
      QuerySnapshot querySnapshot = await db.collection("regions").get();

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
          time: parsedTime ?? DateTime.now(),
        );
      }).toList();

      print("Regions fetched: ${regionList.length}");

      isLoadingRegions = false;
      notifyListeners();
    } catch (e) {
      isLoadingRegions = false;
      print("Failed to fetch regions: $e");
      notifyListeners();
    }
  }
  Future<void> deleteData(String collection, String documentId) async {
    try {
      fetchstaff();
      fetchterms();
      fetchdepart();
      fetchclass();
      fetchsubjects();
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

  showform(bool show,String type){
    if(type=='login') {
      loginform = true;
      regform = false;
    }
    if(type=='signup'){
      regform = true;
      loginform = false;
    }
    notifyListeners();
  }

}