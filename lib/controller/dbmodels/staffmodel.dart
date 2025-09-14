import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String? id; // Firestore document ID
  final String authUid;
  final String name;
  final String accessLevel;
  final String phone;
  final String email;
  final String sex;
  final String region;
  final String schoolId;
  final String schoolname;
  final String password;
  final String status; // default "0"

  final DateTime? accountCreatedAt;
  final DateTime? createdAt;

  Staff({
    this.id,
    required this.authUid,
    required this.name,
    required this.accessLevel,
    required this.phone,
    required this.email,
    required this.sex,
    required this.region,
    required this.schoolId,
    required this.schoolname,
    required this.password,
    this.accountCreatedAt,
    this.createdAt,
    this.status = "0",
  });

  /// Convert to Firestore map (for registration)
  Map<String, dynamic> toMapForRegister() {
    return {
      "authUid": authUid,
      "name": name,
      "accessLevel": accessLevel,
      "phone": phone,
      "email": email,
      "sex": sex,
      "region": region,
      "schoolId": schoolId,
      "schoolname": schoolname,
      "password": password,
      "status": status,
      "accountCreatedAt": accountCreatedAt,
      "createdAt": createdAt,
    };
  }

  /// Convert to Firestore map (for update)
  Map<String, dynamic> toMapForUpdate() {
    final Map<String, dynamic> data = {};
    void addIfNotEmpty(String key, dynamic value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        data[key] = value;
      }
    }

    addIfNotEmpty("authUid", authUid);
    addIfNotEmpty("name", name);
    addIfNotEmpty("accessLevel", accessLevel);
    addIfNotEmpty("phone", phone);
    addIfNotEmpty("email", email);
    addIfNotEmpty("sex", sex);
    addIfNotEmpty("region", region);
    addIfNotEmpty("schoolId", schoolId);
    addIfNotEmpty("schoolname", schoolname);
    addIfNotEmpty("password", password);
    addIfNotEmpty("status", status);
    if (accountCreatedAt != null) {
      data["accountCreatedAt"] = accountCreatedAt;
    }
    if (createdAt != null) {
      data["createdAt"] = createdAt;
    }

    return data;
  }

  /// Factory constructor to create Staff from Firestore document
  factory Staff.fromMap(Map<String, dynamic> map, String id) {
    return Staff(
      id: id,
      authUid: map["authUid"] ?? "",
      name: map["name"] ?? "",
      accessLevel: map["accessLevel"] ?? "",
      phone: map["phone"] ?? "",
      email: map["email"] ?? "",
      sex: map["sex"] ?? "",
      region: map["region"] ?? "",
      schoolId: map["schoolId"] ?? "",
      schoolname: map["schoolname"] ?? "",
      password: map["password"] ?? "",
      status: map["status"] ?? "0",
      accountCreatedAt: map["accountCreatedAt"] != null
          ? (map["accountCreatedAt"] as Timestamp).toDate()
          : null,
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] as Timestamp).toDate()
          : null,
    );
  }
}
