import 'package:flutter/foundation.dart';

import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_content.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';
import 'package:ventureit/models/submission/submission.dart';

class EntrySubmission extends SubmissionData {
  final String name;
  final LocationModel location;
  final String cover;
  final String? description;
  final Range<int>? priceRange;
  final BusinessCategory category;
  final List<OpenHours> openHours;
  final List<BusinessProductItem> products;
  final List<ExternalLink> externalLinks;
  final BusinessContent contents;

  EntrySubmission({
    required this.name,
    required this.location,
    required this.cover,
    this.description,
    this.priceRange,
    required this.category,
    required this.openHours,
    required this.products,
    required this.externalLinks,
    required this.contents,
  }) : super(SubmissionType.entry);

  EntrySubmission copyWith({
    String? name,
    LocationModel? location,
    String? cover,
    String? description,
    Range<int>? priceRange,
    BusinessCategory? category,
    List<OpenHours>? openHours,
    List<BusinessProductItem>? products,
    List<ExternalLink>? externalLinks,
    BusinessContent? contents,
  }) {
    return EntrySubmission(
      name: name ?? this.name,
      location: location ?? this.location,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      openHours: openHours ?? this.openHours,
      products: products ?? this.products,
      externalLinks: externalLinks ?? this.externalLinks,
      contents: contents ?? this.contents,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'location': location.toMap(),
      'cover': cover,
      'description': description,
      'priceRange': priceRange?.toMap(),
      'category': category.name,
      'openHours': openHours.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      'externalLinks': externalLinks.map((x) => x.toMap()).toList(),
      'contents': contents.toMap(),
      'type': type.name,
    };
  }

  factory EntrySubmission.fromMap(Map<String, dynamic> map) {
    return EntrySubmission(
      name: map['name'] as String,
      location: LocationModel.fromMap(map['location'] as Map<String, dynamic>),
      cover: map['cover'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      priceRange: map['priceRange'] != null
          ? Range<int>.fromMap(map['priceRange'] as Map<String, dynamic>)
          : null,
      category: BusinessCategory.values.byName(map['category']),
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
    );
  }

  @override
  String toString() {
    return 'EntrySubmission(name: $name, location: $location, cover: $cover, description: $description, priceRange: $priceRange, category: $category, openHours: $openHours, products: $products, externalLinks: $externalLinks, contents: $contents)';
  }

  @override
  bool operator ==(covariant EntrySubmission other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.location == location &&
        other.cover == cover &&
        other.description == description &&
        other.priceRange == priceRange &&
        other.category == category &&
        listEquals(other.openHours, openHours) &&
        listEquals(other.products, products) &&
        listEquals(other.externalLinks, externalLinks) &&
        other.contents == contents;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        location.hashCode ^
        cover.hashCode ^
        description.hashCode ^
        priceRange.hashCode ^
        category.hashCode ^
        openHours.hashCode ^
        products.hashCode ^
        externalLinks.hashCode ^
        contents.hashCode;
  }
}
