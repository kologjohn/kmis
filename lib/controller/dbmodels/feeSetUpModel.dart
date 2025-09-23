import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class FeeSetUpModel {
  final String name;
  final String staff;
  final String schoolId;
  final DateTime? dateCreated;
  FeeSetUpModel({
    required this.name,
    required this.staff,
    required this.schoolId,
    required this.dateCreated,
  });
  factory FeeSetUpModel.fromMap(Map<String, dynamic> map) {
    return FeeSetUpModel(
      staff: map['staff'] ?? '',
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      dateCreated: map['dateCreated'] != null ? (map['dateCreated'] as Timestamp).toDate() : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "schoolId": schoolId,
      "staff": staff,
      "dateCreated": dateCreated != null
          ? Timestamp.fromDate(dateCreated!)
          : FieldValue.serverTimestamp(),
    };
  }


}
