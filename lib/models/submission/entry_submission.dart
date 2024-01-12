import 'package:flutter/foundation.dart';

import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';
import 'package:ventureit/models/submission/submission.dart';

class EntrySubmission extends SubmissionData {
  final String name;
  final String location;
  final String cover;
  final String? description;
  final List<String> pictures;
  final Range<int> priceRange;
  final BusinessCategory category;
  final List<OpenHours> openHours;
  final List<BusinessProductItem> products;
  final List<String> externalLinks;

  EntrySubmission({
    required this.name,
    required this.location,
    required this.cover,
    this.description,
    required this.pictures,
    required this.priceRange,
    required this.category,
    required this.openHours,
    required this.products,
    required this.externalLinks,
  }) : super(SubmissionType.entry);

  EntrySubmission copyWith({
    String? name,
    String? location,
    String? cover,
    String? description,
    List<String>? pictures,
    Range<int>? priceRange,
    BusinessCategory? category,
    List<OpenHours>? openHours,
    List<BusinessProductItem>? products,
    List<String>? externalLinks,
  }) {
    return EntrySubmission(
      name: name ?? this.name,
      location: location ?? this.location,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      pictures: pictures ?? this.pictures,
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      openHours: openHours ?? this.openHours,
      products: products ?? this.products,
      externalLinks: externalLinks ?? this.externalLinks,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': super.type.name,
      'name': name,
      'location': location,
      'cover': cover,
      'description': description,
      'pictures': pictures,
      'priceRange': priceRange.toMap(),
      'category': category.text,
      'openHours': openHours.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      'externalLinks': externalLinks,
    };
  }

  factory EntrySubmission.fromMap(Map<String, dynamic> map) {
    return EntrySubmission(
      name: map['name'] as String,
      location: map['location'] as String,
      cover: map['cover'] as String,
      description: map['description'] as String?,
      pictures: List<String>.from(map['pictures']),
      priceRange: Range<int>.fromMap(map['priceRange'] as Map<String, dynamic>),
      category: BusinessCategory.values.byName(map['category']),
      openHours: List<OpenHours>.from(
        (map['openHours'] as List<int>).map<OpenHours>(
          (x) => OpenHours.fromMap(x as Map<String, dynamic>),
        ),
      ),
      products: List<BusinessProductItem>.from(
        (map['products'] as List<int>).map<BusinessProductItem>(
          (x) => BusinessProductItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      externalLinks: List<String>.from(map['externalLinks']),
    );
  }

  @override
  String toString() {
    return 'Submission(name: $name, location: $location, cover: $cover, description: $description, pictures: $pictures, priceRange: $priceRange, category: $category, openHours: $openHours, products: $products, externalLinks: $externalLinks)';
  }

  @override
  bool operator ==(covariant EntrySubmission other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.location == location &&
        other.cover == cover &&
        other.description == description &&
        listEquals(other.pictures, pictures) &&
        other.priceRange == priceRange &&
        other.category == category &&
        listEquals(other.openHours, openHours) &&
        listEquals(other.products, products) &&
        listEquals(other.externalLinks, externalLinks);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        location.hashCode ^
        cover.hashCode ^
        description.hashCode ^
        pictures.hashCode ^
        priceRange.hashCode ^
        category.hashCode ^
        openHours.hashCode ^
        products.hashCode ^
        externalLinks.hashCode;
  }
}
