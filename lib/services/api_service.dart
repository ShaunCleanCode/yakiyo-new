import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } catch (e) {
      throw Exception('Failed to make GET request: $e');
    }
  }

  Future<dynamic> post(String path,
      {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to make POST request: $e');
    }
  }

  Future<dynamic> put(String path, {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to make PUT request: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      throw Exception('Failed to make DELETE request: $e');
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_BASE_URL', // API 서버의 기본 URL을 여기에 설정하세요
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  return ApiService(dio);
});
