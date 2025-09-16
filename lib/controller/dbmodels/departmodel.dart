import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String id;
  final String name;
  final String? schoolId;
  final DateTime timestamp;

  DepartmentModel({
    required this.id,
    required this.name,
    this.schoolId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'companyid': schoolId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }


  factory DepartmentModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parsedTime;

    final ts = map['timestamp'];
    if (ts is Timestamp) {
      parsedTime = ts.toDate();
    } else if (ts is DateTime) {
      parsedTime = ts;
    } else if (ts is String) {
      parsedTime = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      parsedTime = DateTime.now();
    }

    return DepartmentModel(
      id: docId,
      name: map['name'] ?? '',
      schoolId: map['companyid'],
      timestamp: parsedTime,
    );
  }
}
