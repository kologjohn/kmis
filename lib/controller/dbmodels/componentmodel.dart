class ComponentModel {
  final String name;
  final String totalMark; // store as string to match Firestore

  ComponentModel({
    required this.name,
    required this.totalMark,
  });

  factory ComponentModel.fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      name: map['name'] ?? '',
      totalMark: map['totalmark']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "totalmark": totalMark,
    };
  }
}