import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/stripe_constants.dart';
import '../model/transaction_model.dart';

class StripeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Creates a PaymentIntent via Firebase Cloud Function
  /// Returns the clientSecret needed for Payment Sheet
  static Future<String?> createPaymentIntent({
    required int amountInCents,
    required String currency,
    required String userId,
  }) async {
    try {
      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call(<String, dynamic>{
        'amount': amountInCents,
        'currency': currency,
        'userId': userId,
      });
      return result.data['clientSecret'] as String?;
    } catch (e) {
      debugPrint('Error creating PaymentIntent: $e');
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

  /// Add funds to user's wallet in Firestore (used in demo mode or after webhook confirmation)
  static Future<double> addFundsToWallet({
    required String userId,
    required double amount,
    String? paymentIntentId,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);

    return _firestore.runTransaction<double>((transaction) async {
      final snapshot = await transaction.get(userRef);

      double currentBalance = 0.0;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        currentBalance = (data['walletBalance'] ?? 0.0).toDouble();
      }

      final newBalance = currentBalance + amount;

      transaction.update(userRef, {'walletBalance': newBalance});

      // Record the transaction
      final txnRef = _firestore.collection('transactions').doc();
      final txn = TransactionModel(
        id: txnRef.id,
        userId: userId,
        amount: amount,
        currency: StripeConstants.defaultCurrency,
        status: TransactionStatus.success,
        type: TransactionType.deposit,
        stripePaymentIntentId: paymentIntentId,
        description: 'Added funds to wallet',
        createdAt: DateTime.now(),
      );
      transaction.set(txnRef, txn.toMap());

      return newBalance;
    });
  }

  /// Fetch the user's current wallet balance
  static Future<double> getWalletBalance(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['walletBalance'] ?? 0.0).toDouble();
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error fetching wallet balance: $e');
      return 0.0;
    }
  }

  /// Fetch transaction history for a user
  static Future<List<TransactionModel>> getTransactionHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => TransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
  }
}
