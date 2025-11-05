/// Versão manual temporária do Patient para testes
class PatientManual {
  final String id;
  final String name;
  final DateTime birthDate;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nameLowercase;
  final String? notes;
  final String? phone;
  final String? email;

  const PatientManual({
    required this.id,
    required this.name,
    required this.birthDate,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
    required this.nameLowercase,
    this.notes,
    this.phone,
    this.email,
  });

  factory PatientManual.create({
    required String name,
    required DateTime birthDate,
    String? notes,
    String? phone,
    String? email,
  }) {
    final now = DateTime.now();
    return PatientManual(
      id: '',
      name: name.trim(),
      birthDate: birthDate,
      nameLowercase: name.trim().toLowerCase(),
      createdAt: now,
      updatedAt: now,
      notes: notes?.trim(),
      phone: phone?.trim(),
      email: email?.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'archived': archived,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'nameLowercase': nameLowercase,
      'notes': notes,
      'phone': phone,
      'email': email,
    };
  }

  factory PatientManual.fromJson(Map<String, dynamic> json) {
    return PatientManual(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      archived: json['archived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      nameLowercase: json['nameLowercase'] as String,
      notes: json['notes'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  PatientManual copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? nameLowercase,
    String? notes,
    String? phone,
    String? email,
  }) {
    return PatientManual(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nameLowercase: nameLowercase ?? this.nameLowercase,
      notes: notes ?? this.notes,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'PatientManual(id: $id, name: $name, birthDate: $birthDate, archived: $archived, nameLowercase: $nameLowercase)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PatientManual &&
        other.id == id &&
        other.name == name &&
        other.birthDate == birthDate &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.nameLowercase == nameLowercase &&
        other.notes == notes &&
        other.phone == phone &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      birthDate,
      archived,
      createdAt,
      updatedAt,
      nameLowercase,
      notes,
      phone,
      email,
    );
  }
}
