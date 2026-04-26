import 'dart:io';

import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl;
  final Dio _dio;
  String? _accessToken;
  String? _refreshToken;

  ApiClient({required this.baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  void setTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void _setupInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.requestOptions.path.contains('/refresh')) {
            return handler.next(error);
          }
          if (error.response?.statusCode == 401 && _refreshToken != null) {
            try {
              final response = await _dio.post(
                '/api/auth/refresh',
                data: {"refreshToken": _refreshToken},
              );

              final newAccessToken = response.data['accessToken'];

              _accessToken = newAccessToken;

              // Retry original request
              final requestOptions = error.requestOptions;

              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              final clonedResponse = await _dio.fetch(requestOptions);

              return handler.resolve(clonedResponse);
            } catch (e) {
              // Refresh failed → logout user
              _accessToken = null;
              _refreshToken = null;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // =============================
  // GET
  // =============================
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  // =============================
  // POST
  // =============================
  Future<Response> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.post(path, data: body, queryParameters: queryParams);
  }

  // =============================
  // PUT
  // =============================
  Future<Response> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.put(path, data: body, queryParameters: queryParams);
  }

  // =============================
  // PATCH
  // =============================
  Future<Response> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.patch(path, data: body);
  }

  // =============================
  // DELETE
  // =============================
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.delete(path, queryParameters: queryParams);
  }

  // =============================
  // MULTIPART
  // =============================
  Future<Response> multipartPost(
    String path, {
    required Map<String, String> fields,
    required File file,
    required String fileFieldName,
    Map<String, dynamic>? queryParams,
  }) async {
    FormData formData = FormData.fromMap({
      ...fields,
      fileFieldName: await MultipartFile.fromFile(file.path),
    });

    return await _dio.post(path, data: formData, queryParameters: queryParams);
  }
}
