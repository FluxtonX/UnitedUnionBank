import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../services/stripe_service.dart';
import '../model/ledger_entry_model.dart';
import '../config/stripe_constants.dart';

class WalletController extends GetxController {
  static WalletController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxList<LedgerEntryModel> transactions = <LedgerEntryModel>[].obs;

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

  /// Full Add Funds flow.
  /// Flutter may create/present a Stripe PaymentSheet, but wallet crediting must
  /// happen only in Cloud Functions after webhook confirmation.
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

      if (!isStripeConfigured) {
        Get.snackbar(
          'Payments Unavailable',
          'Stripe is not configured for this environment.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          colorText: Colors.orange,
        );
        return false;
      }

      final int amountInCents = (amount * 100).toInt();

      final depositIntent = await StripeService.createDepositIntent(
        amountInCents: amountInCents,
        currency: StripeConstants.defaultCurrency,
      );

      if (depositIntent == null) {
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
        clientSecret: depositIntent.clientSecret,
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

      Get.snackbar(
        'Payment Submitted',
        'Your wallet will update after backend confirmation.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        colorText: Colors.blue,
      );
      await fetchBalance();
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
