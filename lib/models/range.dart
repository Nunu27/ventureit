class Range<T> {
  final T lowerBound;
  final T upperBound;

  Range({
    required this.lowerBound,
    required this.upperBound,
  });

  Range copyWith({
    T? lowerBound,
    T? upperBound,
  }) {
    return Range(
      lowerBound: lowerBound ?? this.lowerBound,
      upperBound: upperBound ?? this.upperBound,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }

  factory Range.fromMap(Map<String, dynamic> map) {
    return Range(
      lowerBound: map['lowerBound'] as T,
      upperBound: map['upperBound'] as T,
    );
  }

  @override
  String toString() =>
      'Range(lowerBound: $lowerBound, upperBound: $upperBound)';

  @override
  bool operator ==(covariant Range other) {
    if (identical(this, other)) return true;

    return other.lowerBound == lowerBound && other.upperBound == upperBound;
  }

  @override
  int get hashCode => lowerBound.hashCode ^ upperBound.hashCode;
}
