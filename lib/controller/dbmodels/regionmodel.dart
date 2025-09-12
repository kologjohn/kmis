class RegionModel {
  final String id;
  final String regionname;
  final DateTime time;

  RegionModel({
    required this.id,
    required this.regionname,
    required this.time,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': regionname,
      'timestamp': time.toIso8601String(),
    };
  }

  // Create from Map (when reading data)
  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'] ?? '',
      regionname: map['name'] ?? '',
      time: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
