import 'package:ventureit/models/user.dart';

class UserBasic {
  final String id;
  final String avatar;
  final String name;

  UserBasic({
    required this.id,
    required this.avatar,
    required this.name,
  });

  UserBasic copyWith({
    String? id,
    String? avatar,
    String? name,
  }) {
    return UserBasic(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'name': name,
    };
  }

  factory UserBasic.fromUser(UserModel user) {
    return UserBasic(
      id: user.id,
      avatar: user.avatar,
      name: user.name,
    );
  }

  factory UserBasic.fromMap(Map<String, dynamic> map) {
    return UserBasic(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      name: map['name'] as String,
    );
  }

  @override
  String toString() => 'UserBasic(id: $id, avatar: $avatar, name: $name)';

  @override
  bool operator ==(covariant UserBasic other) {
    if (identical(this, other)) return true;

    return other.id == id && other.avatar == avatar && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ avatar.hashCode ^ name.hashCode;
}
