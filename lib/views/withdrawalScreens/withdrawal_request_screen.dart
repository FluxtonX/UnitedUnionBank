import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/wallet_controller.dart';
import '../../customWidgets/custom_text_field.dart';
import '../../services/wallet_action_service.dart';
import '../../theme/theme.dart';

class WithdrawalRequestScreen extends StatefulWidget {
  const WithdrawalRequestScreen({super.key});

  @override
  State<WithdrawalRequestScreen> createState() =>
      _WithdrawalRequestScreenState();
}

class _WithdrawalRequestScreenState extends State<WithdrawalRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();
  final _routingController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    _routingController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (WalletController.instance.walletBalance.value < _amount) {
      _showError('Insufficient wallet balance.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await WalletActionService.createWithdrawalRequest(
        amountInCents: (_amount * 100).round(),
        accountHolderName: _nameController.text.trim(),
        bankName: _bankController.text.trim(),
        accountNumber: _accountController.text.trim(),
        routingNumber: _routingController.text.trim(),
      );
      await WalletController.instance.fetchBalance();
      await WalletController.instance.fetchTransactions();

      if (!mounted) return;
      Get.snackbar(
        'Withdrawal Requested',
        'Request ${result.requestId} is pending review.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
        colorText: AppTheme.primaryLight,
      );
      Get.back();
    } catch (_) {
      _showError('Withdrawal request could not be created.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Withdrawal Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.error.withValues(alpha: 0.1),
      colorText: AppTheme.error,
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _amountValidator(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount < 1) return 'Enter at least \$1.00';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B558C),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.scaffoldBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _balanceCard(),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Amount',
                      hintText: '100.00',
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      validator: _amountValidator,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: 'Account Holder Name',
                      hintText: 'Jane Doe',
                      controller: _nameController,
                      validator: _required,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: 'Bank Name',
                      hintText: 'Example Bank',
                      controller: _bankController,
                      validator: _required,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: 'Account Number',
                      hintText: 'Only last 4 are sent to backend for now',
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: 'Routing Number',
                      hintText: 'Only last 4 are sent to backend for now',
                      controller: _routingController,
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'This creates a reviewed withdrawal request and places a wallet hold. External payout execution requires payout provider setup.',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 20, 22),
          child: Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.white,
                ),
              ),
              Text(
                'Withdraw',
                style: GoogleFonts.outfit(
                  color: AppTheme.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceCard() {
    return GetX<WalletController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Available',
                style: GoogleFonts.outfit(color: AppTheme.textSecondary),
              ),
              const Spacer(),
              Text(
                '\$${controller.walletBalance.value.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return SizedBox(
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isSubmitting
              ? const CircularProgressIndicator(color: AppTheme.white)
              : Text(
                  'Request Withdrawal',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
