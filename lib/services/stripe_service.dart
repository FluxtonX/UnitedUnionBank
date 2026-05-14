import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/stripe_constants.dart';
import '../model/ledger_entry_model.dart';

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
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Creates a validated deposit intent via Firebase Cloud Function.
  /// Returns the clientSecret needed for Payment Sheet
  static Future<DepositIntentResult?> createDepositIntent({
    required int amountInCents,
    required String currency,
  }) async {
    try {
      final callable = _functions.httpsCallable('createDepositIntent');
      final result = await callable.call(<String, dynamic>{
        'amount': amountInCents,
        'currency': currency,
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      return DepositIntentResult(
        clientSecret: data['clientSecret'] as String,
        paymentIntentId: data['paymentIntentId'] as String,
        status: data['status'] as String? ?? 'pending',
      );
    } catch (e) {
      debugPrint('Error creating deposit intent: $e');
      return null;
    }
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
          style: ThemeMode.system,
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
      final doc = await _firestore
          .collection('wallets')
          .doc(userId)
          .collection('balances')
          .doc(StripeConstants.defaultCurrency)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['available'] ?? 0.0).toDouble();
      }
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
      final querySnapshot = await _firestore
          .collection('ledger_entries')
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => LedgerEntryModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      debugPrint('Error fetching ledger entries: $e');
      return [];
    }
  }
}
