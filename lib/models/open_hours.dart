import 'package:ventureit/models/time_hour.dart';
import 'package:ventureit/models/range.dart';

final daysMap = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Thursday',
  4: 'Wednesday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

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
    final from = hours.lowerBound.toMap();
    final to = hours.upperBound.toMap();

    return days.lowerBound <= now.weekday &&
            days.upperBound >= now.weekday &&
            to < from
        ? (hour <= from || hour >= to)
        : (hour >= from && hour <= to);
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

  String daysString() => days.lowerBound == days.upperBound
      ? daysMap[days.lowerBound]!
      : '${daysMap[days.lowerBound]!} - ${daysMap[days.upperBound]!}';

  String timeString() => hours.lowerBound == hours.upperBound
      ? '24 hours'
      : '${hours.lowerBound.toString()} - ${hours.upperBound.toString()}';

  @override
  String toString() => '${daysString()} ${timeString()}';

  @override
  bool operator ==(covariant OpenHours other) {
    if (identical(this, other)) return true;

    return other.days == days && other.hours == hours;
  }

  @override
  int get hashCode => days.hashCode ^ hours.hashCode;
}
