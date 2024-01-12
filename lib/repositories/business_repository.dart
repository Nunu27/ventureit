import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/repositories/storage_repository.dart';

final businessRepositoryProvider = Provider((ref) {
  return BusinessRepository(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

class BusinessRepository {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;

  BusinessRepository(
      {required FirebaseFirestore firestore,
      required StorageRepository storageRepository})
      : _firestore = firestore,
        _storageRepository = storageRepository;

  CollectionReference get _businesses =>
      _firestore.collection(FirestoreConstants.businessCollection);

  Stream<List<Business>> filterBusinesses(
    FilterOptions options,
    GeoFlutterFire geo,
    GeoFirePoint center,
  ) {
    Query query = _businesses.where(
      'category',
      isEqualTo: options.category.name,
    );

    if (options.keyword.isNotEmpty) {
      query = query.where(
        'name',
        isGreaterThanOrEqualTo: options.keyword.isEmpty ? 0 : options.keyword,
        isLessThan: options.keyword.isEmpty
            ? null
            : options.keyword.substring(0, options.keyword.length - 1) +
                String.fromCharCode(
                  options.keyword.codeUnitAt(options.keyword.length - 1) + 1,
                ),
      );
    }

    return geo
        .collection(collectionRef: query)
        .within(
          center: center,
          radius: options.maxDistance.value,
          field: 'location',
          strictMode: true,
        )
        .map(
      (event) {
        List<Business> businesses = [];
        for (var e in event) {
          final business = Business.fromMap(e.data() as Map<String, dynamic>);

          if (options.lastUpdated != null &&
              business.updatedAt.compareTo(options.lastUpdated!.lastDate) <=
                  0) {
            continue;
          }
          if (options.minRating != null &&
              business.rating < options.minRating!.value) {
            continue;
          }
          if (options.openNow) {
            final openHour = business.getOpenHours();
            if (openHour == null || !openHour.isOpen()) continue;
          }

          businesses.add(business);
        }

        businesses.sort((a, b) {
          if (options.sortBy == SortBy.rating) {
            return ((b.rating - a.rating) * 10).toInt();
          } else {
            return (center.distance(
                      lat: a.location.latitude,
                      lng: a.location.longitude,
                    ) -
                    center.distance(
                      lat: b.location.latitude,
                      lng: b.location.longitude,
                    ))
                .round();
          }
        });
        return businesses;
      },
    );
  }
}
