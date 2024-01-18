import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/providers/add_submission_provider.dart';

final editBusinessStateProvider =
    StateProvider<EditBusinessState?>((ref) => null);

class EditBusinessState {
  final Business reference;
  File? cover;
  String name;
  String? description;
  BusinessCategory category;
  LocationModel location;
  List<BusinessProductItem> removedProducts = [];
  List<SubmissionProductItem> newProducts = [];
  List<OpenHours> removedOpenHours = [];
  List<OpenHours> newOpenHours = [];
  List<BusinessContentItem> removedContent = [];
  List<BusinessContentItem> newContent = [];

  EditBusinessState(this.reference)
      : name = reference.name,
        description = reference.description,
        category = reference.category,
        location = LocationModel(
          placemark: reference.placemark,
          position: reference.location,
        );
}
