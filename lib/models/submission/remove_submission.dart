import 'package:ventureit/models/submission/submission.dart';

class RemoveSubmission extends SubmissionData {
  final String key;
  final dynamic value;

  RemoveSubmission({
    required this.key,
    required this.value,
  }) : super(SubmissionType.remove);

  RemoveSubmission copyWith({
    String? key,
    dynamic value,
  }) {
    return RemoveSubmission(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': super.type.name,
      'key': key,
      'value': value,
    };
  }

  factory RemoveSubmission.fromMap(Map<String, dynamic> map) {
    return RemoveSubmission(
      key: map['key'] as String,
      value: map['value'] as dynamic,
    );
  }

  @override
  String toString() => 'RemoveSubmission(key: $key, value: $value)';

  @override
  bool operator ==(covariant RemoveSubmission other) {
    if (identical(this, other)) return true;

    return other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
