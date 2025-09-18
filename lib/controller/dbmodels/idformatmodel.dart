import 'package:cloud_firestore/cloud_firestore.dart';

class IdformatModel {
  final String id;
  final String name;
  final int  lastnumber;
  final String staff;
  final String? schoolId;
  final DateTime timestamp;

  IdformatModel({
    required this.id,
    required this.name,
     this.lastnumber =000,
    required this.staff,
    this.schoolId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastnumber': lastnumber,
      'staff': staff,
      'schoolId': schoolId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create from Map (when reading data)
  factory IdformatModel.fromMap(Map<String, dynamic> map, String docId) {
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

    return IdformatModel(
      id: docId,
      name: map['name'] ?? '',
      lastnumber: map['lastnumber'] ?? '',
      staff: map['staff'] ?? '',
      schoolId: map['schoolId'],
      timestamp: parsedTime,
    );
  }
}
