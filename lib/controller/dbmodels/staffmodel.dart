import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String? id;
  final String name;
  final String accessLevel;
  final String phone;
  final String email;
  final String sex;
  final String region;
  final String status;
  final String schoolname;
  final String schoolId;
  final DateTime createdAt;

  Staff({
    this.id,
    required this.name,
    required this.accessLevel,
    required this.phone,
    required this.email,
    required this.sex,
    required this.region,
    required this.schoolId,
    required this.schoolname,
    required this.createdAt,
    this.status = "0",
  });

  /// Convert model to Firestore map (for registration)
  Map<String, dynamic> toMapForRegister() {
    return {
      "id": id ?? "",
      "name": name,
      "accessLevel": accessLevel,
      "phone": phone,
      "email": email,
      "sex": sex,
      "region": region,
      "status": status,
      "schoolid": schoolId,
      "school": schoolname,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  /// Convert model to Firestore map (for update)
  Map<String, dynamic> toMapForUpdate() {
    final Map<String, dynamic> data = {};
    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        data[key] = value;
      }
    }

    addIfNotEmpty("id", id);
    addIfNotEmpty("name", name);
    addIfNotEmpty("accessLevel", accessLevel);
    addIfNotEmpty("phone", phone);
    addIfNotEmpty("email", email);
    addIfNotEmpty("sex", sex);
    addIfNotEmpty("region", region);
    addIfNotEmpty("schoolid", schoolId);
    addIfNotEmpty("school", schoolname);

    return data;
  }

  /// Factory constructor for creating Staff from Firestore document
  factory Staff.fromMap(Map<String, dynamic> map, String id) {
    return Staff(
      id: id,
      name: map["name"] ?? "",
      accessLevel: map["accessLevel"] ?? "",
      phone: map["phone"] ?? "",
      email: map["email"] ?? "",
      sex: map["sex"] ?? "",
      region: map["region"] ?? "",
      status: map["status"] ?? "0",
      schoolId: map["schoolid"] ?? "",
      schoolname: map["school"] ?? "",
      createdAt: (map["createdAt"] is Timestamp)
          ? (map["createdAt"] as Timestamp).toDate()
          : (map["createdAt"] ?? DateTime.now()),
    );
  }

  /// Convert Staff object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'accessLevel': accessLevel,
      'phone': phone,
      'email': email,
      'sex': sex,
      'region': region,
      'status': status,
      'schoolId': schoolId,
      'schoolname': schoolname,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
