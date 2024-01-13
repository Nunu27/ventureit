import 'package:flutter/foundation.dart';
import 'package:ventureit/models/base_position.dart';

import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_model.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';

class BusinessBasic extends BusinessModel {
  final String id;
  final String name;
  final String cover;
  final double rating;
  final Range<int>? priceRange;
  final BusinessCategory category;
  final List<String> products;
  final DateTime updatedAt;

  BusinessBasic({
    required this.id,
    required this.name,
    required super.location,
    required this.cover,
    required this.rating,
    required this.priceRange,
    required this.category,
    required super.openHours,
    required this.products,
    required this.updatedAt,
    super.distance,
  });

  BusinessBasic copyWith({
    String? id,
    String? name,
    BasePosition? location,
    String? cover,
    double? rating,
    Range<int>? priceRange,
    BusinessCategory? category,
    List<OpenHours>? openHours,
    List<String>? products,
    DateTime? updatedAt,
  }) {
    return BusinessBasic(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      cover: cover ?? this.cover,
      rating: rating ?? this.rating,
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      openHours: openHours ?? this.openHours,
      products: products ?? this.products,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BusinessBasic.fromMap(Map<String, dynamic> map) {
    return BusinessBasic(
      id: map['objectID'] as String,
      name: map['name'] as String,
      location: BasePosition.fromMap({
        'latitude': map['_geoloc']['lat'],
        'longitude': map['_geoloc']['lon'],
      }),
      cover: map['cover'] as String,
      rating: map['rating'] + 0.0,
      priceRange: map['priceRange'] != null
          ? Range<int>.fromMap(map['priceRange'] as Map<String, dynamic>)
          : null,
      category: BusinessCategory.values.byName(map['category'] as String),
      openHours: List<OpenHours>.from(
        (map['openHours']).map<OpenHours>(
          (x) => OpenHours.fromMap(x as Map<String, dynamic>),
        ),
      ),
      products: List<String>.from(map['products']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'BusinessBasic(id: $id, name: $name, location: $location, cover: $cover, rating: $rating, priceRange: $priceRange, category: $category, openHours: $openHours, products: $products, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BusinessBasic other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.location == location &&
        other.cover == cover &&
        other.rating == rating &&
        other.priceRange == priceRange &&
        other.category == category &&
        listEquals(other.openHours, openHours) &&
        listEquals(other.products, products) &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        cover.hashCode ^
        rating.hashCode ^
        priceRange.hashCode ^
        category.hashCode ^
        openHours.hashCode ^
        products.hashCode ^
        updatedAt.hashCode;
  }
}
