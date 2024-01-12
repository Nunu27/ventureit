// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ventureit/models/business/business.dart';

enum SortBy {
  rating('Rating'),
  distance('Distance');

  const SortBy(this.name);

  final String name;
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
  one('1 km', 1),
  two('2 km', 2),
  five('5 km', 5),
  ten('10 km', 10),
  twenty('20 km', 20),
  fifty('50 km', 50);

  const MaxDistance(this.name, this.value);

  final String name;
  final double value;
}

enum LastUpdated {
  week('7 days', Duration(days: 7)),
  twoWeeks('2 weeks', Duration(days: 14)),
  months('1 month', Duration(days: 30)),
  threeMonths('3 months', Duration(days: 90));

  DateTime get lastDate => DateTime.now().subtract(duration);

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
  bool openNow = false;

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
}
