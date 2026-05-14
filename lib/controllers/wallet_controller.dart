import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../services/stripe_service.dart';
import '../model/transaction_model.dart';
import '../config/stripe_constants.dart';

class WalletController extends GetxController {
  static WalletController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  // 🔧 DEMO MODE: Set to true to test Add Funds without Cloud Functions
  static const bool demoMode = true;

  String get _userId {
    final user = _auth.currentUser;
    if (user != null) return user.uid;
    // Fallback for phone login users
    return _storage.read('phone_login_number') ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
    fetchTransactions();
  }

  /// Fetch wallet balance from Firestore
  Future<void> fetchBalance() async {
    final uid = _userId;
    if (uid.isEmpty) return;

    try {
      final balance = await StripeService.getWalletBalance(uid);
      walletBalance.value = balance;
    } catch (e) {
      debugPrint('Error fetching balance: $e');
    }
  }

  /// Fetch transaction history
  Future<void> fetchTransactions() async {
    final uid = _userId;
    if (uid.isEmpty) return;

    try {
      final txns = await StripeService.getTransactionHistory(uid);
      transactions.assignAll(txns);
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    }
  }

  /// Full Add Funds flow
  /// If demoMode is enabled or Stripe is not configured, it runs in demo mode (directly adds to Firestore).
  /// Otherwise, it uses Stripe Payment Sheet.
  Future<bool> addFunds(double amount) async {
    final uid = _userId;
    if (uid.isEmpty) {
      Get.snackbar(
        'Error',
        'You must be logged in to add funds.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    }

    isProcessingPayment.value = true;

    try {
      final bool isStripeConfigured =
          StripeConstants.publishableKey != 'YOUR_STRIPE_PUBLISHABLE_KEY' &&
          StripeConstants.publishableKey.isNotEmpty;

      // 🔧 DEMO MODE: Skip Stripe payment sheet when demoMode is true
      if (isStripeConfigured && !demoMode) {
        // --- PRODUCTION MODE: Use Stripe Payment Sheet ---
        final int amountInCents = (amount * 100).toInt();

        final clientSecret = await StripeService.createPaymentIntent(
          amountInCents: amountInCents,
          currency: StripeConstants.defaultCurrency,
          userId: uid,
        );

        if (clientSecret == null) {
          Get.snackbar(
            'Payment Error',
            'Could not initiate payment. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
          return false;
        }

        final success = await StripeService.presentPaymentSheet(
          clientSecret: clientSecret,
        );

        if (!success) {
          Get.snackbar(
            'Payment Cancelled',
            'Payment was cancelled or failed.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            colorText: Colors.orange,
          );
          return false;
        }
      } else if (demoMode) {
        // 🔧 DEMO MODE: Show a demo notification
        Get.snackbar(
          '✅ Demo Mode',
          'Adding \$${amount.toStringAsFixed(2)} to your wallet...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          colorText: Colors.blue,
          duration: const Duration(seconds: 2),
        );
        // Add a short delay to simulate payment processing
        await Future.delayed(const Duration(milliseconds: 800));
      }

      // Update wallet balance in Firestore
      final newBalance = await StripeService.addFundsToWallet(
        userId: uid,
        amount: amount,
      );

      walletBalance.value = newBalance;

      // Refresh transaction list
      await fetchTransactions();

      return true;
    } catch (e) {
      debugPrint('Error adding funds: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }
}
