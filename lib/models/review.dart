import 'package:flutter/foundation.dart';
import 'package:ventureit/models/business/gallery_item.dart';
import 'package:ventureit/models/user_basic.dart';

class Review {
  final String id;
  final String businessId;
  final double rating;
  final List<String> mediaList;
  final String? description;
  final int voteCount;
  final List<String> upvotes;
  final List<String> downvotes;
  final UserBasic author;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.businessId,
    required this.rating,
    required this.mediaList,
    required this.description,
    required this.voteCount,
    required this.upvotes,
    required this.downvotes,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  Review copyWith({
    String? id,
    String? businessId,
    double? rating,
    List<String>? mediaList,
    String? description,
    int? voteCount,
    List<String>? upvotes,
    List<String>? downvotes,
    UserBasic? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      rating: rating ?? this.rating,
      mediaList: mediaList ?? this.mediaList,
      description: description ?? this.description,
      voteCount: voteCount ?? this.voteCount,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<GalleryItem> toGalleryList() {
    return mediaList
        .map((e) => GalleryItem(
              url: e,
              author: author,
              updatedAt: updatedAt,
            ))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'businessId': businessId,
      'rating': rating,
      'mediaList': mediaList,
      'description': description,
      'voteCount': voteCount,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'author': author.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> updateMap() {
    return <String, dynamic>{
      'rating': rating,
      'mediaList': mediaList,
      'description': description,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      businessId: map['businessId'] as String,
      rating: map['rating'] as double,
      mediaList: List<String>.from(map['mediaList']),
      description: map['description'] as String?,
      voteCount: map['voteCount'] as int,
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      author: UserBasic.fromMap(map['author'] as Map<String, dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, businessId: $businessId, rating: $rating, mediaList: $mediaList, description: $description, voteCount: $voteCount, upvotes: $upvotes, downvotes: $downvotes, author: $author, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.businessId == businessId &&
        other.rating == rating &&
        listEquals(other.mediaList, mediaList) &&
        other.description == description &&
        other.voteCount == voteCount &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.author == author &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        businessId.hashCode ^
        rating.hashCode ^
        mediaList.hashCode ^
        description.hashCode ^
        voteCount.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        author.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }
}
