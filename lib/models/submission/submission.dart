import 'package:flutter/foundation.dart';
import 'package:ventureit/models/submission/add_submission.dart';
import 'package:ventureit/models/submission/edit_submission.dart';
import 'package:ventureit/models/submission/entry_submission.dart';
import 'package:ventureit/models/submission/remove_submission.dart';

enum SubmissionType { add, edit, remove, entry }

abstract class SubmissionData {
  final SubmissionType type;

  SubmissionData(this.type);

  Map<String, dynamic> toMap();
  factory SubmissionData.fromMap(Map<String, dynamic> map) {
    switch (SubmissionType.values.byName(map['type'])) {
      case SubmissionType.add:
        return AddSubmission.fromMap(map);
      case SubmissionType.edit:
        return EditSubmission.fromMap(map);
      case SubmissionType.remove:
        return RemoveSubmission.fromMap(map);
      case SubmissionType.entry:
        return EntrySubmission.fromMap(map);
      default:
        throw 'Invalid submission type';
    }
  }
}

class Submission {
  final String id;
  final String userId;
  final String? businessId;
  final List<SubmissionData> submissionData;
  final DateTime createdAt;

  Submission({
    required this.id,
    required this.userId,
    this.businessId,
    required this.submissionData,
    required this.createdAt,
  });

  Submission copyWith({
    String? id,
    String? userId,
    String? businessId,
    List<SubmissionData>? submissionData,
    DateTime? createdAt,
  }) {
    return Submission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      submissionData: submissionData ?? this.submissionData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'submissionData': submissionData.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Submission.fromMap(Map<String, dynamic> map) {
    return Submission(
      id: map['id'] as String,
      userId: map['userId'] as String,
      businessId:
          map['businessId'] != null ? map['businessId'] as String : null,
      submissionData: List<SubmissionData>.from(
        (map['submissionData'] as List<int>).map<SubmissionData>(
          (x) => SubmissionData.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Submission(id: $id, userId: $userId, businessId: $businessId, submissionData: $submissionData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Submission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.businessId == businessId &&
        listEquals(other.submissionData, submissionData) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        businessId.hashCode ^
        submissionData.hashCode ^
        createdAt.hashCode;
  }
}
