import 'package:ventureit/models/submission/submission.dart';

class AddSubmission extends SubmissionData {
  final String key;
  final dynamic value;

  AddSubmission({
    required this.key,
    required this.value,
  }) : super(SubmissionType.add);

  AddSubmission copyWith({
    String? key,
    dynamic value,
  }) {
    return AddSubmission(
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

  factory AddSubmission.fromMap(Map<String, dynamic> map) {
    return AddSubmission(
      key: map['key'] as String,
      value: map['value'] as dynamic,
    );
  }

  @override
  String toString() => 'AddSubmission(key: $key, value: $value)';

  @override
  bool operator ==(covariant AddSubmission other) {
    if (identical(this, other)) return true;

    return other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
