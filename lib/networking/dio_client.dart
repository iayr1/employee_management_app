import 'package:dio/dio.dart';
import 'package:employee_management_app/networking/api_endpoints.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 3000);
  }

  Future<Response> get(
      {required String path, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> post(
      {required String path, required dynamic data, Options? options}) async {
    try {
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> put(
      {required String path, required dynamic data, Options? options}) async {
    try {
      final response = await _dio.put(path, data: data, options: options);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> delete(
      {required String path, required dynamic data, Options? options}) async {
    try {
      final response = await _dio.delete(path, data: data, options: options);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
