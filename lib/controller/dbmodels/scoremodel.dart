class ScoremodelConfig {
  final String? id;
  final String schoolId;
  final String continuous;
  final String exam;

  ScoremodelConfig({
    this.id,
    required this.schoolId,
    required this.continuous,
    required this.exam,
  }) {
    if ((continuous + exam) != 100) {
      throw Exception("Continuous + Exam must sum to 100");
    }
  }

  /// Factory for Firestore documents (includes doc.id)
  factory ScoremodelConfig.fromFirestore(Map<String, dynamic> map, String id) {
    return ScoremodelConfig(
      id: id,
      schoolId: map['schoolId'] ?? "",
      continuous: (map['continuous'] ?? 50).toDouble(),
      exam: (map['exam'] ?? 50).toDouble(),
    );
  }

  /// Convert to Map for saving
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "schoolId": schoolId,
      "continuous": continuous,
      "exam": exam,
    };
  }

  @override
  String toString() => "CA: $continuous%, Exam: $exam%";
}
