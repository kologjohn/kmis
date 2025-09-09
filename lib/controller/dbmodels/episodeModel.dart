class EpisodeModel {
  final String episodename;
  final DateTime time;
  final String? totalMark;
  final String? cmt;
  final String id;

  EpisodeModel({
    required this.episodename,
    required this.time,
    this.totalMark,
    this.cmt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': episodename,
      'timestamp': time.toIso8601String(),
      'totalMark': totalMark,
      'cmt': cmt,
      'id': id,
    };
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    final rawName = map['name'];
    if (rawName == null) {
      throw Exception("Missing 'name' field in episode data.");
    }

    return EpisodeModel(
      episodename: rawName.toString(),
      time: DateTime.parse(map['timestamp']),
      totalMark: map['totalMark']?.toString(),
      cmt: map['cmt']?.toString(),
      id: map['id'].toString(), // force it to String
    );
  }
}
