class RegionModel {
  final String id;
  final String staff;
  final String schoolId;
  final String regionname;
  final DateTime time;

  RegionModel({
    required this.id,
    required this.staff,
    required this.schoolId,
    required this.regionname,
    required this.time,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staff': staff,
      'schoolId': schoolId,
      'name': regionname,
      'timestamp': time.toIso8601String(),
    };
  }

  // Create from Map (when reading data)
  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'] ?? '',
      staff: map['staff'] ?? '',
      schoolId: map['schoolId'] ?? '',
      regionname: map['name'] ?? '',
      time: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
