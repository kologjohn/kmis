import 'package:cloud_firestore/cloud_firestore.dart';

class ComponentModel {
  final String name;
  final String totalMark;
  final DateTime? dateCreated; // ✅ nullable

  ComponentModel({
    required this.name,
    required this.totalMark,
    this.dateCreated,
  });

  factory ComponentModel.fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      name: map['name'] ?? '',
      totalMark: map['totalmark']?.toString() ?? '0',
      dateCreated: map['dateCreated'] != null
          ? (map['dateCreated'] as Timestamp).toDate()
          : null, // ✅ safe check
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "totalmark": totalMark,
      "dateCreated": dateCreated != null
          ? Timestamp.fromDate(dateCreated!)
          : FieldValue.serverTimestamp(),
    };
  }
}
