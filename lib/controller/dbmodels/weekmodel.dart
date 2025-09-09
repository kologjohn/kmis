import 'package:cloud_firestore/cloud_firestore.dart';

class WeekModel {
  final String id;
  final String weekname;
  final DateTime time;

  WeekModel({
    required this.id,
    required this.weekname,
    required this.time,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': weekname,
      'timestamp': time.toIso8601String(), // stored as String
    };
  }


  factory WeekModel.fromMap(Map<String, dynamic> map) {
    if (map['name'] == null) {
      throw Exception("Missing 'name' field in week data.");
    }

    DateTime parsedTime;
    final rawTimestamp = map['timestamp'];

    if (rawTimestamp is Timestamp) {
      parsedTime = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTime = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTime = DateTime.now(); // fallback
    }

    return WeekModel(
      id: map['id']?.toString() ?? '',
      weekname: map['name'].toString(),
      time: parsedTime,
    );
  }
}
