import '../config/stripe_constants.dart';
import 'api_client.dart';

class DonationResult {
  const DonationResult({
    required this.donationId,
    required this.receiptNumber,
    required this.status,
  });

  final String donationId;
  final String receiptNumber;
  final String status;
}

class WithdrawalRequestResult {
  const WithdrawalRequestResult({
    required this.requestId,
    required this.status,
  });

  final String requestId;
  final String status;
}

class WalletActionService {
  WalletActionService._();

  static Future<DonationResult> createDonation({
    required String projectId,
    required int amountInCents,
  }) async {
    final result = await ApiClient.dio.post('/donations', data: {
      'projectId': projectId,
      'amountInCents': amountInCents,
      'currency': StripeConstants.defaultCurrency,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    return DonationResult(
      donationId: data['donationId'] as String,
      receiptNumber: data['receiptNumber'] as String,
      status: data['status'] as String,
    );
  }

  static Future<WithdrawalRequestResult> createWithdrawalRequest({
    required int amountInCents,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String routingNumber,
  }) async {
    final result = await ApiClient.dio.post('/withdrawals/requests', data: {
      'amountInCents': amountInCents,
      'currency': StripeConstants.defaultCurrency,
      'destination': {
        'accountHolderName': accountHolderName,
        'bankName': bankName,
        'accountNumberLast4': _last4(accountNumber),
        'routingNumberLast4': _last4(routingNumber),
      },
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    return WithdrawalRequestResult(
      requestId: data['requestId'] as String,
      status: data['status'] as String,
    );
  }

  static String _last4(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 4) return digits;
    return digits.substring(digits.length - 4);
  }
}
