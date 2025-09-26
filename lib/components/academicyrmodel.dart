import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicModel {
  final String id;
  final String name;
  final String idd;
  final String staff;
  final String? schoolid;
  final DateTime timestamp;

  AcademicModel({
    required this.id,
    required this.idd,
    required this.staff,
    required this.name,
    this.schoolid,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idd': idd,
      'staff': staff,
      'name': name,
      'schoolid': schoolid,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create from Map (when reading data)
  factory AcademicModel.fromMap(Map<String, dynamic> map, String docId) {
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

    return AcademicModel(
      id: docId,
      name: map['name'] ?? '',
      idd: map['idd'] ?? '',
      staff: map['staff'] ?? '',
      schoolid: map['schoolid'],
      timestamp: parsedTime,
    );
  }
}
