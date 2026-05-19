import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';
import '../config/stripe_constants.dart';
import '../model/ledger_entry_model.dart';
import 'api_client.dart';

class DepositIntentResult {
  const DepositIntentResult({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.status,
  });

  final String clientSecret;
  final String paymentIntentId;
  final String status;
}

class StripeService {
  static String? lastCreateDepositIntentError;

  /// Creates a validated deposit intent via the Nest API.
  /// Returns the clientSecret needed for Payment Sheet
  static Future<DepositIntentResult?> createDepositIntent({
    required int amountInCents,
    required String currency,
  }) async {
    try {
      lastCreateDepositIntentError = null;
      final result = await ApiClient.dio.post('/payments/deposit-intents', data: {
        'amount': amountInCents,
        'currency': currency,
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      return DepositIntentResult(
        clientSecret: data['clientSecret'] as String,
        paymentIntentId: data['paymentIntentId'] as String,
        status: data['status'] as String? ?? 'pending',
      );
    } on DioException catch (e) {
      lastCreateDepositIntentError = _messageFromDioException(e);
      debugPrint('Error creating deposit intent: $lastCreateDepositIntentError');
      return null;
    } catch (e) {
      lastCreateDepositIntentError = 'Could not initiate payment. Please try again.';
      debugPrint('Error creating deposit intent: $e');
      return null;
    }
  }

  static String _messageFromDioException(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
      if (message is List && message.isNotEmpty) return message.join('\n');
      final error = data['error'];
      if (error is String && error.isNotEmpty) return error;
    }
    if (e.response?.statusCode == 401) {
      return 'Your session expired. Please log in again.';
    }
    if (e.response?.statusCode == 403) {
      return 'This action is not available for your account yet.';
    }
    return 'Could not initiate payment. Please try again.';
  }

  /// Initialize and present the Stripe Payment Sheet
  static Future<bool> presentPaymentSheet({
    required String clientSecret,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: StripeConstants.merchantDisplayName,
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('Error presenting payment sheet: $e');
      return false;
    }
  }

  /// Fetch the user's current wallet balance
  static Future<double> getWalletBalance(String userId) async {
    try {
      final response = await ApiClient.dio.get(
        '/wallet/balances/${StripeConstants.defaultCurrency}',
      );
      final data = Map<String, dynamic>.from(response.data as Map);
      return (data['available'] ?? 0.0).toDouble();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        return 0.0;
      }
      debugPrint('Error fetching wallet balance: $e');
      return 0.0;
    } catch (e) {
      debugPrint('Error fetching wallet balance: $e');
      return 0.0;
    }
  }

  /// Fetch immutable ledger history for a user.
  static Future<List<LedgerEntryModel>> getTransactionHistory(
    String userId,
  ) async {
    try {
      final response = await ApiClient.dio.get('/wallet/ledger', queryParameters: {
        'limit': 20,
      });
      final rawItems = response.data is List
          ? response.data as List
          : (response.data['items'] as List? ?? const []);
      return rawItems
          .map((item) => LedgerEntryModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        return [];
      }
      debugPrint('Error fetching ledger entries: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching ledger entries: $e');
      return [];
    }
  }
}
