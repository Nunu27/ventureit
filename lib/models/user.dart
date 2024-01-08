enum UserRole { member, admin }

class UserModel {
  final String id;
  final String avatar;
  final String email;
  final String username;
  final UserRole role;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.avatar,
    required this.email,
    required this.username,
    required this.role,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? avatar,
    String? email,
    String? username,
    String? password,
    UserRole? role,
    int? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'email': email,
      'fullName': username,
      'role': role.name,
      'balance': balance,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      email: map['email'] as String,
      username: map['fullName'] as String,
      role: UserRole.values.byName(map['role']),
      balance: map['balance'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, avatar: $avatar, email: $email, username: $username, role: $role, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.avatar == avatar &&
        other.email == email &&
        other.username == username &&
        other.role == role &&
        other.balance == balance &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        avatar.hashCode ^
        email.hashCode ^
        username.hashCode ^
        role.hashCode ^
        balance.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
