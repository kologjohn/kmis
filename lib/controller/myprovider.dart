import 'dart:async';
import 'dart:convert';
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
  List<TeacherSetup> teacherSetupList = [];
  bool isLoadingTeacherList = false;
  DocumentSnapshot? firstTeacherDocument;
  DocumentSnapshot? lastTeacherDocument;
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
      fetchomponents();
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
  Future<void> fetchTeacherSetupList({int limit = 10, bool reset = false, bool nextPage = true,}) async {
    try {
      isLoadingTeacherList = true;
      notifyListeners();
      Query query = db
          .collection("teacherSetup")
          .orderBy("timestamp", descending: false)
          .limit(limit);
      if (!reset && lastTeacherDocument != null && nextPage) {
        query = query.startAfterDocument(lastTeacherDocument!);
      } else if (!reset && firstTeacherDocument != null && !nextPage) {
        query = query.endBeforeDocument(firstTeacherDocument!).limitToLast(limit);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        // Save pagination cursors
        firstTeacherDocument = snapshot.docs.first;
        lastTeacherDocument = snapshot.docs.last;
        teacherSetupList = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return TeacherSetup(
            staffid: data['staffid'] ?? '',
            staffname: data['staffname'] ?? '',
            schoolId: data['schoolId'] ?? '',
            academicyear: data['academicyear'] ?? '',
            term: data['term'] ?? '',
            component: (data['component'] as List<dynamic>?)
                ?.map((c) => ComponentModel.fromMap(c as Map<String, dynamic>))
                .toList()
                ?? [],
            classname: (data['classname'] as List<dynamic>? ?? [])
                .map((c) => ClassModel(
              id: c['id'] ?? '',
              name: c['name'] ?? '',
              staff: name,
            ))
                .toList(),
            status: data['status'] ?? 'active',
            complete: data['complete'] ?? 'no',
            email: data['email'],
            phone: data['phone'],
            createby: data['createby'],
            levels: (data['levels'] as List<dynamic>? ?? [])
                .map((lvl) => DepartmentModel(
              id: lvl['id'] ?? '',
              name: lvl['name'] ?? '',
              staff: name,
            ))
                .toList(),
            subjects: (data['subjects'] as List<dynamic>? ?? [])
                .map((s) => SubjectModel(
              id: s['id'] ?? '',
              name: s['name'] ?? '',
            
            ))
                .toList(),
            timestamp: data['timestamp'] != null
                ? DateTime.tryParse(data['timestamp']) ?? DateTime.now()
                : DateTime.now(),

          );
        }).toList();
      } else {
        teacherSetupList = [];
      }
    } catch (e) {
      debugPrint("Error fetching teacherSetup: $e");
    } finally {
      isLoadingTeacherList = false;
      notifyListeners();
    }
  }
  updateAccessComponent(String id, Map<String, dynamic> newData) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('assesscomponent')
          .doc(id);

      await docRef.update(newData);
      // Refresh the list after update
      await fetchomponents();

      notifyListeners();
    } catch (e) {
      debugPrint("Error updating component: $e");
      rethrow;
    }
  }

  Future<void> saveTeacherSetupMulti({
    required List<String> teacherIds,
    required List<String> teacherNames, // dynamic teacher names
    required String schoolId,
    required String academicYear,
    required String term,
    required List<ClassModel> classes, // multiple classes
    required List<DepartmentModel> levels,
    required List<SubjectModel> subjects,
    required List<ComponentModel> components,
  }) async {
    if (teacherIds.isEmpty) throw Exception("No teachers selected.");
    if (teacherNames.isEmpty) throw Exception("Teacher names missing.");
    if (levels.isEmpty) throw Exception("No levels selected.");
    if (subjects.isEmpty) throw Exception("No subjects selected.");
    if (academicYear.trim().isEmpty || term.trim().isEmpty) {
      throw Exception("Academic year and term are required.");
    }

    savingSetup = true;
    notifyListeners();
    const int _batchLimit = 450;

    try {
      // ----------------------------
      // STEP 1: Create SubjectScoring docs for all students
      // ----------------------------
      WriteBatch batch = db.batch();
      int writes = 0;

      final classNames = classes.map((c) => c.name).toList();
      final levelNames = levels.map((c) => c.name).toList();

      // Fetch all students in selected classes and levels
      final studentSnap = await db
          .collection("students")
          .where("schoolId", isEqualTo: schoolId)
          .where("level", whereIn: classNames)
          .where("department", whereIn: levelNames)
          .get();

      final Map<String, Map<String, String>> teacherInfo = {};

      for (int i = 0; i < teacherIds.length; i++) {
        teacherInfo[teacherIds[i]] = {
          "id": teacherIds[i],
          "name": teacherNames[i],
        };
      }

      for (final studentDoc in studentSnap.docs) {
        final studentData = studentDoc.data() as Map<String, dynamic>;
        final studentId = studentDoc.id;
        final studentClass = studentData['level'] ?? '';

        // Skip students not in selected classes
        if (!classNames.contains(studentClass)) continue;

        // Build subjects using SubjectScoring model
        final Map<String, dynamic> subjectMap = {};
        final Map<String, String> scoredFlags = {};
        final Map<String, String> totalScores = {};

        for (final subject in subjects) {
          final scoring = SubjectScoring.create(
            studentId: studentId,
            studentName: studentData['name'] ?? '',
            academicYear: academicYear,
            term: term,
            staff: name,
            classes: studentClass,
            teacher: '', // assign teacher if needed
            level: studentData['level'] ?? '',
            department: studentData['department'] ?? '',
            region: studentData['region'] ?? '',
            schoolId: schoolId,
            school: studentData['school'] ?? '',
            photoUrl: studentData['photourl'] ?? '',
            dob: studentData['dob'] ?? '',
            email: studentData['email'] ?? '',
            phone: studentData['phone'] ?? '',
            sex: studentData['sex'] ?? '',
            status: studentData['status'] ?? 'active',
            yeargroup: studentData['yeargroup'] ?? '',
            subjectId: subject.id,
            subjectName: subject.name,
            components: components,
          );

          subjectMap.addAll(scoring.subjectData);
          scoredFlags.addAll(scoring.scoredFlags);
          totalScores.addAll(scoring.totalScores);
        }

        final scoringId = "${studentId}_$academicYear$term";
        final scoringRef = db.collection("subjectScoring").doc(scoringId);
        final scoringData = {
          "studentId": studentId,
          "studentName": studentData['name'] ?? '',
          "academicYear": academicYear,
          "term": term,
          "level": studentData['level'] ?? '',
          "class": studentClass,
          "department": studentData['department'] ?? '',
          "region": studentData['region'] ?? '',
          "schoolId": schoolId,
          "school": studentData['school'] ?? '',
          "photourl": studentData['photourl'] ?? '',
          "dob": studentData['dob'] ?? '',
          "email": studentData['email'] ?? '',
          "phone": studentData['phone'] ?? '',
          "sex": studentData['sex'] ?? '',
          "status": studentData['status'] ?? 'active',
          "yeargroup": studentData['yeargroup'] ?? '',
          "teachers": teacherInfo,
          "subjects":subjectMap,
          //...subjectMap,
          ...scoredFlags,
          ...totalScores,
          "timestamp": DateTime.now(),
        };

        batch.set(scoringRef, scoringData, SetOptions(merge: true));
        writes++;

        if (writes >= _batchLimit) {
          await batch.commit();
          batch = db.batch();
          writes = 0;
        }
      }

      if (writes > 0) await batch.commit();

      // ----------------------------
      // STEP 2: Save TeacherSetup docs after student scoring
      // ----------------------------
      batch = db.batch();
      writes = 0;

      for (int i = 0; i < teacherIds.length; i++) {
        final teacherId = teacherIds[i];
       // final teachername = teacherNames[i];

        final teacherSetupId = "${teacherId}_${academicYear}_$term";

        final teacherSetup = TeacherSetup(
          staffid: teacherId,
          staffname: teacherNames[i],
          classname: classes,
          schoolId: schoolId,
          academicyear: academicYear,
          term: term,
          component: components,
          levels: levels,
          subjects: subjects,
          createby: name,
        );

        final teacherSetupRef = db.collection("teacherSetup").doc(teacherSetupId);
        batch.set(teacherSetupRef, teacherSetup.toJson(), SetOptions(merge: true));
        writes++;

        if (writes >= _batchLimit) {
          await batch.commit();
          batch = db.batch();
          writes = 0;
        }
      }

      if (writes > 0) await batch.commit();
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

  Future<void> deleteteacher(String staffId) async { const teachersetupColl = 'teachersetup';    const subjectScoringColl = 'subjectScoring';
    final teachersetupDocId = '${staffId}_${academicyrid}_$term';
    final setupRef = db.collection(teachersetupColl).doc(teachersetupDocId);
   print(teachersetupDocId);
    try {
      // 1) Read teacher setup
      final setupSnap = await setupRef.get();
      if (!setupSnap.exists) {
        debugPrint('No teachersetup found: $teachersetupDocId');
        return;
      }
      final Map<String, dynamic> setupData =
      setupSnap.data()! as Map<String, dynamic>;

      // 2) Extract subjects and classes from setup
      final List<String> subjectIds = (setupData['subjects'] as List<dynamic>?)
          ?.map((s) {
        final m = s as Map<String, dynamic>;
        return (m['id'] ?? m['subjectId'] ?? m['name'] ?? '').toString();
      })
          .where((id) => id.isNotEmpty)
          .toList() ??
          [];

      final List<String> classes = (setupData['classname'] as List<dynamic>?)
          ?.map((c) {
        if (c is String) return c;
        if (c is Map && c['name'] != null) return c['name'].toString();
        return c.toString();
      })
          .toList() ??
          [];

      if (subjectIds.isEmpty) {
        debugPrint('No subjects found in teachersetup $teachersetupDocId — nothing to clean.');
      }
      final int chunkSize = 10;
      final List<List<String>> classChunks = [];
      for (var i = 0; i < classes.length; i += chunkSize) {
        classChunks.add(classes.sublist(
          i,
          i + chunkSize > classes.length ? classes.length : i + chunkSize,
        ));
      }


      final List<QueryDocumentSnapshot<Map<String, dynamic>>> scoringDocs = [];

      for (final chunk in classChunks.isNotEmpty ? classChunks : [<String>[]]) {
        Query<Map<String, dynamic>> q = db
            .collection(subjectScoringColl)
            .withConverter<Map<String, dynamic>>(
            fromFirestore: (s, _) => s.data() ?? <String, dynamic>{},
            toFirestore: (m, _) => m);

        q = q.where('schoolId', isEqualTo: schoolid)
            .where('academicYear', isEqualTo: academicyrid)
            .where('term', isEqualTo: term);

        if (chunk.isNotEmpty) {
          q = q.where('class', whereIn: chunk);
        }

        final snap = await q.get();
        scoringDocs.addAll(snap.docs);
      }

      final List<Map<String, String>> conflicts = [];
      bool _hasMarksInSubjectMap(Map<String, dynamic> subj) {
        bool notZero(dynamic v) {
          if (v == null) return false;
          final s = v.toString().trim();
          if (s.isEmpty) return false;
          if (s == '0' || s == '0.0' || s == '0.00') return false;
          return true;
        }

        if (notZero(subj['CA']) ||
            notZero(subj['Exams']) ||
            notZero(subj['CAtotal']) ||
            notZero(subj['examstotal']) ||
            notZero(subj['totalScore']) ||
            notZero(subj['rawCA']) ||
            notZero(subj['rawExams'])) {
          return true;
        }

        if (subj['scores'] is Map) {
          final scoresMap = subj['scores'] as Map;
          for (final v in scoresMap.values) {
            if (notZero(v)) return true;
          }
        }
        final status = subj['status']?.toString().toLowerCase();
        if (status != null && status.isNotEmpty && status != 'pending' && status != 'no') {
          return true;
        }
        return false;
      }

      for (final doc in scoringDocs) {
        final data = doc.data();
        final subjectsMap = (data['subjects'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        for (final subId in subjectIds) {
          if (!subjectsMap.containsKey(subId)) continue;
          final subjRaw = subjectsMap[subId];
          if (subjRaw == null) continue;
          if (subjRaw is! Map) continue;
          final Map<String, dynamic> subj = Map<String, dynamic>.from(subjRaw);
          if (_hasMarksInSubjectMap(subj)) {
            conflicts.add({
              'docId': doc.id,
              'studentId': data['studentId']?.toString() ?? '',
              'studentName': data['studentName']?.toString() ?? '',
              'subjectId': subId,
              'subjectName': subj['subjectName']?.toString() ?? '',
            });

          }
        }
      }
      if (conflicts.isNotEmpty) {
        // Abort: found scores — do not delete anything
        final example = conflicts.take(5).map((c) => '${c['studentName']}:${c['subjectId']}').join(', ');
        throw StateError(
            'Cannot delete teacher/setup — found existing scores for subjects. Example: $example. '
                'Found ${conflicts.length} scoring entries.');
      }
      WriteBatch batch = db.batch();
      int pendingWrites = 0;
      Future<void> _commitBatchIfNeeded() async {
        if (pendingWrites > 0) {
          await batch.commit();
          pendingWrites = 0;
          batch = db.batch();
        }
      }
      for (final doc in scoringDocs) {
        final data = doc.data();
        final subjectsMap = (data['subjects'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        final Map<String, dynamic> updates = <String, dynamic>{};
        for (final subId in subjectIds) {
          if (subjectsMap.containsKey(subId)) {
            updates['subjects.$subId'] = FieldValue.delete();
          }
        }
        if (data['teachers'] is List) {
          final List<dynamic> teachersList = List<dynamic>.from(data['teachers'] as List<dynamic>);
          final newTeachers = teachersList.where((t) {
            if (t is Map) {
              final id = t['id']?.toString();
              final tTerm = t['term']?.toString();
              return !(id == staffId && (tTerm == null || tTerm == term || tTerm == term));
            }
            return true;
          }).toList();

          if (newTeachers.length != teachersList.length) {
            updates['teachers'] = newTeachers;
          }
        }
        if (updates.isNotEmpty) {
          batch.update(doc.reference, updates);
          pendingWrites++;
          if (pendingWrites >= 450) {
            await _commitBatchIfNeeded();
          }
        }
      }
      // commit any remaining student updates
      await _commitBatchIfNeeded();
      await setupRef.delete();
      debugPrint('deleteTeacherAndCleanup: completed for $teachersetupDocId (teacher $staffId)');
    } catch (e, st) {
      debugPrint('deleteTeacherAndCleanup error: $e\n$st');
      rethrow;
    }
  }
  bool isloadac =false;
  List<Map<String, dynamic>> marksList = [];
  bool isloadscore=false;

  Future<void> fetchStaffScoringMarks() async {
    await getdata();
    isloadscore = true;
    notifyListeners();

    const String academicyrid = "20242025";
    const String className = "B8";
    const String schoolId = "KS0002";
    const String teacherId = "KS0002";
    const String subjectKey = "KS0002_englisheng";
    try {
      final querySnapshot = await db
          .collection('subjectScoring')
          .where('academicYear', isEqualTo: academicyrid)
          .where('class', isEqualTo: className)
          .where('schoolId', isEqualTo: schoolId)
          .get();


      marksList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final docid = doc.id;
        final teachers = (data['teachers'] as Map<String, dynamic>? ?? {});
        if (!teachers.containsKey(teacherId)) {
          return null;
        }
        final subjects = (data['subjects'] as Map<String, dynamic>? ?? {});
        if (!subjects.containsKey(subjectKey)) {
          return null;
        }

        final subjectData = subjects[subjectKey] as Map<String, dynamic>;
        final scores = (subjectData['scores'] as Map<String, dynamic>? ?? {});
        final sortedScoresList = scores.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
        final sortedScoresMap = Map.fromEntries(sortedScoresList);
        return {
          'id': docid,
          'studentName': data['studentName'] ?? '',
          'studentId': data['studentId'] ?? '',
          'class': data['class'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'scores': sortedScoresMap,
          'teacher': teachers[teacherId],
          'subject': subjectData['subjectName'] ?? '',
        };
      }).where((e) => e != null).cast<Map<String, dynamic>>().toList();
    } catch (e) {
      print("Error fetching staff scoring marks: $e");
    } finally {
      isloadscore = false;
      notifyListeners();
    }
  }







}
