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
  final MissionType type;
  final int finishedCount;
  final int maxQuota;

  Mission({
    required this.id,
    required this.businessId,
    required this.type,
    required this.finishedCount,
    required this.maxQuota,
  });

  Mission copyWith({
    String? id,
    String? businessId,
    MissionType? type,
    int? finishedCount,
    int? maxQuota,
  }) {
    return Mission(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      finishedCount: finishedCount ?? this.finishedCount,
      maxQuota: maxQuota ?? this.maxQuota,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'businessId': businessId,
      'type': type.name,
      'finishedCount': finishedCount,
      'maxQuota': maxQuota,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'] as String,
      businessId: map['businessId'] as String,
      type: MissionType.values.byName(map['type']),
      finishedCount: map['finishedCount'] as int,
      maxQuota: map['maxQuota'] as int,
    );
  }

  @override
  String toString() {
    return 'Mission(id: $id, businessId: $businessId, type: $type, finishedCount: $finishedCount, maxQuota: $maxQuota)';
  }

  @override
  bool operator ==(covariant Mission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.businessId == businessId &&
        other.type == type &&
        other.finishedCount == finishedCount &&
        other.maxQuota == maxQuota;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        businessId.hashCode ^
        type.hashCode ^
        finishedCount.hashCode ^
        maxQuota.hashCode;
  }
}
