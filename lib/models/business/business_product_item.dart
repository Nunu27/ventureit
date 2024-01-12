import 'package:flutter/foundation.dart';

class BusinessProductItem {
  final String name;
  final int price;
  final List<String> pictures;
  final DateTime updatedAt;

  BusinessProductItem({
    required this.name,
    required this.price,
    required this.pictures,
    required this.updatedAt,
  });

  BusinessProductItem copyWith({
    String? name,
    int? price,
    List<String>? pictures,
    DateTime? updatedAt,
  }) {
    return BusinessProductItem(
      name: name ?? this.name,
      price: price ?? this.price,
      pictures: pictures ?? this.pictures,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'pictures': pictures,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory BusinessProductItem.fromMap(Map<String, dynamic> map) {
    return BusinessProductItem(
      name: map['name'] as String,
      price: map['price'] as int,
      pictures: List<String>.from(map['pictures']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'BusinessMenuItem(name: $name, price: $price, pictures: $pictures, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BusinessProductItem other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.price == price &&
        listEquals(other.pictures, pictures) &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        price.hashCode ^
        pictures.hashCode ^
        updatedAt.hashCode;
  }
}
