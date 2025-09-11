class TermModel {
  final String id;
  final String name;       // term: "name"
  final DateTime? timestamp; // term: "timestamp"

  TermModel({
    required this.id,
    required this.name,
    this.timestamp,

  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timestamp': timestamp?.toIso8601String(),

    };
  }

  // Create from Map (when reading data)
  factory TermModel.fromMap(Map<String, dynamic> map) {
    return TermModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : null,

    );
  }
}
