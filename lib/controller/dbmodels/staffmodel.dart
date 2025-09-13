class Staff {
  final String? id;
  final String name;
  final String accessLevel;
  final String phone;
  final String email;
  final String sex;
  final String region;
  final String level;
  final String status;
  final String schoolname;
  final String schoolId;

  Staff({
    this.id,
    required this.name,
    required this.accessLevel,
    required this.phone,
    required this.email,
    required this.sex,
    required this.region,
    required this.level,
    required this.schoolId,
    required this.schoolname,
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
      "level": level,
      "status": status,
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
    addIfNotEmpty("level", level);

    return data;
  }

  /// Factory constructor for creating Staff from Firestore document
  factory Staff.fromMap(Map<String, dynamic> map, String id) {
    return Staff(
      name: map["name"] ?? "",
      accessLevel: map["accessLevel"] ?? "",
      phone: map["phone"] ?? "",
      email: map["email"] ?? "",
      sex: map["sex"] ?? "",
      region: map["region"] ?? "",
      level: map["level"] ?? "",
      status: map["status"] ?? "0",
      schoolId:  map["schoolid"] ?? "",
      schoolname:  map["school"] ?? "",
    );
  }
}
