class GradingSystem {
  final String schoolId;
  final String name;
  final DateTime dateCreated;
  final List<System> systems;

  GradingSystem({
    required this.schoolId,
    required this.name,
    required this.dateCreated,
    required this.systems,
  });

  factory GradingSystem.fromMap(Map<String, dynamic> map) {
    return GradingSystem(
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      dateCreated: DateTime.tryParse(map['dateCreated'] ?? '') ?? DateTime.now(),
      systems: (map['systems'] as List<dynamic>?)
          ?.map((e) => System.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'name': name,
      'dateCreated': dateCreated.toIso8601String(),
      'systems': systems.map((e) => e.toMap()).toList(),
    };
  }
}

class System {
  final String id;
  final String name;
  final List<Grade> grades;

  System({
    required this.id,
    required this.name,
    required this.grades,
  });

  factory System.fromMap(Map<String, dynamic> map) {
    return System(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      grades: (map['grades'] as List<dynamic>?)
          ?.map((e) => Grade.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grades': grades.map((e) => e.toMap()).toList(),
    };
  }
}

class Grade {
  final double min;
  final double max;
  final String grade;
  final String remark;

  Grade({
    required this.min,
    required this.max,
    required this.grade,
    required this.remark,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      min: (map['min'] as num).toDouble(),
      max: (map['max'] as num).toDouble(),
      grade: map['grade'] ?? '',
      remark: map['remark'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
      'grade': grade,
      'remark': remark,
    };
  }
}
