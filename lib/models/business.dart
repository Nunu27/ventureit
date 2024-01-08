import 'package:flutter/foundation.dart';

import 'package:ventureit/models/business_menu_item.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';

enum BusinessCategory {
  culinary,
  electronic,
  printService,
  mechanicService,
  health,
  rent,
  fashion,
  grocery,
  store
}

class Business {
  final String id;
  final String name;
  final String location;
  final String cover;
  final List<String> pictures;
  final Range<int> priceRange;
  final String description;
  final BusinessCategory category;
  final List<OpenHours> openHours;
  final List<BusinessMenuItem> menu;
  final List<String> externalLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.name,
    required this.location,
    required this.cover,
    required this.pictures,
    required this.priceRange,
    required this.description,
    required this.category,
    required this.openHours,
    required this.menu,
    required this.externalLinks,
    required this.createdAt,
    required this.updatedAt,
  });

  Business copyWith({
    String? id,
    String? name,
    String? location,
    String? cover,
    List<String>? pictures,
    Range<int>? priceRange,
    String? description,
    BusinessCategory? category,
    List<OpenHours>? openHours,
    List<BusinessMenuItem>? menu,
    List<String>? externalLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      cover: cover ?? this.cover,
      pictures: pictures ?? this.pictures,
      priceRange: priceRange ?? this.priceRange,
      description: description ?? this.description,
      category: category ?? this.category,
      openHours: openHours ?? this.openHours,
      menu: menu ?? this.menu,
      externalLinks: externalLinks ?? this.externalLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'cover': cover,
      'pictures': pictures,
      'priceRange': priceRange.toMap(),
      'description': description,
      'category': category.toString(),
      'openHours': openHours.map((x) => x.toMap()).toList(),
      'menu': menu.map((x) => x.toMap()).toList(),
      'externalLinks': externalLinks,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String,
      cover: map['cover'] as String,
      pictures: List<String>.from(map['pictures']),
      priceRange: Range<int>.fromMap(map['priceRange'] as Map<String, dynamic>),
      description: map['description'] as String,
      category: BusinessCategory.values.byName(map['category']),
      openHours: List<OpenHours>.from(
        (map['openHours'] as List<int>).map<OpenHours>(
          (x) => OpenHours.fromMap(x as Map<String, dynamic>),
        ),
      ),
      menu: List<BusinessMenuItem>.from(
        (map['menu'] as List<int>).map<BusinessMenuItem>(
          (x) => BusinessMenuItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      externalLinks: List<String>.from(map['externalLinks']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Business(id: $id, name: $name, location: $location, cover: $cover, pictures: $pictures, priceRange: $priceRange, description: $description, category: $category, openHours: $openHours, menu: $menu, externalLinks: $externalLinks, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Business other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.location == location &&
        other.cover == cover &&
        listEquals(other.pictures, pictures) &&
        other.priceRange == priceRange &&
        other.description == description &&
        other.category == category &&
        listEquals(other.openHours, openHours) &&
        listEquals(other.menu, menu) &&
        listEquals(other.externalLinks, externalLinks) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        cover.hashCode ^
        pictures.hashCode ^
        priceRange.hashCode ^
        description.hashCode ^
        category.hashCode ^
        openHours.hashCode ^
        menu.hashCode ^
        externalLinks.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
