import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_environment.dart';

class ApiClient {
  ApiClient._();

  static Future<void> Function()? onUnauthorized;
  static bool _isHandlingUnauthorized = false;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppEnvironmentConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          }
          handler.next(error);
        },
      ),
    );

  static Future<void> _handleUnauthorized() async {
    if (_isHandlingUnauthorized) return;
    _isHandlingUnauthorized = true;
    try {
      await FirebaseAuth.instance.signOut();
      final storage = GetStorage();
      await storage.remove('phone_login_verified');
      await storage.remove('phone_login_number');
      await storage.remove('phone_login_name');
      await storage.remove('phone_login_email');
      await storage.remove('phone_login_created_at');
      await storage.remove('phone_kyc_completed');
      await storage.remove('phone_kyc_skipped');
      await onUnauthorized?.call();
    } finally {
      _isHandlingUnauthorized = false;
    }
  }
}
