import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/wallet_controller.dart';
import '../../services/wallet_action_service.dart';
import '../../theme/theme.dart';
import 'donation_receipt_screen.dart';

class DonationProject {
  const DonationProject({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _amountController = TextEditingController();
  int _selectedProject = 0;
  bool _isSubmitting = false;

  static const _projects = [
    DonationProject(
      id: 'meals_global',
      title: 'Global Meal Support',
      subtitle: 'Fund nutritious meals for families.',
      icon: Icons.restaurant_outlined,
    ),
    DonationProject(
      id: 'trees_reforestation',
      title: 'Community Reforestation',
      subtitle: 'Plant trees through local projects.',
      icon: Icons.park_outlined,
    ),
    DonationProject(
      id: 'healthcare_access',
      title: 'Healthcare Access Fund',
      subtitle: 'Support visits and essential care.',
      icon: Icons.medical_services_outlined,
    ),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  Future<void> _submit() async {
    if (_amount < 1) {
      _showError('Enter at least \$1.00.');
      return;
    }

    final wallet = WalletController.instance;
    if (wallet.walletBalance.value < _amount) {
      _showError('Insufficient wallet balance.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final project = _projects[_selectedProject];
      final result = await WalletActionService.createDonation(
        projectId: project.id,
        amountInCents: (_amount * 100).round(),
      );
      await wallet.fetchBalance();
      await wallet.fetchTransactions();

      if (!mounted) return;
      Get.off(
        () => DonationReceiptScreen(
          projectTitle: project.title,
          amount: _amount,
          receiptNumber: result.receiptNumber,
        ),
      );
    } catch (_) {
      _showError('Donation could not be completed.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Donation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.error.withValues(alpha: 0.1),
      colorText: AppTheme.error,
    );
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
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _balanceCard(),
                  const SizedBox(height: 18),
                  Text(
                    'Choose Project',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_projects.length, _projectTile),
                  const SizedBox(height: 18),
                  _amountField(),
                  const SizedBox(height: 24),
                  _submitButton(),
                ],
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
                'Donate',
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

  Widget _projectTile(int index) {
    final project = _projects[index];
    final selected = index == _selectedProject;
    return GestureDetector(
      onTap: () => setState(() => _selectedProject = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppTheme.primaryLight : AppTheme.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(project.icon, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    project.subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppTheme.primaryLight),
          ],
        ),
      ),
    );
  }

  Widget _amountField() {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        labelText: 'Donation Amount',
        prefixText: '\$ ',
      ),
      onChanged: (_) => setState(() {}),
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
                  'Donate from Wallet',
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
