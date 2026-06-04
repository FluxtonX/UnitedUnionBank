import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../services/stripe_service.dart';
import '../model/ledger_entry_model.dart';
import '../config/stripe_constants.dart';

class AddFundsResult {
  const AddFundsResult({
    required this.amount,
    required this.previousBalance,
    required this.displayBalance,
    required this.confirmed,
  });

  final double amount;
  final double previousBalance;
  final double displayBalance;
  final bool confirmed;
}

class WalletController extends GetxController with WidgetsBindingObserver {
  static WalletController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxList<LedgerEntryModel> transactions = <LedgerEntryModel>[].obs;
  StreamSubscription<User?>? _authSubscription;
  String? _lastLoadedUserId;

  String get _userId {
    final user = _auth.currentUser;
    if (user != null) return user.uid;
    // Fallback for phone login users
    return _storage.read('phone_login_number') ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _authSubscription = _auth.authStateChanges().listen((user) {
      final nextUserId = user?.uid ?? _storage.read('phone_login_number') ?? '';
      if (nextUserId != _lastLoadedUserId) {
        _lastLoadedUserId = nextUserId;
        if (nextUserId.isEmpty) {
          walletBalance.value = 0;
          transactions.clear();
        } else {
          refreshWallet();
        }
      }
    });
    refreshWallet();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshWallet();
    }
  }

  Future<void> refreshWallet() async {
    await Future.wait([fetchBalance(), fetchTransactions()]);
  }

  /// Fetch wallet balance from Firestore
  Future<void> fetchBalance() async {
    final uid = _userId;
    if (uid.isEmpty) return;

    try {
      final balance = await StripeService.getWalletBalance(uid);
      walletBalance.value = balance;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        walletBalance.value = 0;
        return;
      }
      debugPrint('Error fetching balance: $e');
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        transactions.clear();
        return;
      }
      debugPrint('Error fetching transactions: $e');
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    }
  }

  /// Full Add Funds flow.
  /// Flutter presents Stripe PaymentSheet. Wallet crediting happens only on the
  /// backend after Stripe webhook confirmation.
  Future<AddFundsResult?> addFunds(double amount) async {
    final uid = _userId;
    if (uid.isEmpty) {
      Get.snackbar(
        'Error',
        'You must be logged in to add funds.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return null;
    }

    isProcessingPayment.value = true;
    final previousBalance = walletBalance.value;

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
        return null;
      }

      final int amountInCents = (amount * 100).toInt();

      final depositIntent = await StripeService.createDepositIntent(
        amountInCents: amountInCents,
        currency: StripeConstants.defaultCurrency,
      );

      if (depositIntent == null) {
        Get.snackbar(
          'Payment Error',
          StripeService.lastCreateDepositIntentError ??
              'Could not initiate payment. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return null;
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
        return null;
      }

      Get.snackbar(
        'Payment Successful',
        'We are updating your wallet balance.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      final confirmed = await _refreshUntilDepositPosts(
        previousBalance: previousBalance,
        amount: amount,
      );

      return AddFundsResult(
        amount: amount,
        previousBalance: previousBalance,
        displayBalance: confirmed
            ? walletBalance.value
            : previousBalance + amount,
        confirmed: confirmed,
      );
    } catch (e) {
      debugPrint('Error adding funds: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return null;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  Future<bool> _refreshUntilDepositPosts({
    required double previousBalance,
    required double amount,
  }) async {
    final targetBalance = previousBalance + amount;
    for (var attempt = 0; attempt < 5; attempt++) {
      await Future.delayed(Duration(seconds: attempt == 0 ? 2 : 1));
      await fetchBalance();
      await fetchTransactions();
      if (walletBalance.value >= targetBalance - 0.01) {
        return true;
      }
    }

    Get.snackbar(
      'Confirmation Pending',
      'Stripe accepted the payment. Your balance may update shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      colorText: Colors.orange,
    );
    return false;
  }
}
