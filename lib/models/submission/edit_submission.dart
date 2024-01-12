import 'package:ventureit/models/submission/submission.dart';

class EditSubmission extends SubmissionData {
  final String key;
  final dynamic from;
  final dynamic to;

  EditSubmission({
    required this.key,
    required this.from,
    required this.to,
  }) : super(SubmissionType.edit);

  EditSubmission copyWith({
    String? key,
    dynamic from,
    dynamic to,
  }) {
    return EditSubmission(
      key: key ?? this.key,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': super.type.name,
      'key': key,
      'from': from,
      'to': to,
    };
  }

  factory EditSubmission.fromMap(Map<String, dynamic> map) {
    return EditSubmission(
      key: map['key'] as String,
      from: map['from'] as dynamic,
      to: map['to'] as dynamic,
    );
  }

  @override
  String toString() => 'EditSubmission(key: $key, from: $from, to: $to)';

  @override
  bool operator ==(covariant EditSubmission other) {
    if (identical(this, other)) return true;

    return other.key == key && other.from == from && other.to == to;
  }

  @override
  int get hashCode => key.hashCode ^ from.hashCode ^ to.hashCode;
}
