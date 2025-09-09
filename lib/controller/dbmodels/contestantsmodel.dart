class ContestantModel {
  final String id;
  final String name;
  final String contestantId;
  final String sex;
  final String school;
  final String region;
  final String guardianContact;
  final String level;
  final DateTime timestamp;
  final String photoUrl;
  final String zone;
  final String? status;
  final String votename;

  ContestantModel({
    required this.photoUrl,
    required this.id,
    required this.name,
    required this.contestantId,
    required this.sex,
    required this.school,
    required this.region,
    required this.guardianContact,
    required this.level,
    required this.zone,
    this.status,
    required this.votename,
    required this.timestamp,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contestantId': contestantId,
      'sex': sex,
      'school': school,
      'region': region,
      'guardianContact': guardianContact,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
      'photoUrl': photoUrl,
      'zone': zone,
      'status': "active",
      'votename': "votename",
    };
  }

  // Create from Map (when reading data)
  factory ContestantModel.fromMap(Map<String, dynamic> map) {
    return ContestantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      contestantId: map['contestantId'] ?? '',
      sex: map['sex'] ?? '',
      school: map['school'] ?? '',
      region: map['region'] ?? '',
      guardianContact: map['guardianContact'] ?? '',
      level: map['level'] ?? '',
      zone: map['zone'] ?? '',
      status: map['status'] ?? '',
      votename: map['votename'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(), // Fallback to current time
    );
  }
}
