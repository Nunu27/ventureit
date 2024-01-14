import 'package:ventureit/models/user_basic.dart';

enum UserRole { member, admin }

class UserModel extends UserBasic {
  final String email;
  final String username;
  final UserRole role;
  final int balance;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required super.id,
    required super.avatar,
    required this.email,
    required super.name,
    required this.username,
    required this.role,
    required this.balance,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  UserModel copyWith({
    String? id,
    String? avatar,
    String? email,
    String? name,
    String? username,
    String? password,
    UserRole? role,
    int? balance,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      balance: balance ?? this.balance,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'email': email,
      'name': name,
      'username': username,
      'role': role.name,
      'balance': balance,
      'fcmToken': fcmToken,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> updateMap() {
    return <String, dynamic>{
      'avatar': avatar,
      'name': name,
      'username': username,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      role: UserRole.values.byName(map['role']),
      balance: map['balance'] as int,
      fcmToken: map['fcmToken'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, avatar: $avatar, email: $email, name: $name, username: $username, role: $role, balance: $balance, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.avatar == avatar &&
        other.email == email &&
        other.name == name &&
        other.username == username &&
        other.role == role &&
        other.balance == balance &&
        other.fcmToken == fcmToken &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        avatar.hashCode ^
        email.hashCode ^
        name.hashCode ^
        username.hashCode ^
        role.hashCode ^
        balance.hashCode ^
        fcmToken.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
