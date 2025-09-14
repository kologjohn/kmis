import 'dart:async';
import 'dart:convert';
import 'dart:core';
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

import 'dbmodels/componentmodel.dart';
import 'dbmodels/contestantsmodel.dart';
import 'dbmodels/departmodel.dart';
import 'dbmodels/episodeModel.dart';

import 'dbmodels/levelmodel.dart';
import 'dbmodels/regionmodel.dart';
import 'dbmodels/schoolmodel.dart';
import 'dbmodels/scoremodel.dart';
import 'dbmodels/scoring_mark_model.dart';
import 'dbmodels/seasonModel.dart';
import 'dbmodels/staffmodel.dart';
import 'dbmodels/subjectmodel.dart';
import 'dbmodels/teachermodel.dart';
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
  List<ComponentModel> accessComponents = [];
  bool loadterms = false;
  bool loaddepart = false;
  bool loadclassdata = false;
  bool loadsubject = false;
  bool isLoadingRegions = false;
  bool loadStudent = false;
  bool loadschool = false;
  bool loadstaff = false;
  bool loadingsconfig = true;
  String companyid = "ksoo1";
  String currentschool = "lamp";
  bool isloadcomponents=true;
  bool savingSetup = false;
  Staff? usermodel;
  List<String> staffSchoolIds=[];
  List<String> schoolnames=[];
  String schoolid = "";
  String accesslevel = "";
  String phone = "";
  String name = "";
  List<SchoolModel> schoolList = [];
  List<Staff> staffschools = [];
  String schooldomain = "kologsoftsmiscom.com";
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  bool loginform = true;
  bool regform = false;
  Myprovider() {}
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
      loadstaff = true;
      notifyListeners();
      final snap = await db.collection('staff').get();
      staffList = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data, doc.id); // Use fromMap constructor
      }).toList();
      loadstaff = false;
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
  showform(bool show, String type) {
    if (type == 'login') {
      loginform = true;
      regform = false;
    }
    if (type == 'signup') {
      regform = true;
      loginform = false;
    }
    notifyListeners();
  }

  login(String email, String password, BuildContext context) async {
    try {
      final loginhere = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (loginhere.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('useremail', email);
        final detail = await db
            .collection("staff")
            .where('email', isEqualTo: email)
            .get();
        int numberofdocs = detail.docs.length;
        final userData = detail.docs.first.data();
        usermodel = Staff.fromMap(userData, detail.docs.first.id);
        String emailTxt = usermodel?.email ?? '';
        String nameTxt = usermodel?.name ?? '';
        String roleTxt = usermodel?.accessLevel ?? '';
        String phoneTxt = usermodel?.phone ?? '';
        String schoolTxt = usermodel?.schoolname ?? '';
        String scchoolIdTxt = usermodel?.schoolId ?? '';

        prefs.setString("school", schoolTxt);
        prefs.setString("email", emailTxt);
        prefs.setString("name", nameTxt);
        prefs.setString("role", roleTxt);
        prefs.setString("phone", phoneTxt);
        prefs.setString("schoolid", scchoolIdTxt);
        if (numberofdocs > 1) {
          staffschools = detail.docs.map((doc) {
            return Staff.fromMap(doc.data(), doc.id);
          }).toList();
          prefs.setStringList("staffschools", staffschools.map((e) => e.schoolId).toList());
          prefs.setStringList("schoolnames", staffschools.map((e) => e.schoolname).toList());
          print(schoolList);
          await getdata();
          context.go(Routes.nextpage);
          notifyListeners();
        } else {
          await getdata();
          auth.currentUser!.updateDisplayName(nameTxt);

          context.go(Routes.nextpage);
          print(usermodel?.schoolId);
          print("Single user.");
          notifyListeners();
        }

        //useremail=email;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    schoolid = prefs.getString('schoolid') ?? '';
    currentschool = prefs.getString('school') ?? '';
    phone = prefs.getString('phone') ?? '';
    accesslevel = prefs.getString('role') ?? '';
    name = prefs.getString('name') ?? '';
    // staffschools is a List<Staff>, but prefs.getStringList returns List<String>
    // If you want to keep the school IDs, use a separate variable:
    staffSchoolIds = prefs.getStringList("staffschools") ?? [];
    schoolnames = prefs.getStringList("schoolnames") ?? [];
    notifyListeners();
  }
  Future<void> fetchomponents() async {
    isloadcomponents = true;
    notifyListeners();

    try {
      final snapshot = await db
          .collection("assesscomponent")
          .orderBy("timestamp", descending: true)
          .get();

      accessComponents = snapshot.docs.map((doc) {
        final data = doc.data();
        return ComponentModel.fromMap({
          ...data,
          "id": doc.id, // include id
        });
      }).toList();
    } catch (e) {
      print("Error fetching access components: $e");
    }

    isloadcomponents = false;
    notifyListeners();
  }



  Future<void> saveTeacherSetupMulti({
    required List<String> teacherIds,
    required String schoolId,
    required String academicYear,
    required String term,
    required List<DepartmentModel> levels,
    required List<SubjectModel> subjects,
    required List<ComponentModel> components,
  }) async {
    savingSetup = true;
    notifyListeners();

    const int _batchLimit = 450;

    try {
      if (teacherIds.isEmpty) throw Exception("No teachers selected.");
      if (levels.isEmpty) throw Exception("No levels selected.");
      if (subjects.isEmpty) throw Exception("No subjects selected.");
      if (academicYear.trim().isEmpty || term.trim().isEmpty) {
        throw Exception("Academic year and term are required.");
      }

      // 🔹 STEP 1: Save TeacherSetup docs
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        for (final teacherId in teacherIds) {
          final teacherSetupId = "${teacherId}_${academicYear}_$term";

          final teacherSetup = TeacherSetup(
            staffid: teacherId,
            staffname: "",
            schoolid: schoolId,
            academicyear: academicYear,
            term: term,
            levels: levels,
            subjects: subjects,
          );

          final teacherSetupRef = db.collection("teacherSetup").doc(teacherSetupId);

          batch.set(
            teacherSetupRef,
            teacherSetup.toJson(),
            SetOptions(merge: true),
          );

          writes++;
          if (writes >= _batchLimit) {
            await batch.commit();
            batch = db.batch();
            writes = 0;
          }
        }

        if (writes > 0) await batch.commit();
      }

      // 🔹 STEP 2: Create SubjectScoring docs for each student/subject
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        for (final level in levels) {
          final studentSnap = await db
              .collection("students")
              .where("schoolId", isEqualTo: schoolId)
              .where("level", isEqualTo: level.name)
              .get();

          if (studentSnap.docs.isEmpty) continue;

          for (final studentDoc in studentSnap.docs) {
            final studentData = studentDoc.data() as Map<String, dynamic>;
            final studentId = studentDoc.id;
            final studentName = studentData['name'] ?? '';
            final region = studentData['region'] ?? '';
            final photoUrl = studentData['photoUrl'] ?? '';

            for (final subject in subjects) {
              // ✅ Use your factory constructor here
              final scoring = SubjectScoring.create(
                studentId: studentId,
                studentName: studentName,
                academicYear: academicYear,
                term: term,
                level: level.name,
                region: region,
                schoolId: schoolId,
                photoUrl: photoUrl,
                subjectId: subject.id,
                components: components,
              );

              final scoringRef = db.collection("subjectScoring").doc(scoring.id);

              batch.set(
                scoringRef,
                scoring.toJson(),
                SetOptions(merge: true),
              );

              writes++;
              if (writes >= _batchLimit) {
                await batch.commit();
                batch = db.batch();
                writes = 0;
              }
            }
          }
        }

        if (writes > 0) await batch.commit();
      }
    } catch (e, stack) {
      debugPrint("❌ Error in saveTeacherSetupMulti: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    } finally {
      savingSetup = false;
      notifyListeners();
    }
  }








/*

  Future<void> saveTeacherSetupForSelectedStudents({
    required List<String> teacherIds,
    required String schoolId,
    required String academicYear,
    required String term,
    required List<DepartmentModel> levels,
    required List<SubjectModel> subjects,
    required List<ComponentModel> components,
    required List<Map<String, dynamic>> selectedStudents, // from UI
  }) async {
    contestantSaving = true;
    notifyListeners();

    const int _batchLimit = 450;

    try {
      if (teacherIds.isEmpty) throw Exception("No teachers selected.");
      if (levels.isEmpty) throw Exception("No levels selected.");
      if (subjects.isEmpty) throw Exception("No subjects selected.");
      if (selectedStudents.isEmpty) throw Exception("No students selected.");
      if (academicYear.isEmpty || term.isEmpty) {
        throw Exception("Academic year and term are required.");
      }

      // 🔹 Normalize components
      final comps = components.map<ComponentModel>((m) {
        if (m is ComponentModel) return m;
        if (m is Map<String, dynamic>) return ComponentModel.fromMap(m);
        throw Exception("Unsupported component type: ${m.runtimeType}");
      }).toList();

      // 🔹 Initial zero-scores per component
      final Map<String, String> initialScores = {
        for (final c in comps) c.name: "0"
      };

      final String criteriaTotalStr = comps.fold<int>(
        0,
            (sum, c) => sum + int.tryParse(c.totalMark)!,
      ).toString();

      int writes = 0;
      WriteBatch batch = db.batch();

      for (final student in selectedStudents) {
        final String studentId = student["id"];
        final String studentName = (student["name"] ?? "").toString();
        final String studentLevel = (student["level"] ?? "").toString();
        final String photoUrl = (student["photoUrl"] ?? "").toString();
        final String region = (student["region"] ?? "").toString();

        // 🔹 Create scoring docs for each subject
        for (final subject in subjects) {
          final scoring = SubjectScoring.create(
            studentId: studentId,
            studentName: studentName,
            academicYear: academicYear,
            term: term,
            level: studentLevel,
            region: region,
            schoolId: schoolId,
            photoUrl: photoUrl,
            subjectId: subject.id,
            components: comps,
          );

          final scoringRef = db.collection("subjectScoring").doc(scoring.id);

          // prevent overwriting scored students
          final existingSnap = await scoringRef.get();
          if (existingSnap.exists) {
            final existing = existingSnap.data() as Map<String, dynamic>;
            if (existing["scored${subject.id}"]?.toString() == "yes") {
              throw Exception("Scores already entered for $studentName in ${subject.name}.");
            }
          }

          batch.set(scoringRef, scoring.toJson(), SetOptions(merge: true));
          writes++;

          if (writes >= _batchLimit) {
            await batch.commit();
            batch = db.batch();
            writes = 0;
          }
        }
      }

      // 🔹 Ensure TeacherSetup docs exist
      for (final teacherId in teacherIds) {
        final teacherSetupId = "${teacherId}_$academicYear_$term";
        final teacherSetupRef = db.collection("teacherSetup").doc(teacherSetupId);

        final teacherSetup = TeacherSetup(
          staffid: teacherId,
          staffname: "", // TODO: lookup teacher
          schoolid: schoolId,
          academicyear: academicYear,
          term: term,
          levels: levels,
          subjects: subjects,
        );

        batch.set(
          teacherSetupRef,
          teacherSetup.toJson(),
          SetOptions(merge: true),
        );
        writes++;

        if (writes >= _batchLimit) {
          await batch.commit();
          batch = db.batch();
          writes = 0;
        }
      }

      if (writes > 0) await batch.commit();
    } catch (e, stack) {
      debugPrint("Error in saveTeacherSetupForSelectedStudents: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    } finally {
      contestantSaving = false;
      notifyListeners();
    }
  }
*/

}
