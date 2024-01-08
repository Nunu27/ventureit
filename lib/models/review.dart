import 'package:flutter/foundation.dart';

class Review {
  final String id;
  final String userId;
  final String businessId;
  final int rating;
  final List<String> mediaList;
  final String description;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.rating,
    required this.mediaList,
    required this.description,
    required this.createdAt,
  });

  Review copyWith({
    String? id,
    String? userId,
    String? businessId,
    int? rating,
    List<String>? mediaList,
    String? description,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      rating: rating ?? this.rating,
      mediaList: mediaList ?? this.mediaList,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'rating': rating,
      'mediaList': mediaList,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      userId: map['userId'] as String,
      businessId: map['businessId'] as String,
      rating: map['rating'] as int,
      mediaList: List<String>.from(map['mediaList']),
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
  @override
  String toString() {
    return 'Review(id: $id, userId: $userId, businessId: $businessId, rating: $rating, mediaList: $mediaList, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.businessId == businessId &&
        other.rating == rating &&
        listEquals(other.mediaList, mediaList) &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        businessId.hashCode ^
        rating.hashCode ^
        mediaList.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
