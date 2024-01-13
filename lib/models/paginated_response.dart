import 'package:algolia/algolia.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final int page;
  final int totalPages;
  final int totalResults;

  PaginatedResponse({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory PaginatedResponse.fromAlgolia(
    AlgoliaQuerySnapshot snapshot,
    List<T> items,
  ) {
    return PaginatedResponse(
      items: items,
      page: snapshot.page,
      totalPages: snapshot.nbPages,
      totalResults: snapshot.nbHits,
    );
  }
}
