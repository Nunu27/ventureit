import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_basic.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/models/paginated_response.dart';
import 'package:ventureit/providers/algolia_provider.dart';
import 'package:ventureit/providers/firebase_provider.dart';

final businessRepositoryProvider = Provider((ref) {
  return BusinessRepository(
    firestore: ref.watch(firestoreProvider),
    ref: ref,
  );
});

class BusinessRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  BusinessRepository({
    required FirebaseFirestore firestore,
    required Ref ref,
  })  : _firestore = firestore,
        _ref = ref;

  CollectionReference get _businesses =>
      _firestore.collection(FirestoreConstants.businessCollection);

  Stream<Business> getBusinessById(String id) {
    return _businesses
        .doc(id)
        .snapshots()
        .map((event) => Business.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<Business> getBusinessById(String id) {
    return _businesses
        .doc(id)
        .snapshots()
        .map((event) => Business.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<PaginatedResponse<BusinessBasic>> filterBusinesses(
    FilterOptions options,
    int page,
    BasePosition position,
  ) async {
    String filters = 'category:${options.category.name}';

    if (options.minRating != null) {
      filters += ' AND rating >= ${options.minRating!.value}';
    }
    if (options.lastUpdated != null) {
      filters += ' AND updatedAt >= ${options.lastUpdated!.lastDate}';
    }

    AlgoliaQuery query = _ref
        .read(algoliaProvider)
        .index(options.sortBy.searchIndex)
        .filters(filters)
        .setAroundLatLng('${position.latitude}, ${position.longitude}')
        .setAroundRadius(options.maxDistance.value);

    if (options.keyword.isNotEmpty) {
      query = query.query(options.keyword);
    }

    query = query.setHitsPerPage(Constants.dataPerPage).setPage(page);

    final snapshot = await query.getObjects();

    return PaginatedResponse.fromAlgolia(
      snapshot,
      snapshot.hits.map((e) => BusinessBasic.fromMap(e.data)).toList(),
    );
  }
}
