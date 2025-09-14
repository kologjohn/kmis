import 'componentmodel.dart';

/// Model to store subject-based scoring for a student
class SubjectScoring {
  final String id;                // studentId_academicYear_term_subject
  final String studentId;
  final String studentName;
  final String academicYear;
  final String term;
  final String level;             // class/grade (e.g., JHS1)
  final String region;
  final String schoolId;
  final String photoUrl;

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
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factory for initializing a subject record
  factory SubjectScoring.create({
    required String studentId,
    required String studentName,
    required String academicYear,
    required String term,
    required String level,
    required String region,
    required String schoolId,
    required String photoUrl,
    required String subjectId,
    required List<ComponentModel> components, // e.g., Exams, Classwork, Homework
  }) {
    final id = "${studentId}_${academicYear}_${term}_$subjectId";

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
      level: level,
      region: region,
      schoolId: schoolId,
      photoUrl: photoUrl,
      subjectData: {
        subjectId: {
          "criteriatotal": criteriaTotal,
          "scores": initialScores, // per component
          "status": "pending",     // pending / in-progress / finalized
          "timestamp": DateTime.now(),
          "totalScore": "0",
          "grade": "",             // to be assigned after scoring
          "remark": "",            // e.g. Excellent / Good / Poor
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
