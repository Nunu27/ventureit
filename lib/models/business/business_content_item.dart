class BusinessContentItem {
  final String cover;
  final String link;
  final String createdAt;

  BusinessContentItem({
    required this.cover,
    required this.link,
    required this.createdAt,
  });

  BusinessContentItem copyWith({
    String? cover,
    String? link,
    String? createdAt,
  }) {
    return BusinessContentItem(
      cover: cover ?? this.cover,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cover': cover,
      'link': link,
      'createdAt': createdAt,
    };
  }

  factory BusinessContentItem.fromMap(Map<String, dynamic> map) {
    return BusinessContentItem(
      cover: map['cover'] as String,
      link: map['link'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  @override
  String toString() =>
      'BusinessContent(cover: $cover, link: $link, createdAt: $createdAt)';

  @override
  bool operator ==(covariant BusinessContentItem other) {
    if (identical(this, other)) return true;

    return other.cover == cover &&
        other.link == link &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => cover.hashCode ^ link.hashCode ^ createdAt.hashCode;
}
