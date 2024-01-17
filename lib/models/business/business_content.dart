import 'package:flutter/foundation.dart';

import 'package:ventureit/models/business/business_content_item.dart';

class BusinessContent {
  final List<BusinessContentItem> tiktok;
  final List<BusinessContentItem> instagram;

  BusinessContent({
    required this.tiktok,
    required this.instagram,
  });

  BusinessContent copyWith({
    List<BusinessContentItem>? tiktok,
    List<BusinessContentItem>? instagram,
  }) {
    return BusinessContent(
      tiktok: tiktok ?? this.tiktok,
      instagram: instagram ?? this.instagram,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tiktok': tiktok.map((x) => x.toMap()).toList(),
      'instagram': instagram.map((x) => x.toMap()).toList(),
    };
  }

  factory BusinessContent.fromMap(Map<String, dynamic> map) {
    return BusinessContent(
      tiktok: map['tiktok'] != null
          ? List<BusinessContentItem>.from(
              (map['tiktok']).map<BusinessContentItem?>(
                (x) => BusinessContentItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      instagram: map['instagram'] != null
          ? List<BusinessContentItem>.from(
              (map['instagram']).map<BusinessContentItem?>(
                (x) => BusinessContentItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toString() =>
      'BusinessContent(tiktok: $tiktok, instagram: $instagram)';

  @override
  bool operator ==(covariant BusinessContent other) {
    if (identical(this, other)) return true;

    return listEquals(other.tiktok, tiktok) &&
        listEquals(other.instagram, instagram);
  }

  @override
  int get hashCode => tiktok.hashCode ^ instagram.hashCode;
}
