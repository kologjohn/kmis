class StudentModel {
  final String id;             // firestore doc id (unique)
  final String studentid;      // human-readable id (generated)
  final String name;
  final String sex;
  final String school;
  final String region;
  final List<String> guardiancontact; // multiple guardian phones
  final List<String> parentname;      // multiple parent/guardian names
  final String level;
  final String department;
  final String term;
  final String companyid;
  final String dob;            // date of birth as string
  final String address;
  final String? email;
  final String phone;          // student phone number
  final String timestamp;      // registration time as string
  final String photourl;
  final String status;         // single string: active, dropped, completed, etc.

  StudentModel({
    required this.id,
    required this.studentid,
    required this.name,
    required this.sex,
    required this.school,
    required this.region,
    required this.guardiancontact,
    required this.parentname,
    required this.level,
    required this.department,
    required this.term,
    required this.companyid,
    required this.dob,
    required this.address,
    this.email,
    required this.phone,
    required this.timestamp,
    required this.photourl,
    this.status = "active", // default
  });

  /// convert to map (all lowercase keys)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentid': studentid,
      'name': name,
      'sex': sex,
      'school': school,
      'region': region,
      'guardiancontact': guardiancontact,
      'parentname': parentname,
      'level': level,
      'department': department,
      'term': term,
      'companyid': companyid,
      'dob': dob,
      'address': address,
      'email': email,
      'phone': phone,
      'timestamp': timestamp,
      'photourl': photourl,
      'status': status, // string, not list
    };
  }

  /// create from map (all lowercase keys)
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      studentid: map['studentid'] ?? '',
      name: map['name'] ?? '',
      sex: map['sex'] ?? '',
      school: map['school'] ?? '',
      region: map['region'] ?? '',
      guardiancontact: List<String>.from(map['guardiancontact'] ?? []),
      parentname: List<String>.from(map['parentname'] ?? []),
      level: map['level'] ?? '',
      department: map['department'] ?? '',
      term: map['term'] ?? '',
      companyid: map['companyid'] ?? '',
      dob: map['dob'] ?? '',
      address: map['address'] ?? '',
      email: map['email'],
      phone: map['phone'] ?? '',
      timestamp: map['timestamp'] ?? '',
      photourl: map['photourl'] ?? '',
      status: map['status'] ?? 'active',
    );
  }
}
