class TimeHour {
  final int hours;
  final int minute;

  TimeHour({
    required this.hours,
    required this.minute,
  });

  TimeHour copyWith({
    int? hours,
    int? minute,
  }) {
    return TimeHour(
      hours: hours ?? this.hours,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hours': hours,
      'minute': minute,
    };
  }

  factory TimeHour.fromMap(Map<String, dynamic> map) {
    return TimeHour(
      hours: map['hours'] as int,
      minute: map['minute'] as int,
    );
  }
  @override
  String toString() => 'TimeHour(hours: $hours, minute: $minute)';

  @override
  bool operator ==(covariant TimeHour other) {
    if (identical(this, other)) return true;

    return other.hours == hours && other.minute == minute;
  }

  @override
  int get hashCode => hours.hashCode ^ minute.hashCode;
}
