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
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

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
<<<<<<< HEAD
=======

>>>>>>> a0ee9b7f41095e797406fa169f58c05135908b9c
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
<<<<<<< HEAD
=======

>>>>>>> a0ee9b7f41095e797406fa169f58c05135908b9c
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
<<<<<<< HEAD
=======

>>>>>>> a0ee9b7f41095e797406fa169f58c05135908b9c
}