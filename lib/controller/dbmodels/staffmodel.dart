// class Staff {
//   final String? id;
//   final String name;
//   final String accessLevel;
//   final String phone;
//   final String email;
//   final String sex;
//   final String region;
//   final String zone;
//   final String week;
//   final String episode;
//   final String level;
//   final String status;
//
//   Staff({
//     this.id,
//     required this.name,
//     required this.accessLevel,
//     required this.phone,
//     required this.email,
//     required this.sex,
//     required this.region,
//     required this.zone,
//     required this.week,
//     required this.episode,
//     required this.level,
//     this.status = "0",
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       "id": id ?? "",
//       "name": name,
//       "accessLevel": accessLevel,
//       "phone": phone,
//       "email": email,
//       "sex": sex,
//       "region": region,
//       "zone": zone,
//       "week": week,
//       "episode": episode,
//       "level": level,
//       "status": status,
//     };
//   }
// }
class Staff {
  final String? id;
  final String name;
  final String accessLevel;
  final String phone;
  final String email;
  final String sex;
  final String region;
  final String zone;
  final String week;
  final String episode;
  final String level;
  final String status;

  Staff({
    this.id,
    required this.name,
    required this.accessLevel,
    required this.phone,
    required this.email,
    required this.sex,
    required this.region,
    required this.zone,
    required this.week,
    required this.episode,
    required this.level,
    this.status = "0",
  });

  // Map for registration (status included)
  Map<String, dynamic> toMapForRegister() {
    return {
      "id": id ?? "",
      "name": name,
      "accessLevel": accessLevel,
      "phone": phone,
      "email": email,
      "sex": sex,
      "region": region,
      "zone": zone,
      "week": week,
      "episode": episode,
      "level": level,
      "status": status,
    };
  }

  /// Map for update (status excluded, only non-empty fields written)
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
    addIfNotEmpty("zone", zone);
    addIfNotEmpty("week", week);
    addIfNotEmpty("episode", episode);
    addIfNotEmpty("level", level);

    return data;
  }
}


