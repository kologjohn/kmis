class ScoremodelConfig {
  final String? id;
  final String? staff;
  final String schoolId;
  final String continuous; // stored as string
  final String exam;       // stored as string

  ScoremodelConfig({
    this.id,
    this.staff,
    required this.schoolId,
    required this.continuous,
    required this.exam,
  }) {
    // validation using doubles
    final cont = double.tryParse(continuous) ?? 0;
    final ex = double.tryParse(exam) ?? 0;
    if ((cont + ex).toStringAsFixed(2) != "100.00") {
      throw Exception("Continuous + Exam must sum to 100");
    }
  }

  /// Factory for Firestore documents (includes doc.id)
  factory ScoremodelConfig.fromFirestore(Map<String, dynamic> map, String id) {
    return ScoremodelConfig(
      id: id,
      schoolId: map['schoolId'] ?? "",
      continuous: map['continuous']?.toString() ?? "0",
      exam: map['exam']?.toString() ?? "0",
    );
  }

  /// Convert to Map for saving
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "staff": staff,
      "schoolId": schoolId,
      "continuous": continuous,
      "exam": exam,
    };
  }

  @override
  String toString() => "CA: $continuous%, Exam: $exam%";
}
