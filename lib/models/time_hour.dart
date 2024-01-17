import 'package:flutter/material.dart';
import 'package:ventureit/utils/utils.dart';

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

  int toMap() {
    return hours * 60 + minute;
  }

  factory TimeHour.fromMap(int map) {
    return TimeHour(
      hours: (map / 60).floor(),
      minute: map % 60,
    );
  }

  factory TimeHour.fromTimeOfDay(TimeOfDay timeOfDay) {
    return TimeHour(
      hours: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
  }

  @override
  String toString() => '${padTime(hours)}:${padTime(minute)}';

  @override
  bool operator ==(covariant TimeHour other) {
    if (identical(this, other)) return true;

    return other.hours == hours && other.minute == minute;
  }

  bool operator <=(covariant int other) {
    if (identical(this, other)) return true;

    return (hours * 60 + minute) < other;
  }

  bool operator >=(covariant int other) {
    if (identical(this, other)) return true;

    return (hours * 60 + minute) > other;
  }

  @override
  int get hashCode => hours.hashCode ^ minute.hashCode;
}
