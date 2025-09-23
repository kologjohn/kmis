import 'package:cloud_firestore/cloud_firestore.dart';

class FeePaymentModel {
  final String level;
  final String yeargroup;
  final String activityType;
  final String term;
  final String schoolId;
  final DateTime dateCreated;
  final String studentId;
  final String studentName;
  final String ledgerid;
  final String paymentmethod;
  final String receivedaccount;
  final String note;
  final String staff;
  final Map<String, double> fees; // ✅ NEW

  FeePaymentModel({
    required this.level,
    required this.yeargroup,
    required this.activityType,
    required this.term,
    required this.schoolId,
    required this.dateCreated,
    required this.studentId,
    required this.studentName,
    required this.ledgerid,
    required this.paymentmethod,
    required this.receivedaccount,
    required this.note,
    required this.staff,
    required this.fees, // ✅ required now
  });

  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "yeargroup": yeargroup,
      "activityType": activityType,
      "term": term,
      "schoolId": schoolId,
      "dateCreated": dateCreated,
      "studentId": studentId,
      "studentName": studentName,
      "ledgerid": ledgerid,
      "paymentmethod": paymentmethod,
      "receivedaccount": receivedaccount,
      "note": note,
      "staff": staff,
      "fees": fees, // ✅ stored as map in Firestore
    };
  }

  factory FeePaymentModel.fromJson(Map<String, dynamic> json) {
    return FeePaymentModel(
      level: json["level"] ?? "",
      yeargroup: json["yeargroup"] ?? "",
      activityType: json["activityType"] ?? "",
      term: json["term"] ?? "",
      schoolId: json["schoolId"] ?? "",
      dateCreated: (json["dateCreated"] as Timestamp).toDate(),
      studentId: json["studentId"] ?? "",
      studentName: json["studentName"] ?? "",
      ledgerid: json["ledgerid"] ?? "",
      paymentmethod: json["paymentmethod"] ?? "",
      receivedaccount: json["receivedaccount"] ?? "",
      note: json["note"] ?? "",
      staff: json["staff"] ?? "",
      fees: Map<String, double>.from(
        json["fees"] ?? {},
      ), // ✅ convert back to map
    );
  }
}
