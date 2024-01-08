enum MissionType { review, contribute }

class Mission {
  final String id;
  final MissionType type;
  final int finishedCount;
  final int maxQuota;

  Mission({
    required this.id,
    required this.type,
    required this.finishedCount,
    required this.maxQuota,
  });

  Mission copyWith({
    String? id,
    MissionType? type,
    int? finishedCount,
    int? maxQuota,
  }) {
    return Mission(
      id: id ?? this.id,
      type: type ?? this.type,
      finishedCount: finishedCount ?? this.finishedCount,
      maxQuota: maxQuota ?? this.maxQuota,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'finishedCount': finishedCount,
      'maxQuota': maxQuota,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'] as String,
      type: MissionType.values.byName(map['type']),
      finishedCount: map['finishedCount'] as int,
      maxQuota: map['maxQuota'] as int,
    );
  }

  @override
  String toString() {
    return 'Mission(id: $id, type: $type, finishedCount: $finishedCount, maxQuota: $maxQuota)';
  }

  @override
  bool operator ==(covariant Mission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.finishedCount == finishedCount &&
        other.maxQuota == maxQuota;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        finishedCount.hashCode ^
        maxQuota.hashCode;
  }
}
