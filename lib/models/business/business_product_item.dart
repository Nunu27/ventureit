class BusinessProductItem {
  final String name;
  final int price;
  final String picture;
  final DateTime updatedAt;

  BusinessProductItem({
    required this.name,
    required this.price,
    required this.picture,
    required this.updatedAt,
  });

  BusinessProductItem copyWith({
    String? name,
    int? price,
    String? picture,
    DateTime? updatedAt,
  }) {
    return BusinessProductItem(
      name: name ?? this.name,
      price: price ?? this.price,
      picture: picture ?? this.picture,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'picture': picture,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory BusinessProductItem.fromMap(Map<String, dynamic> map) {
    return BusinessProductItem(
      name: map['name'] as String,
      price: map['price'] as int,
      picture: map['picture'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'BusinessMenuItem(name: $name, price: $price, picture: $picture, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BusinessProductItem other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.price == price &&
        other.picture == picture &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        price.hashCode ^
        picture.hashCode ^
        updatedAt.hashCode;
  }
}
