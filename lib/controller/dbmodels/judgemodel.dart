/*
import 'componentmodel.dart';
import 'levelmodel.dart';

class JudgeSetup {
  final String judgeId;
  final List<LevelModel>? levels;
  final String zone;
  final String region;
  final String episodeId;
  final String? complete;
  final List<ComponentModel> components;

  JudgeSetup({
    required this.judgeId,
    this.levels,
    this.complete,
    required this.zone,
    required this.region,
    required this.episodeId,
    required this.components,
  });

  Map<String, dynamic> toJson() {
    return {
      "judge": judgeId,
      "status": complete,
      "levels": levels?.map((c) => c.levelname).toList() ?? [],
      "zone": zone,
      "region": region,
      "episode": episodeId,
      "components": components.map((c) => c.toJson()).toList(),
      "timestamp": DateTime.now().toIso8601String(),
    };
  }
}
*/

import 'componentmodel.dart';
import 'levelmodel.dart';

class JudgeSetup {
  final String judgeId;
  final List<LevelModel>? levels;
  final String zone;
  final String region;
  final String episodeId;
  final String? complete;
  final List<ComponentModel> components;

  JudgeSetup({
    required this.judgeId,
    this.levels,
    this.complete,
    required this.zone,
    required this.region,
    required this.episodeId,
    required this.components,
  });

  Map<String, dynamic> toJson() {
    return {
      "judge": judgeId,
      "iscomplete": complete ?? "no",
      "levels": levels?.map((lvl) => {
        "id": lvl.id,
        "name": lvl.levelname,
        "iscomplete": "no",
      }).toList() ??
          [],
      "zone": zone,
      "region": region,
      "episode": episodeId,
      "components": components.map((c) => c.toJson()).toList(),
      "timestamp": DateTime.now().toIso8601String(),
    };
  }
}
