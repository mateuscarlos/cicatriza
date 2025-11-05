/// Versão manual da entidade Wound para M1
class WoundManual {
  static const List<String> woundTypes = [
    'Úlcera por pressão',
    'Úlcera venosa',
    'Úlcera arterial',
    'Úlcera diabética',
    'Ferida cirúrgica',
    'Queimadura',
    'Traumática',
    'Outra',
  ];

  static const List<String> woundLocations = [
    'Cabeça/Pescoço',
    'Tórax',
    'Abdome',
    'Costas',
    'Braço direito',
    'Braço esquerdo',
    'Perna direita',
    'Perna esquerda',
    'Pé direito',
    'Pé esquerdo',
    'Mão direita',
    'Mão esquerda',
    'Outra',
  ];

  static const List<String> woundStatuses = [
    'Ativa',
    'Em cicatrização',
    'Cicatrizada',
    'Infectada',
    'Complicada',
  ];

  final String id;
  final String patientId;
  final String type;
  final String location;
  final String? locationDescription;
  final String status;
  final String? causeDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WoundManual({
    required this.id,
    required this.patientId,
    required this.type,
    required this.location,
    this.locationDescription,
    required this.status,
    this.causeDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WoundManual.create({
    required String patientId,
    required String type,
    required String location,
    String? locationDescription,
    String? causeDescription,
  }) {
    final now = DateTime.now();
    return WoundManual(
      id: '',
      patientId: patientId,
      type: type,
      location: location,
      locationDescription: locationDescription?.trim(),
      status: 'Ativa',
      causeDescription: causeDescription?.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'type': type,
      'location': location,
      'locationDescription': locationDescription,
      'status': status,
      'causeDescription': causeDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WoundManual.fromJson(Map<String, dynamic> json) {
    return WoundManual(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      locationDescription: json['locationDescription'] as String?,
      status: json['status'] as String,
      causeDescription: json['causeDescription'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  WoundManual copyWith({
    String? id,
    String? patientId,
    String? type,
    String? location,
    String? locationDescription,
    String? status,
    String? causeDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WoundManual(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      location: location ?? this.location,
      locationDescription: locationDescription ?? this.locationDescription,
      status: status ?? this.status,
      causeDescription: causeDescription ?? this.causeDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'WoundManual(id: $id, type: $type, location: $location, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WoundManual &&
        other.id == id &&
        other.patientId == patientId &&
        other.type == type &&
        other.location == location &&
        other.locationDescription == locationDescription &&
        other.status == status &&
        other.causeDescription == causeDescription &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      patientId,
      type,
      location,
      locationDescription,
      status,
      causeDescription,
      createdAt,
      updatedAt,
    );
  }
}
