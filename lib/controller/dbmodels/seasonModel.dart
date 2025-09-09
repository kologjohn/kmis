class SeasonModel {
  final String seasonname;
  final id;
  final DateTime time;

  SeasonModel({
    required this.seasonname,
    required this.id,
    required this.time});

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': seasonname,
      'id': id,
      'timestamp': time.toIso8601String()};
  }

  // Create from Map (when reading data)
  factory SeasonModel.fromMap(Map<String, dynamic> map) {
    return SeasonModel(
      seasonname: map['name'] ?? '',
      id: map['id'] ?? '',
      time: DateTime.parse(map['timestamp']),
    );
  }
}
