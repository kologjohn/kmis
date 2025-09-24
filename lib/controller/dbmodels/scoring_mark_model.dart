// import 'componentmodel.dart';
//
//
// class SubjectScoring {
//   final String id;
//   final String studentId;
//   final String studentName;
//   final String academicYear;
//   final String term;
//   final String level;
//   final String department;
//   final String region;
//   final String schoolId;
//   final String school;
//   final String photoUrl;
//   final String dob;
//   final String email;
//   final String phone;
//   final String sex;
//   final String status;
//   final String yeargroup;
//   final String staff;
//   final String classes;
//   final String teacher;
//
//   /// subjectId -> score details
//   final Map<String, dynamic> subjectData;
//
//   /// subjectId -> yes/no (whether scored)
//   final Map<String, String> scoredFlags;
//
//   /// subjectId -> total string
//   final Map<String, String> totalScores;
//
//   final DateTime timestamp;
//
//   SubjectScoring({
//     required this.id,
//     required this.studentId,
//     required this.studentName,
//     required this.academicYear,
//     required this.term,
//     required this.level,
//     required this.department,
//     required this.region,
//     required this.schoolId,
//     required this.school,
//     required this.photoUrl,
//     required this.dob,
//     required this.email,
//     required this.phone,
//     required this.sex,
//     required this.status,
//     required this.yeargroup,
//     required this.subjectData,
//     required this.scoredFlags,
//     required this.totalScores,
//     required this.staff,
//     required this.classes,
//     required this.teacher,
//     DateTime? timestamp,
//   }) : timestamp = timestamp ?? DateTime.now();
//
//   /// Factory for initializing a subject record
//   factory SubjectScoring.create({
//     required String studentId,
//     required String studentName,
//     required String academicYear,
//     required String term,
//     required String staff,
//     required String classes,
//     required String teacher,
//     required String level,
//     required String department,
//     required String region,
//     required String schoolId,
//     required String school,
//     required String photoUrl,
//     required String dob,
//     required String email,
//     required String phone,
//     required String sex,
//     required String status,
//     required String yeargroup,
//     required String subjectId,
//     required String subjectName,
//     required List<ComponentModel> components,
//   }) {
//     final id = "${studentId}_${academicYear}_${term}";
//
//     // initialize components with "0" marks
//     final Map<String, String> initialScores = {
//       for (var c in components) c.name: "0"
//     };
//
//     return SubjectScoring(
//       id: id,
//       studentId: studentId,
//       studentName: studentName,
//       academicYear: academicYear,
//       term: term,
//       staff: staff,
//       classes: classes,
//       teacher: teacher,
//       level: level,
//       department: department,
//       region: region,
//       schoolId: schoolId,
//       school: school,
//       photoUrl: photoUrl,
//       dob: dob,
//       email: email,
//       phone: phone,
//       sex: sex,
//       status: status,
//       yeargroup: yeargroup,
//       subjectData: {
//         subjectId: {
//           "subjectId": subjectId,
//           "subjectName": subjectName,
//           "scores": initialScores,
//           "CAtotal": "0",
//           "examstotal": "0",
//           "CA": "0",
//           "Exams": "0",
//           "rawCA": "0",
//           "rawExams": "0",
//           "totalScore": "0",
//           "grade": "",
//           "remark": "",
//           "status": "pending",
//           "timestamp": DateTime.now(),
//           "scored$subjectId": "no",
//           "total$subjectId": "0",
//         }
//       },
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "academicYear": academicYear,
//       "term": term,
//       "staff": staff,
//       "classes": classes,
//       "teacher": teacher,
//       "studentId": studentId,
//       "studentName": studentName,
//       "level": level,
//       "department": department,
//       "schoolId": schoolId,
//       "school": school,
//       "photoUrl": photoUrl,
//       "dob": dob,
//       "email": email,
//       "phone": phone,
//       "sex": sex,
//       "status": status,
//       "yeargroup": yeargroup,
//       "region": region,
//       ...subjectData,
//       "timestamp": timestamp.toIso8601String(),
//     };
//   }
// }

import 'componentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectScoring {
  final String id;
  final String studentId;
  final String studentName;
  final String academicYear;
  final String term;
  final String level;
  final String department;
  final String region;
  final String schoolId;
  final String school;
  final String photoUrl;
  final String dob;
  final String email;
  final String phone;
  final String sex;
  final String status;
  final String yeargroup;
  final String staff;
  final String classes;
  final String teacher;

  /// subjectId -> full subject details (with scores, totals, flags)
  final Map<String, dynamic> subjectData;

  final DateTime timestamp;

  SubjectScoring({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.academicYear,
    required this.term,
    required this.level,
    required this.department,
    required this.region,
    required this.schoolId,
    required this.school,
    required this.photoUrl,
    required this.dob,
    required this.email,
    required this.phone,
    required this.sex,
    required this.status,
    required this.yeargroup,
    required this.subjectData,
    required this.staff,
    required this.classes,
    required this.teacher,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factory for initializing a subject record
  factory SubjectScoring.create({
    required String studentId,
    required String studentName,
    required String academicYear,
    required String term,
    required String staff,
    required String classes,
    required String teacher,
    required String level,
    required String department,
    required String region,
    required String schoolId,
    required String school,
    required String photoUrl,
    required String dob,
    required String email,
    required String phone,
    required String sex,
    required String status,
    required String yeargroup,
    required String subjectId,
    required String subjectName,
    required List<ComponentModel> components,
  }) {
    final id = "${studentId}_${academicYear}_${term}";

    // initialize components with "0" marks
    final Map<String, String> initialScores = {
      for (var c in components) c.name: "0"
    };

    return SubjectScoring(
      id: id,
      studentId: studentId,
      studentName: studentName,
      academicYear: academicYear,
      term: term,
      staff: staff,
      classes: classes,
      teacher: teacher,
      level: level,
      department: department,
      region: region,
      schoolId: schoolId,
      school: school,
      photoUrl: photoUrl,
      dob: dob,
      email: email,
      phone: phone,
      sex: sex,
      status: status,
      yeargroup: yeargroup,
      subjectData: {
        subjectId: {
          "subjectId": subjectId,
          "subjectName": subjectName,
          "scores": initialScores,
          "staff": email,
          "CAtotal": "0",
          "examstotal": "0",
          "CA": "0",
          "Exams": "0",
          "rawCA": "0",
          "rawExams": "0",
          "caw":"0",
          "examsw":"0",
          "maxca":"0",
          "maxexams":"0",
          "totalScore": "0",
          "grade": "",
          "remark": "",
          "status": "pending",
          "scored": "no",
          "total": "0",
          "timestamp": DateTime.now().toIso8601String(),
        }
      },
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "academicYear": academicYear,
      "term": term,
      "staff": staff,
      "classes": classes,
      "teacher": teacher,
      "studentId": studentId,
      "studentName": studentName,
      "level": level,
      "department": department,
      "schoolId": schoolId,
      "school": school,
      "photoUrl": photoUrl,
      "dob": dob,
      "email": email,
      "phone": phone,
      "sex": sex,
      "status": status,
      "yeargroup": yeargroup,
      "region": region,
      "subjectData": subjectData,
      "timestamp": Timestamp.fromDate(timestamp),
    };
  }

  /// Create model from Firestore JSON
  factory SubjectScoring.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parsedTime;

    final ts = json["timestamp"];
    if (ts is Timestamp) {
      parsedTime = ts.toDate();
    } else if (ts is String) {
      parsedTime = DateTime.tryParse(ts) ?? DateTime.now();
    } else if (ts is DateTime) {
      parsedTime = ts;
    } else {
      parsedTime = DateTime.now();
    }

    return SubjectScoring(
      id: docId,
      studentId: json["studentId"] ?? "",
      studentName: json["studentName"] ?? "",
      academicYear: json["academicYear"] ?? "",
      term: json["term"] ?? "",
      staff: json["staff"] ?? "",
      classes: json["classes"] ?? "",
      teacher: json["teacher"] ?? "",
      level: json["level"] ?? "",
      department: json["department"] ?? "",
      region: json["region"] ?? "",
      schoolId: json["schoolId"] ?? "",
      school: json["school"] ?? "",
      photoUrl: json["photoUrl"] ?? "",
      dob: json["dob"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      sex: json["sex"] ?? "",
      status: json["status"] ?? "",
      yeargroup: json["yeargroup"] ?? "",
      subjectData: (json["subjectData"] ?? {}) as Map<String, dynamic>,
      timestamp: parsedTime,
    );
  }
}


