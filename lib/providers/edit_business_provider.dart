import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/providers/add_submission_provider.dart';

final editBusinessProvider = StateProvider<EditBusinessState?>((ref) {
  return null;
});

class EditBusinessState {
  final Business reference;
  File? cover;
  String name;
  String? description;
  BusinessCategory category;
  LocationModel location;
  List<BusinessProductItem> removedProducts = [];
  List<SubmissionProductItem> newProducts = [];
  List<OpenHours> openHours;
  List<BusinessContentItem> contents;
  List<ExternalLink> externalLinks;

  EditBusinessState(this.reference)
      : name = reference.name,
        description = reference.description,
        category = reference.category,
        openHours = reference.openHours,
        contents = reference.contents.tiktok,
        externalLinks = reference.externalLinks,
        location = LocationModel(
          placemark: reference.placemark,
          position: reference.location,
        );
}
