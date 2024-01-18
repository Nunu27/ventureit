import 'package:flutter/foundation.dart';

enum MissionType {
  review('Post a review', 1000),
  contribute('Contribute business data', 2000);

  const MissionType(this.instruction, this.reward);

  final String instruction;
  final int reward;
}

class Mission {
  final String id;
  final String businessId;
  final String businessName;
  final String businessCover;
  final MissionType type;
  final int finishedCount;
  final int maxQuota;
  final List<String> claimedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mission({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessCover,
    required this.type,
    required this.finishedCount,
    required this.maxQuota,
    required this.claimedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Mission copyWith({
    String? id,
    String? businessId,
    String? businessName,
    String? businessCover,
    MissionType? type,
    int? finishedCount,
    int? maxQuota,
    List<String>? claimedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Mission(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessCover: businessCover ?? this.businessCover,
      type: type ?? this.type,
      finishedCount: finishedCount ?? this.finishedCount,
      maxQuota: maxQuota ?? this.maxQuota,
      claimedBy: claimedBy ?? this.claimedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'businessId': businessId,
      'businessName': businessName,
      'businessCover': businessCover,
      'type': type.name,
      'finishedCount': finishedCount,
      'maxQuota': maxQuota,
      'claimedBy': claimedBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'] as String,
      businessId: map['businessId'] as String,
      businessName: map['businessName'] as String,
      businessCover: map['businessCover'] as String,
      type: MissionType.values.byName(map['type']),
      finishedCount: map['finishedCount'] as int,
      maxQuota: map['maxQuota'] as int,
      claimedBy: List<String>.from(map['claimedBy']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Mission(id: $id, businessId: $businessId, businessName: $businessName, businessCover: $businessCover, type: $type, finishedCount: $finishedCount, maxQuota: $maxQuota, claimedBy: $claimedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Mission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.businessId == businessId &&
        other.businessName == businessName &&
        other.businessCover == businessCover &&
        other.type == type &&
        other.finishedCount == finishedCount &&
        other.maxQuota == maxQuota &&
        listEquals(other.claimedBy, claimedBy) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        businessId.hashCode ^
        businessName.hashCode ^
        businessCover.hashCode ^
        type.hashCode ^
        finishedCount.hashCode ^
        maxQuota.hashCode ^
        claimedBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
