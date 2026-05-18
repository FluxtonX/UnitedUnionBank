import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/theme.dart';
import '../authScreens/authController/auth_controller.dart';
import 'kyc_overview_screen.dart';

class KycStatusScreen extends StatelessWidget {
  const KycStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthController.instance.userModel.value;
    final status = user?.kycStatus ?? 'not_started';
    final isRejected = status == 'rejected';

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  'Verification',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: (isRejected ? AppTheme.error : AppTheme.primaryLight)
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isRejected
                              ? Icons.error_outline
                              : Icons.verified_user_outlined,
                          color: isRejected ? AppTheme.error : AppTheme.primaryLight,
                          size: 46,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _titleFor(status),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _messageFor(status),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (isRejected || status == 'not_started')
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppTheme.buttonGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton(
                              onPressed: () =>
                                  Get.offAll(() => const KycOverviewScreen()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                isRejected ? 'Try Again' : 'Start Verification',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (status == 'not_started') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: TextButton(
                            onPressed: AuthController.instance.skipKycForNow,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: AppTheme.divider),
                              ),
                            ),
                            child: Text(
                              'Skip for Now',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                TextButton(
                  onPressed: AuthController.instance.logout,
                  child: Text(
                    'Log out',
                    style: GoogleFonts.outfit(
                      color: AppTheme.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _titleFor(String status) {
    switch (status) {
      case 'submitted':
        return 'KYC Submitted';
      case 'under_review':
        return 'KYC Under Review';
      case 'rejected':
        return 'Verification Needs Attention';
      default:
        return 'Verification Required';
    }
  }

  String _messageFor(String status) {
    switch (status) {
      case 'submitted':
        return 'Your documents were submitted. Wallet access unlocks after backend review approval.';
      case 'under_review':
        return 'Our compliance review is in progress. You will be notified when a decision is available.';
      case 'rejected':
        return 'Your verification was rejected. Please review your details and submit again.';
      default:
        return 'Complete identity verification before using wallet features.';
    }
  }
}
