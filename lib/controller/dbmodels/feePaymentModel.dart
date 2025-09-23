import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class FeePaymentModel {
  final String studentId;
  final String staff;
  final String studentName;
  final String level;
  final String yeargroup;
  final String feeName;
  final  String amount;
  final String activityType;
  final String term;
  final String schoolId;
  final String ledgerid;
  final String paymentmethod;
  final String receivedaccount;
  final String note;
  final DateTime? dateCreated;
  FeePaymentModel({
    required this.staff,
    required this.note,
    required this.paymentmethod,
    required this.receivedaccount,
    required this.studentId,
    required this.studentName,
    required this.level,
    required this.yeargroup,
    required this.amount,
    required this.activityType,
    required this.term,
    required this.schoolId,
    required this.feeName,
    required this.ledgerid,
    required this.dateCreated,
  });
  factory FeePaymentModel.fromMap(Map<String, dynamic> map) {
    return FeePaymentModel(
      staff: map['staff'] ?? '',
      note: map['note'] ?? '',
      receivedaccount: map['receivedaccount'] ?? '',
      paymentmethod: map['paymentmethod'] ?? '',
      ledgerid: map['ledgerid'] ?? '',
      studentName: map['studentName'] ?? '',
      studentId: map['studentId'] ?? '',
      level: map['level'] ?? '',
      feeName: map['feeName'] ?? '',
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
      "staff": staff,
      "note": note,
      "receivedaccount": receivedaccount,
      "paymentmethod": paymentmethod,
      "ledgerid": ledgerid,
      "studentName": studentName,
      "studentId": studentId,
      "level": level,
      "feeName": feeName,
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
