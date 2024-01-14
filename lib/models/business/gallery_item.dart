import 'package:ventureit/models/user_basic.dart';

class GalleryItem {
  final String url;
  final UserBasic author;
  final DateTime updatedAt;

  GalleryItem({
    required this.url,
    required this.author,
    required this.updatedAt,
  });
}
