import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class BilledModel {
  final  level;
  final String yeargroup;
  final  String amount;
  final String activityType;
  final String term;
  final String schoolId;
  final DateTime? dateCreated;
  BilledModel({
    required this.level,
    required this.yeargroup,
    required this.amount,
    required this.activityType,
    required this.term,
    required this.schoolId,
    required this.dateCreated,
  });
  factory BilledModel.fromMap(Map<String, dynamic> map) {
    return BilledModel(
      level: map['level'] ?? '',
      yeargroup: map['yeargroup'] ?? '',
      schoolId: map['schoolId'] ?? '',
      activityType: map['activityType'] ?? '',
      term: map['term'] ?? '',
      amount: map['amount']?.toString() ?? '0',
      dateCreated: map['dateCreated'] != null ? (map['dateCreated'] as Timestamp).toDate() : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "yeargroup": yeargroup,
      "schoolId": schoolId,
      "activityType": activityType,
      "term": term,
      "amount": amount,
      "dateCreated": dateCreated != null
          ? Timestamp.fromDate(dateCreated!)
          : FieldValue.serverTimestamp(),
    };
  }


}
