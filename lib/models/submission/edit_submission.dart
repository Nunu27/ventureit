import 'package:ventureit/models/submission/submission.dart';

class EditSubmission extends SubmissionData {
  final String key;
  final dynamic value;

  EditSubmission({
    required this.key,
    required this.value,
  }) : super(SubmissionType.edit);

  EditSubmission copyWith({
    String? key,
    dynamic value,
    dynamic to,
  }) {
    return EditSubmission(
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

  factory EditSubmission.fromMap(Map<String, dynamic> map) {
    return EditSubmission(
      key: map['key'] as String,
      value: map['value'] as dynamic,
    );
  }

  @override
  String toString() => 'EditSubmission(key: $key, value: $value)';

  @override
  bool operator ==(covariant EditSubmission other) {
    if (identical(this, other)) return true;

    return other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
