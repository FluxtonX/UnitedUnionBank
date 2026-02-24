import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';
import 'enter_amount_screen.dart';

class EnterReceiverDetailsScreen extends StatefulWidget {
  final String bankName;
  final Color bankIconColor;
  final String bankInitials;

  const EnterReceiverDetailsScreen({
    super.key,
    required this.bankName,
    required this.bankIconColor,
    required this.bankInitials,
  });

  @override
  State<EnterReceiverDetailsScreen> createState() => _EnterReceiverDetailsScreenState();
}

class _EnterReceiverDetailsScreenState extends State<EnterReceiverDetailsScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  void _handleNext() {
    Get.to(() => EnterAmountScreen(
      bankName: widget.bankName,
      bankIconColor: widget.bankIconColor,
      bankInitials: widget.bankInitials,
      accountNumber: _accountController.text.isNotEmpty ? _accountController.text : '03369876532',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Select Receiver\'s Details',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter Account Number or IBAN',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _accountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Account Number or IBAN',
                          hintStyle: GoogleFonts.outfit(color: AppTheme.textHint),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Others',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Purpose of Payment', style: GoogleFonts.outfit(color: AppTheme.textHint, fontSize: 14)),
                            const Icon(Icons.keyboard_arrow_down, color: AppTheme.textHint),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter Mobile Number (Optional)',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter Receiver\'s Number or Search Contacts',
                          hintStyle: GoogleFonts.outfit(color: AppTheme.textHint, fontSize: 13),
                          suffixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _handleNext,
                        child: const Text('Next'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 50),
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppTheme.white, size: 20),
                    ),
                  ),
                  Text(
                    'Bank Transfer',
                    style: GoogleFonts.outfit(color: AppTheme.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sending to Bank Account',
              style: GoogleFonts.outfit(
                color: AppTheme.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      widget.bankInitials,
                      style: GoogleFonts.outfit(
                        color: widget.bankIconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.bankName,
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.account_balance, color: AppTheme.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
