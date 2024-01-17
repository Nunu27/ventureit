import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/utils/utils.dart';

final apiProvider = StateNotifierProvider<ApiService, bool>((ref) {
  return ApiService();
});

class ApiService extends StateNotifier<bool> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) => true,
    ),
  );

  ApiService() : super(false);

  Future<BusinessContentItem?> getContentData(String url) async {
    state = true;
    try {
      final response = await dio.post('/get-content', data: {'url': url});
      final data = response.data;
      state = false;
      if (!data['success']) throw data['message']!;

      return BusinessContentItem.fromMap(data['data']);
    } catch (e) {
      state = false;
      showSnackBar('Failed to get content data');
      return null;
    }
  }
}
