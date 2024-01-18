import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/mission.dart';
import 'package:ventureit/repositories/mission_repository.dart';
import 'package:ventureit/utils/utils.dart';

final missionControllerProvider =
    StateNotifierProvider<MissionController, bool>((ref) {
  return MissionController(
    repository: ref.watch(missionRepositoryProvider),
    ref: ref,
  );
});

final getBusinessWithMissionProvider = FutureProvider((ref) async {
  final missionController = ref.watch(missionControllerProvider.notifier);
  final location = ref.watch(locationProvider);

  if (location == null) return <String>[];

  return await missionController.getBusinessWithMission(location.position);
});

final fetchMissionsByBusinessesIdProvider =
    StreamProvider.family((ref, List<String> businessesId) {
  return ref
      .watch(missionControllerProvider.notifier)
      .fetchMissionByBusinessesId(businessesId);
});

class MissionController extends StateNotifier<bool> {
  final MissionRepository _repository;
  final Ref _ref;

  MissionController({
    required MissionRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(false);

  Stream<List<Mission>> fetchMissionByBusinessesId(List<String> businessesId) {
    return _repository.fetchMissionByBusinessesId(businessesId);
  }

  Future<List<String>> getBusinessWithMission(BasePosition position) async {
    final res = await _repository.getBusinessWithMission(position);

    return res.fold((l) {
      throw l;
    }, (r) => r);
  }

  void promote({
    required BuildContext context,
    required Business business,
    required int reviewCount,
    required int contributeCount,
  }) async {
    const uuid = Uuid();
    List<Mission> missions = [];

    if (reviewCount > 0) {
      missions.add(
        Mission(
          id: uuid.v4(),
          businessId: business.id,
          businessName: business.name,
          businessCover: business.cover,
          type: MissionType.review,
          finishedCount: 0,
          maxQuota: reviewCount,
          claimedBy: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
    if (contributeCount > 0) {
      missions.add(
        Mission(
          id: uuid.v4(),
          businessId: business.id,
          businessName: business.name,
          businessCover: business.cover,
          type: MissionType.contribute,
          finishedCount: 0,
          maxQuota: contributeCount,
          claimedBy: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    state = true;
    final res = await _repository.save(_ref.read(userProvider)!, missions);
    state = false;

    res.fold((l) => showSnackBar(l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => r);
      showSnackBar('Business promoted.');
      Routemaster.of(context).pop();
    });
  }

  void claim(Mission mission) async {
    state = true;
    final res = await _repository.claim(_ref.read(userProvider)!, mission);
    state = false;

    res.fold(
      (l) => showSnackBar(l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => r);
        showSnackBar('Mission claimed');
      },
    );
  }
}
