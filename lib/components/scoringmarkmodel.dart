class ScoringMark {
  final String id;
  final String studentName;
  final String region;
  final String level;
  final String zone;
  final String episodeId;
  final String episodeTitle;
  final Map<String, String> scores;
  final String totalScore;

  ScoringMark({
    required this.id,
    required this.studentName,
    required this.region,
    required this.level,
    required this.zone,
    required this.episodeId,
    required this.episodeTitle,
    required this.scores,
    required this.totalScore,
  });

  factory ScoringMark.fromDoc(String id, Map<String, dynamic> data) {
    return ScoringMark(
      id: id,
      studentName: data['studentName'] ?? '',
      region: data['region'] ?? '',
      level: data['level'] ?? '',
      zone: data['zone'] ?? '',
      episodeId: data['episodeId'] ?? '',
      episodeTitle: data['episodeTitle'] ?? '',
      scores: Map<String, String>.from(data['scores'] ?? {}),
      totalScore: data['totalScore'] ?? '0',
    );
  }
}
