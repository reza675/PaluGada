class UserModel {
  final String id;
  final String username;
  final String full_name;
  final String email;
  final String phone_number;
  final String avatarUrl;
  final String role;
  final String alt_name;
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.username = '',
    required this.full_name,
    required this.email,
    this.phone_number = '',
    this.avatarUrl = '',
    this.role = 'KOLEKTOR',
    this.alt_name = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone_number: json['phone_number'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      role: json['role'] ?? 'KOLEKTOR',
      alt_name: json['alt_name'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': full_name,
      'email': email,
      'phone_number': phone_number,
      'avatarUrl': avatarUrl,
      'role': role,
      'alt_name': alt_name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? full_name,
    String? email,
    String? phone_number,
    String? avatarUrl,
    String? role,
    String? alt_name,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      full_name: full_name ?? this.full_name,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      alt_name: alt_name ?? this.alt_name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
