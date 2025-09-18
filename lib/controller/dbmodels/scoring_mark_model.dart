import 'componentmodel.dart';

/// Model to store subject-based scoring for a student
class SubjectScoring {
  final String id;
  final String studentId;
  final String studentName;
  final String academicYear;
  final String term;
  final String level;
  final String region;
  final String schoolId;
  final String photoUrl;
  final String staff;
  final String classes;
  final String teacher;

  /// subjectId -> score details
  final Map<String, dynamic> subjectData;

  /// subjectId -> yes/no (whether scored)
  final Map<String, String> scoredFlags;

  /// subjectId -> total string
  final Map<String, String> totalScores;

  final DateTime timestamp;

  SubjectScoring({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.academicYear,
    required this.term,
    required this.level,
    required this.region,
    required this.schoolId,
    required this.photoUrl,
    required this.subjectData,
    required this.scoredFlags,
    required this.totalScores,
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
    required String region,
    required String schoolId,
    required String photoUrl,
    required String subjectId,
    required List<ComponentModel> components,
  }) {
   // final id = "${studentId}_${academicYear}_${term}_$subjectId";
    final id = "${studentId}_${academicYear}_${term}";

    // initialize components with "0" marks
    final Map<String, String> initialScores = {
      for (var c in components) c.name: "0"
    };

    final criteriaTotal = components.fold<int>(
      0,
          (sum, c) => sum + int.tryParse(c.totalMark)!,
    ).toString();

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
      region: region,
      schoolId: schoolId,
      photoUrl: photoUrl,
      subjectData: {
        subjectId: {
          "criteriatotal": criteriaTotal,
          "scores": initialScores,
          "status": "pending",
          "timestamp": DateTime.now(),
          "totalScore": "0",
          "grade": "",
          "rawca": "",
          "convertedexams": "",
          "remark": "",
        }
      },
      scoredFlags: {
        "scored$subjectId": "no",
      },
      totalScores: {
        "total$subjectId": "0",
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "academicYear": academicYear,
      "term": term,
      "staff": staff,
      "classes": classes,
      "teacher": teacher,
      "studentId": studentId,
      "studentName": studentName,
      "level": level,
      "schoolId": schoolId,
      "photoUrl": photoUrl,
      "region": region,
      ...scoredFlags,
      ...totalScores,
      ...subjectData,
      "timestamp": timestamp,
    };
  }
}
