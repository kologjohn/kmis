import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  final List<dynamic> linkedAccounts; // or List<String> if they are always strings
  final String name;
  final String staff;
  final String schoolId;
  final String accountType;
  final String subType;
  final DateTime? dateCreated;

  PaymentMethodModel({
    required this.linkedAccounts,
    required this.staff,
    required this.name,
    required this.schoolId,
    required this.accountType,
    required this.subType,
    this.dateCreated,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      linkedAccounts: map['linkedAccounts'] != null
          ? List<dynamic>.from(map['linkedAccounts'])
          : [],
      staff: map['staff'] ?? '',
      name: map['name'] ?? '',
      subType: map['subType'] ?? '',
      schoolId: map['schoolId'] ?? '',
      accountType: map['accountType']?.toString() ?? '',
      dateCreated: map['dateCreated'] != null
          ? (map['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "linkedAccounts": linkedAccounts,
      "staff": staff,
      "name": name,
      "subType": subType,
      "schoolId": schoolId,
      "accountType": accountType,
      "dateCreated": dateCreated != null
          ? Timestamp.fromDate(dateCreated!)
          : FieldValue.serverTimestamp(),
    };
  }
}
