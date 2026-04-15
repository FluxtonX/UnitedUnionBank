import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/twilio_constants.dart';

class TwilioService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://verify.twilio.com/v2',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final basicAuth = base64Encode(
            utf8.encode('${TwilioConstants.accountSid}:${TwilioConstants.authToken}'),
          );
          options.headers['Authorization'] = 'Basic $basicAuth';
          handler.next(options);
        },
      ),
    );

  static Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      final response = await _dio.post(
        '/Services/${TwilioConstants.verifyServiceSid}/Verifications',
        data: {
          'To': phoneNumber,
          'Channel': 'sms',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } on DioError catch (e) {
      final code = e.response?.statusCode;
      final message = e.response?.data ?? e.message;
      throw Exception('Twilio send error $code: $message');
    }
  }

  static Future<void> verifyCode(String phoneNumber, String code) async {
    try {
      final response = await _dio.post(
        '/Services/${TwilioConstants.verifyServiceSid}/VerificationCheck',
        data: {
          'To': phoneNumber,
          'Code': code,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final status = response.data['status']?.toString().toLowerCase();
      if (status != 'approved') {
        throw Exception('OTP verification failed.');
      }
    } on DioError catch (e) {
      final code = e.response?.statusCode;
      final message = e.response?.data ?? e.message;
      throw Exception('Twilio verify error $code: $message');
    }
  }
}
