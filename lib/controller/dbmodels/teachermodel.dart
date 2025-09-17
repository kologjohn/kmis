/*
import 'package:ksoftsms/controller/dbmodels/subjectmodel.dart';
import 'departmodel.dart';

class TeacherSetup {
  final String staffid;
  final String staffname;
  final String schoolId;
  final String academicyear;
  final String term;
  final String? classid;
  final String? classname;
  final String status;
  final String complete;
  final String? email;
  final String? phone;
  final List<DepartmentModel>? levels;
  final List<SubjectModel> subjects;
  final DateTime timestamp;

  TeacherSetup({
    required this.staffid,
    required this.staffname,
    required this.schoolId,
    required this.academicyear,
    required this.term,
    this.classid,
    this.classname,
    this.status = "active",
    this.complete = "no",
    this.email,
    this.phone,
    this.levels,
    required this.subjects,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      "staffid": staffid,
      "staffname": staffname,
      "schoolId": schoolId,
      "academicyear": academicyear,
      "term": term,
      "subjects": subjects ?? [],
      "classid": classid,
      "classname": classname,
      "status": status,
      "complete": complete,
      "email": email,
      "phone": phone,
      "levels": levels?.map((lvl) => {
        "id": lvl.id,
        "name": lvl.name,
        "isComplete": "no",
      }).toList() ?? [],
      "asesssubjects": subjects.map((c) => c.toMap()).toList(),
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
*/

import 'package:ksoftsms/controller/dbmodels/subjectmodel.dart';
import 'departmodel.dart';

class TeacherSetup {
  final String staffid;
  final String staffname;
  final String schoolId;
  final String academicyear;
  final String term;
  final String? classid;
  final String? classname;
  final String status;
  final String complete;
  final String? email;
  final String? phone;
  final List<DepartmentModel>? levels;
  final List<SubjectModel> subjects;
  final DateTime timestamp;

  TeacherSetup({
    required this.staffid,
    required this.staffname,
    required this.schoolId,
    required this.academicyear,
    required this.term,
    this.classid,
    this.classname,
    this.status = "active",
    this.complete = "no",
    this.email,
    this.phone,
    this.levels,
    required this.subjects,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      "staffid": staffid,
      "staffname": staffname,
      "schoolId": schoolId,
      "academicyear": academicyear,
      "term": term,
      "subjects": subjects.map((s) => s.toMap()).toList(),
      "classid": classid,
      "classname": classname,
      "status": status,
      "complete": complete,
      "email": email,
      "phone": phone,
      "levels": levels?.map((lvl) => {
        "id": lvl.id,
        "name": lvl.name,
        "isComplete": "no",
      }).toList() ?? [],
      "asesssubjects": subjects.map((c) => c.toMap()).toList(),
      "timestamp": timestamp.toIso8601String(),
    };
  }
}

