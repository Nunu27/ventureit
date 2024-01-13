import 'package:algolia/algolia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/algolia_constants.dart';

final algoliaProvider = Provider((ref) {
  return const Algolia.init(
    applicationId: AlgoliaConstants.algoliaId,
    apiKey: AlgoliaConstants.algoliaKey,
  );
});
