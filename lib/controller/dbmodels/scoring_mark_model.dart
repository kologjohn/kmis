import 'componentmodel.dart';

class ScoringMark {
  final String id;          // studentId_season_episode
  final String studentId;
  final String studentName;
  final String seasonId;
  final String episodeId;
  final String level;       // from contestant collection
  final String zone;
  final String region;
  final String photoUrl;
  final Map<String, dynamic> judgeData; // judgeId -> map of scores
  final Map<String, String> scoredFlags; // "scored<judgeId>" -> yes/no
  final Map<String, String> totalScores; // "total<judgeId>" -> total string
  final DateTime timestamp;

  ScoringMark({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.seasonId,
    required this.episodeId,
    required this.level,
    required this.zone,
    required this.region,
    required this.photoUrl,
    required this.judgeData,
    required this.scoredFlags,
    required this.totalScores,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factory for a single judge assignment
  factory ScoringMark.create({
    required String studentId,
    required String studentName,
    required String seasonId,
    required String episodeId,
    required String level,
    required String zone,
    required String region,
    required String photoUrl,
    required String judgeId,
    required List<ComponentModel> components,
  }) {
    final id = "${studentId}_${seasonId}_$episodeId";

    final Map<String, String> initialScores = {
      for (var c in components) c.name: "0"
    };

    final criteriaTotal = components.fold<int>(
      0,
          (sum, c) => sum + int.tryParse(c.totalMark)!,
    ).toString();

    return ScoringMark(
      id: id,
      studentId: studentId,
      studentName: studentName,
      seasonId: seasonId,
      episodeId: episodeId,
      level: level,
      zone: zone,
      region: region,
      photoUrl: photoUrl,
      judgeData: {
        judgeId: {
          "criteriatotal": criteriaTotal,
          "scores": initialScores,
          "status": "1",
          "timestamp": DateTime.now(),
          "totalScore": "0",
        }
      },
      scoredFlags: {
        "scored$judgeId": "no",
      },
      totalScores: {
        "total$judgeId": "0",
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "episodeId": episodeId,
      "episodeTitle": episodeId,
      "studentId": studentId,
      "studentName": studentName,
      "level": level,
      "photoUrl": photoUrl,
      "zone": zone,
      "region": region,
      ...scoredFlags,
      ...totalScores,
      ...judgeData,
      "timestamp": timestamp,
    };
  }
}
