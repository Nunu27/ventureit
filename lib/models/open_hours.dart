import 'package:ventureit/models/time_hour.dart';
import 'package:ventureit/models/range.dart';

class OpenHours {
  final Range<int> days;
  final Range<TimeHour> hours;

  OpenHours({
    required this.days,
    required this.hours,
  });

  bool isOpen() {
    if (hours.lowerBound == hours.upperBound) return true;

    final now = DateTime.now();
    final hour = now.hour * 60 + now.minute;

    return days.lowerBound <= now.weekday &&
        days.upperBound >= now.weekday &&
        hours.lowerBound <= hour &&
        hours.upperBound >= hour;
  }

  OpenHours copyWith({
    Range<int>? days,
    Range<TimeHour>? hours,
  }) {
    return OpenHours(
      days: days ?? this.days,
      hours: hours ?? this.hours,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'days': days.toMap(),
      'hours': hours.toMap(),
    };
  }

  factory OpenHours.fromMap(Map<String, dynamic> map) {
    return OpenHours(
      days: Range<int>.fromMap(map['days'] as Map<String, dynamic>),
      hours: Range<TimeHour>.fromMap(map['hours'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => hours.lowerBound == hours.upperBound
      ? '24 hours'
      : '${hours.lowerBound.toString()}-${hours.upperBound.toString()}';

  @override
  bool operator ==(covariant OpenHours other) {
    if (identical(this, other)) return true;

    return other.days == days && other.hours == hours;
  }

  @override
  int get hashCode => days.hashCode ^ hours.hashCode;
}
