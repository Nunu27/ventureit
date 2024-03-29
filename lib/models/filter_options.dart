import 'package:flutter/material.dart';

import 'package:ventureit/constants/algolia_constants.dart';
import 'package:ventureit/models/business/business.dart';

enum SortBy {
  relevance('Relevance', AlgoliaConstants.businessIndex),
  rating('Rating', AlgoliaConstants.businessIndexRating),
  distance('Distance', AlgoliaConstants.businessIndexDistance);

  const SortBy(this.name, this.searchIndex);

  final String name;
  final String searchIndex;
}

enum MinRating {
  three('3+', 3),
  four('4+', 4),
  fourPointFive('4.5+', 4.5);

  const MinRating(this.name, this.value);

  final String name;
  final double value;
}

enum MaxDistance {
  one('1 km', 1000),
  two('2 km', 2000),
  five('5 km', 5000),
  ten('10 km', 10000),
  twenty('20 km', 20000),
  fifty('50 km', 50000);

  const MaxDistance(this.name, this.value);

  final String name;
  final int value;
}

enum LastUpdated {
  week('7 days', Duration(days: 7)),
  twoWeeks('2 weeks', Duration(days: 14)),
  months('1 month', Duration(days: 30)),
  threeMonths('3 months', Duration(days: 90));

  int get lastDate => DateTime.now().subtract(duration).millisecondsSinceEpoch;

  const LastUpdated(this.name, this.duration);

  final String name;
  final Duration duration;
}

class FilterOptions {
  String keyword;
  BusinessCategory category;
  SortBy sortBy;
  MaxDistance maxDistance;
  MinRating? minRating;
  LastUpdated? lastUpdated;
  bool openNow;

  FilterOptions({
    this.keyword = '',
    this.category = BusinessCategory.culinary,
    this.sortBy = SortBy.rating,
    this.maxDistance = MaxDistance.twenty,
    this.minRating,
    this.openNow = false,
  });

  void setKeyword(String value) {
    keyword = value;
  }

  void setCategory(BusinessCategory value, {Function(VoidCallback)? setState}) {
    category = value;
    if (setState != null) setState(() {});
  }

  void setSortBy(SortBy value, {Function(VoidCallback)? setState}) {
    sortBy = value;
    if (setState != null) setState(() {});
  }

  void setMaxDistance(MaxDistance value, {Function(VoidCallback)? setState}) {
    maxDistance = value;
    if (setState != null) setState(() {});
  }

  void setMinRating(MinRating value, {Function(VoidCallback)? setState}) {
    if (minRating == value) {
      minRating = null;
    } else {
      minRating = value;
    }

    if (setState != null) setState(() {});
  }

  void setLastUpdated(LastUpdated value, {Function(VoidCallback)? setState}) {
    if (lastUpdated == value) {
      lastUpdated = null;
    } else {
      lastUpdated = value;
    }

    if (setState != null) setState(() {});
  }

  void setOpenNow(bool value, {Function(VoidCallback)? setState}) {
    openNow = value;
    if (setState != null) setState(() {});
  }

  FilterOptions copyWith({
    String? keyword,
    BusinessCategory? category,
    SortBy? sortBy,
    MaxDistance? maxDistance,
    MinRating? minRating,
    bool? openNow,
  }) {
    return FilterOptions(
      keyword: keyword ?? this.keyword,
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
      openNow: openNow ?? this.openNow,
    );
  }

  @override
  bool operator ==(covariant FilterOptions other) {
    if (identical(this, other)) return true;

    return other.keyword == keyword &&
        other.category == category &&
        other.sortBy == sortBy &&
        other.maxDistance == maxDistance &&
        other.minRating == minRating &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return keyword.hashCode ^
        category.hashCode ^
        sortBy.hashCode ^
        maxDistance.hashCode ^
        minRating.hashCode ^
        lastUpdated.hashCode;
  }
}
