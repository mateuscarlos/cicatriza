class UserProfile {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? crmCofen;
  final String specialty;
  final String timezone;
  final String ownerId;
  final Map<String, dynamic> acl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.crmCofen,
    this.specialty = 'Estomaterapia',
    this.timezone = 'America/Sao_Paulo',
    required this.ownerId,
    this.acl = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      crmCofen: json['crmCofen'] as String?,
      specialty: json['specialty'] as String? ?? 'Estomaterapia',
      timezone: json['timezone'] as String? ?? 'America/Sao_Paulo',
      ownerId: json['ownerId'] as String,
      acl: json['acl'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'crmCofen': crmCofen,
      'specialty': specialty,
      'timezone': timezone,
      'ownerId': ownerId,
      'acl': acl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? crmCofen,
    String? specialty,
    String? timezone,
    String? ownerId,
    Map<String, dynamic>? acl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      crmCofen: crmCofen ?? this.crmCofen,
      specialty: specialty ?? this.specialty,
      timezone: timezone ?? this.timezone,
      ownerId: ownerId ?? this.ownerId,
      acl: acl ?? this.acl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.crmCofen == crmCofen &&
        other.specialty == specialty &&
        other.timezone == timezone &&
        other.ownerId == ownerId &&
        other.acl == acl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      uid,
      email,
      displayName,
      photoURL,
      crmCofen,
      specialty,
      timezone,
      ownerId,
      acl,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, crmCofen: $crmCofen, specialty: $specialty, timezone: $timezone, ownerId: $ownerId, acl: $acl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
