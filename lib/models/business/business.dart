import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ventureit/models/base_position.dart';

import 'package:ventureit/models/business/business_content.dart';
import 'package:ventureit/models/business/business_model.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';

enum BusinessCategory {
  culinary('Culinary', Icons.food_bank),
  electronic('Electronic', Icons.devices),
  service('Service', Icons.engineering),
  health('Health', Icons.health_and_safety),
  rent('Rent', Icons.car_rental),
  fashion('Fashion', Icons.checkroom),
  grocery('Grocery', Icons.local_grocery_store),
  store('Store', Icons.store);

  const BusinessCategory(this.text, this.icon);

  final String text;
  final IconData icon;
}

class Business extends BusinessModel {
  final String id;
  final String name;
  final Placemark placemark;
  final String cover;
  final String? description;
  final String? phoneNumber;
  final double rating;
  final int ratedBy;
  final Range<int>? priceRange;
  final BusinessCategory category;
  final List<BusinessProductItem> products;
  final List<ExternalLink> externalLinks;
  final BusinessContent contents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.name,
    required this.placemark,
    required super.location,
    required this.cover,
    required this.description,
    required this.phoneNumber,
    required this.rating,
    required this.ratedBy,
    required this.priceRange,
    required this.category,
    required super.openHours,
    required this.products,
    required this.externalLinks,
    required this.contents,
    required this.createdAt,
    required this.updatedAt,
  });

  Business copyWith({
    String? id,
    String? name,
    Placemark? placemark,
    BasePosition? location,
    String? cover,
    String? description,
    String? phoneNumber,
    double? rating,
    int? ratedBy,
    Range<int>? priceRange,
    BusinessCategory? category,
    List<OpenHours>? openHours,
    List<BusinessProductItem>? products,
    List<ExternalLink>? externalLinks,
    BusinessContent? contents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      placemark: placemark ?? this.placemark,
      location: location ?? this.location,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rating: rating ?? this.rating,
      ratedBy: ratedBy ?? this.ratedBy,
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      openHours: openHours ?? this.openHours,
      products: products ?? this.products,
      externalLinks: externalLinks ?? this.externalLinks,
      contents: contents ?? this.contents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'placemark': placemark.toJson(),
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'cover': cover,
      'description': description,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'ratedBy': ratedBy,
      'priceRange': priceRange?.toMap(),
      'category': category.name,
      'openHours': openHours.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      'externalLinks': externalLinks.map((x) => x.toMap()).toList(),
      'contents': contents.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'] as String,
      name: map['name'] as String,
      placemark: Placemark.fromMap(map['placemark'] as Map<String, dynamic>),
      location: BasePosition.fromMap(map['location'] as Map<String, dynamic>),
      cover: map['cover'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      rating: (map['rating'] + 0.0) as double,
      ratedBy: map['ratedBy'] as int,
      priceRange: map['priceRange'] == null
          ? null
          : Range<int>.fromMap(map['priceRange'] as Map<String, dynamic>),
      category: BusinessCategory.values.byName(map['category'] as String),
      openHours: List<OpenHours>.from(
        (map['openHours']).map<OpenHours>(
          (x) => OpenHours.fromMap(x as Map<String, dynamic>),
        ),
      ),
      products: List<BusinessProductItem>.from(
        (map['products']).map<BusinessProductItem>(
          (x) => BusinessProductItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      externalLinks: List<ExternalLink>.from(
        (map['externalLinks']).map<ExternalLink>(
          (x) => ExternalLink.fromMap(x as Map<String, dynamic>),
        ),
      ),
      contents:
          BusinessContent.fromMap(map['contents'] as Map<String, dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }
  @override
  String toString() {
    return 'Business(id: $id, name: $name, placemark: $placemark, location: $location, cover: $cover, description: $description, phoneNumber: $phoneNumber, rating: $rating, ratedBy: $ratedBy, priceRange: $priceRange, category: $category, openHours: $openHours, products: $products, externalLinks: $externalLinks, contents: $contents, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Business other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.placemark == placemark &&
        other.location == location &&
        other.cover == cover &&
        other.description == description &&
        other.phoneNumber == phoneNumber &&
        other.rating == rating &&
        other.ratedBy == ratedBy &&
        other.priceRange == priceRange &&
        other.category == category &&
        listEquals(other.openHours, openHours) &&
        listEquals(other.products, products) &&
        listEquals(other.externalLinks, externalLinks) &&
        other.contents == contents &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        placemark.hashCode ^
        location.hashCode ^
        cover.hashCode ^
        description.hashCode ^
        phoneNumber.hashCode ^
        rating.hashCode ^
        ratedBy.hashCode ^
        priceRange.hashCode ^
        category.hashCode ^
        openHours.hashCode ^
        products.hashCode ^
        externalLinks.hashCode ^
        contents.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
