import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_content.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/models/open_hours.dart';

final addSubmissionProvider = StateProvider<AddSubmissionState?>((ref) => null);

class SubmissionProductItem {
  final String name;
  final int price;
  final File? picture;

  SubmissionProductItem({
    required this.name,
    required this.price,
    required this.picture,
  });
}

class AddSubmissionState {
  File? cover;
  String name = '';
  String description = '';
  BusinessCategory? category;
  LocationModel? location;
  List<OpenHours> openHours = [];
  List<ExternalLink> externalLinks = [];
  List<SubmissionProductItem> products = [];
  BusinessContent contents = BusinessContent(tiktok: [], instagram: []);
}
