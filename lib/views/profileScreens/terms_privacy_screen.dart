import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

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
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Terms of Service',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: February 24, 2026',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppTheme.textHint,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('1. General Conditions'),
                    _buildParagraph(
                        'By using United Union Bank services, you agree to these terms. '
                        'We reserve the right to refuse service to anyone for any reason at any time. '
                        'You understand that your functional data may be transferred unencrypted and involve transmissions over various networks.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('2. User Responsibilities'),
                    _buildParagraph(
                        'You are responsible for keeping your password secure. '
                        'United Union Bank cannot and will not be liable for any loss or damage from your failure to maintain the security of your account and password.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('3. Privacy Policy'),
                    _buildParagraph(
                        'Your privacy is critical to us. We will not share your personal financial information with third parties without your explicit consent. '
                        'Read our full Privacy Policy statement for more details.'),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.scaffoldBg,
                        foregroundColor: AppTheme.textPrimary,
                        elevation: 0,
                      ),
                      child: const Text('Acknowledge'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14,
        color: AppTheme.textSecondary,
        height: 1.5,
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
        child: Padding(
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
                'Terms & Privacy',
                style: GoogleFonts.outfit(color: AppTheme.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
