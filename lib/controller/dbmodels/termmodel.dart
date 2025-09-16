import 'package:cloud_firestore/cloud_firestore.dart';

class TermModel {
  final String id;
  final String name;
  final String? schoolId;
  final DateTime timestamp;

  TermModel({
    required this.id,
    required this.name,
    this.schoolId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'schoolId': schoolId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create from Map (when reading data)
  factory TermModel.fromMap(Map<String, dynamic> map, String docId) {
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

    return TermModel(
      id: docId,
      name: map['name'] ?? '',
      schoolId: map['schoolId'],
      timestamp: parsedTime,
    );
  }
}
