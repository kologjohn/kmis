import 'package:cloud_firestore/cloud_firestore.dart';

class ComponentModel {
  final String name;
  final String staff;
  final String schoolId;
  final String totalMark;
  final DateTime? dateCreated;
  ComponentModel({
    required this.name,
    required this.staff,
    required this.schoolId,
    required this.totalMark,
    this.dateCreated,
  });

  factory ComponentModel.fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      name: map['name'] ?? '',
      staff: map['staff'] ?? '',
      schoolId: map['schoolId'] ?? '',
      totalMark: map['totalmark']?.toString() ?? '0',
      dateCreated: map['dateCreated'] != null
          ? (map['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "staff": staff,
      "schoolId": schoolId,
      "totalmark": totalMark,
      "dateCreated": dateCreated != null
          ? Timestamp.fromDate(dateCreated!)
          : FieldValue.serverTimestamp(),
    };
  }
}
