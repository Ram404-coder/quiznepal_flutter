class User {
  final int? id;
  final String email;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  User({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  // Convert User to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email.toLowerCase().trim(),
      'password_hash': passwordHash,
      'salt': salt,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  // Create User from database Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      passwordHash: map['password_hash'],
      salt: map['salt'],
      createdAt: DateTime.parse(map['created_at']),
      lastLogin: map['last_login'] != null 
          ? DateTime.parse(map['last_login']) 
          : null,
      isActive: map['is_active'] == 1,
    );
  }

  // Copy with method for updates
  User copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}
