class RegionModel {
  final String id;
  final String regionname;
  final String season;
  final String week;
  final String zone;
  final String episode;
  final DateTime time;

  RegionModel({
    required this.id,
    required this.regionname,
    required this.season,
    required this.week,
    required this.zone,
    required this.episode,
    required this.time,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': regionname,
      'season': season,
      'week': week,
      'zone': zone,
      'episode': episode,
      'timestamp': time.toIso8601String(),
    };
  }

  // Create from Map (when reading data)
  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'] ?? '',
      regionname: map['name'] ?? '',
      season: map['season'] ?? '',
      week: map['week'] ?? '',
      zone: map['zone'] ?? '',
      episode: map['episode'] ?? '',
      time: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
