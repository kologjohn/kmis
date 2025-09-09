// class LevelModel {
//   final String levelname;
//   final DateTime time;
//
//   LevelModel({required this.levelname, required this.time});
//
//   // Convert to Map for storage
//   Map<String, dynamic> toMap() {
//     return {'name': levelname, 'timestamp': time.toIso8601String()};
//   }
//
//   // Create from Map (when reading data)
//   factory LevelModel.fromMap(Map<String, dynamic> map) {
//     return LevelModel(
//       levelname: map['name'] ?? '',
//       time: DateTime.parse(map['timestamp']),
//     );
//   }
// }
class LevelModel {
  final String id;
  final String levelname;
  final DateTime? time;
  final String? season;
  final String? week;
  final String? episode;
  final String? zone;

  LevelModel({
    required this.id,
    required this.levelname,
     this.time,
    this.season,
    this.week,
    this.episode,
    this.zone,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': levelname,
      'timestamp': time?.toIso8601String(),
      'season': season,
      'week': week,
      'episode': episode,
      'zone': zone,
    };
  }


  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] ?? '',
      levelname: map['name'] ?? '',
      time: DateTime.parse(map['timestamp']),
      season: map['season'],
      week: map['week'],
      episode: map['episode'],
      zone: map['zone'],
    );
  }
}
