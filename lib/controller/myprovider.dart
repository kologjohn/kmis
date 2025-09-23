import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ksoftsms/controller/dbmodels/termmodel.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/academicyrmodel.dart';
import 'dbmodels/classmodel.dart';
import 'dbmodels/componentmodel.dart';
import 'dbmodels/contestantsmodel.dart';
import 'dbmodels/departmodel.dart';

import 'dbmodels/regionmodel.dart';
import 'dbmodels/schoolmodel.dart';
import 'dbmodels/scoremodel.dart';
import 'dbmodels/scoring_mark_model.dart';
import 'dbmodels/staffmodel.dart';
import 'dbmodels/subjectmodel.dart';
import 'dbmodels/teachermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginprovider.dart';
class Myprovider extends LoginProvider {
  List<TermModel> terms = [];
  List<AcademicModel> academicyears = [];
  List<DepartmentModel> departments = [];
  List<ClassModel> classdata = [];
  List<SubjectModel> subjectList = [];
  List<StudentModel> studentlist = [];
  List<Staff> stafflist = [];
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
  bool isloadcomponents=true;
  bool savingSetup = false;
  bool loginform = true;
  bool regform = false;
  bool loadacademicyear =false;
  XFile? imagefile;
  String imageUrl = "";
  int studentcount_in_school = 0;
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
        return ClassModel.fromMap(doc.data(), doc.id);
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
  Future<void> fetchstaff() async {
    try {
      loadstaff = true;
      notifyListeners();
      //final snap = await db.collection('staff').where('schoolId', isEqualTo: schoolid).get();
      final snap = await db.collection('staff').get();
      stafflist = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data, doc.id);
      }).toList();
      loadstaff = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff: $e");
    }
  }
  Future<void> fetchacademicyear() async {
    try {
      loadacademicyear = true;
      notifyListeners();

      final snapshot = await db
          .collection("academicyears")
          .where("schoolid", isEqualTo: schoolid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        academicyears = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return AcademicModel.fromMap(data, doc.id);
        }).toList();
      } else {
        academicyears = []; // explicitly set empty
      }

      loadacademicyear = false;
      notifyListeners();
    } catch (e) {
      loadacademicyear = false;
      academicyears = [];
      notifyListeners();
      print("Failed to fetch academic years: $e");
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
          schoolId: data['schoolId'] ?? '',
          time: parsedTime ?? DateTime.now(),
          staff: data['staff'] ?? '',
        );
      }).toList();


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
    //  fetchstaff();
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
  Future<void> fetchomponents() async {
    isloadcomponents = true;
    notifyListeners();
    try {
      final snapshot = await db
          .collection("assesscomponent")
          .orderBy("dateCreated", descending: true)
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
  Future<Map<String, dynamic>> getIdFormat(String schoolId) async {
    final query = await db.collection('idformats').where('schoolId', isEqualTo: schoolId).limit(1).get();
    if (query.docs.isEmpty) {
      throw Exception("No ID format found for school $schoolId");
    }
    final data = query.docs.first.data() as Map<String, dynamic>;
    String name = data['name'] as String;
    int lastNumber = (data['lastnumber'] ?? 0) as int;
    return {
      "name": name,
      "lastnumber": lastNumber,
    };
  }
  Future<void> saveTeacherSetupMulti({
    required List<String> teacherIds,
    required String schoolId,
    required String academicYear,
    required String term,
    required String classes,
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

      // STEP 1: Create SubjectScoring docs (one per student per term)
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        for (final level in levels) {
          final studentSnap = await db
              .collection("students")
              .where("schoolId", isEqualTo: schoolId)
              .where("department", isEqualTo: level.name)
              .where("level", isEqualTo: classes)
              .get();

          if (studentSnap.docs.isEmpty) continue;

          for (final studentDoc in studentSnap.docs) {
            final studentData = studentDoc.data() as Map<String, dynamic>;
            final studentId = studentDoc.id;
            final studentName = studentData['name'] ?? '';
            final region = studentData['region'] ?? '';
            final photoUrl = studentData['photoUrl'] ?? '';

            // ✅ one doc per student per academic year + term
            final scoringId = "${studentId}_${academicYear}_${term}";
            final scoringRef = db.collection("subjectScoring").doc(scoringId);

            // build subjects array
            final List<Map<String, dynamic>> subjectEntries = subjects.map((s) {
              final Map<String, String> initialScores = {
                for (var c in components) c.name: "0"
              };

              final criteriaTotal = components.fold<int>(
                0,
                    (sum, c) => sum + int.tryParse(c.totalMark)!,
              ).toString();

              return {
                "subjectId": s.id,
                "subjectName": s.name,
                "criteriatotal": criteriaTotal,
                "scores": initialScores,
                "status": "pending",
                "totalScore": "0",
                "grade": "",
                "remark": "",
                "timestamp": DateTime.now(),
              };
            }).toList();

            final scoringData = {
              "studentId": studentId,
              "studentName": studentName,
              "academicYear": academicYear,
              "term": term,
              "level": level.name,
              "region": region,
              "schoolId": schoolId,
              "photoUrl": photoUrl,
              "subjects": subjectEntries, // ✅ all subjects stored here
              "createdAt": FieldValue.serverTimestamp(),
            };

            batch.set(scoringRef, scoringData, SetOptions(merge: true));

            writes++;
            if (writes >= _batchLimit) {
              await batch.commit();
              batch = db.batch();
              writes = 0;
            }
          }
        }

        if (writes > 0) await batch.commit();
      }

      // STEP 2: Save TeacherSetup docs
          {
        int writes = 0;
        WriteBatch batch = db.batch();

        for (final teacherId in teacherIds) {
          final teacherSetupId = "${teacherId}_${academicYear}_$term";

          final teacherSetup = TeacherSetup(
            staffid: teacherId,
            staffname: name,
            classname: classes,
            schoolId: schoolId,
            academicyear: academicYear,
            term: term,
            levels: levels,     // all levels selected
            subjects: subjects, // all subjects selected
          );

          final teacherSetupRef =
          db.collection("teacherSetup").doc(teacherSetupId);

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
    } catch (e, stack) {
      debugPrint("Error in saveTeacherSetupMulti: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    } finally {
      savingSetup = false;
      notifyListeners();
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
