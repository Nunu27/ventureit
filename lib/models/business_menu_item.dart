import 'package:flutter/foundation.dart';

class BusinessMenuItem {
  final String name;
  final int price;
  final String description;
  final List<String> pictures;
  final DateTime createdAt;

  BusinessMenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.pictures,
    required this.createdAt,
  });

  BusinessMenuItem copyWith({
    String? name,
    int? price,
    String? description,
    List<String>? pictures,
    DateTime? createdAt,
  }) {
    return BusinessMenuItem(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      pictures: pictures ?? this.pictures,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'description': description,
      'pictures': pictures,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BusinessMenuItem.fromMap(Map<String, dynamic> map) {
    return BusinessMenuItem(
      name: map['name'] as String,
      price: map['price'] as int,
      description: map['description'] as String,
      pictures: List<String>.from(map['pictures']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'BusinessMenuItem(name: $name, price: $price, description: $description, pictures: $pictures, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant BusinessMenuItem other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.price == price &&
        other.description == description &&
        listEquals(other.pictures, pictures) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        price.hashCode ^
        description.hashCode ^
        pictures.hashCode ^
        createdAt.hashCode;
  }
}
