import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneModel {
  final String id;
  final String zonename;
  final String? staff;
  final DateTime time;

  ZoneModel({
    required this.id,
    required this.zonename,
    this.staff,
    required this.time,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': zonename,
      'staff': staff,
      'timestamp': Timestamp.fromDate(time),
    };
  }

  // Create from Map (when reading data)
  factory ZoneModel.fromMap(Map<String, dynamic> map) {
    return ZoneModel(
      id: map['name'],
      zonename: map['name'] ?? '',
      staff: map['staff'],
      time: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp'].toString()),
    );
  }
}

