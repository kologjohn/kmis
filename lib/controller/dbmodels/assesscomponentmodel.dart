class AssesscomponentModel {
  final String componentname;
  String? level;
  final String totalmark;
  final DateTime time;

  AssesscomponentModel({
    required this.componentname,
   this.level,
    required this.totalmark,
    required this.time,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': componentname,
      'level': level,
      'totalmark': totalmark,
      'timestamp': time.toIso8601String(),
    };
  }

  // Create from Map (when reading data)
  factory AssesscomponentModel.fromMap(Map<String, dynamic> map) {
    return AssesscomponentModel(
      componentname: map['name'] ?? '',
      level: map['level'] ?? '',
      totalmark: map['totalmark'] ?? '',
      time: DateTime.parse(map['timestamp']),
    );
  }
}
