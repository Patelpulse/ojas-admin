import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  // In debug mode hit the local backend (all routes are up to date).
  // In release/production build hit the live VPS.
  static const String _prodUrl = 'http://72.61.172.182/api';
  static const String _devUrl  = 'http://localhost:5001/api';
  static String get baseUrl => kDebugMode ? _devUrl : _prodUrl;

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('admin_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Log full error details for easier debugging
          debugPrint('[ApiService] ${error.requestOptions.method} '
              '${error.requestOptions.uri} → '
              '${error.response?.statusCode} ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
