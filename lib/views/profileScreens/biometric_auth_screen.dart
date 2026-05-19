import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../controllers/biometric_controller.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final controller = Get.find<BiometricController>();

  @override
  void initState() {
    super.initState();
    // Trigger authentication automatically when screen opens
    _startAuth();
  }

  Future<void> _startAuth() async {
    // Small delay to allow transition animation to finish
    await Future.delayed(const Duration(milliseconds: 500));
    bool success = await controller.authenticate();
    if (success) {
      // Persist the enablement status
      controller.isBiometricEnabled.value = true;
      controller.storage.write('biometric_enabled', true);
      
      // Navigate back to the Privacy & Security screen, skipping the enable screen
      Get.until((route) => route.isFirst || Get.currentRoute == '/PrivacySecurityScreen' || route.settings.name == null);
      // If we can't find the specific route, popping twice is a safe fallback for simple navigation
      if (Get.currentRoute != '/PrivacySecurityScreen') {
         Get.back(); 
      }
      
      Get.snackbar(
        "Secure Access Enabled",
        "Biometric login is now active for your account",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B58D3), // From the reference image
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7E69E5),
              Color(0xFF5A48B8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Header
              Text(
                'Touch ID sensor to verify yourself',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Set up your account in minutes and start managing your wealth globally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              // White Auth Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      // Large Animated Fingerprint Graphic
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF3491E3).withValues(alpha: 0.1),
                                width: 2,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.fingerprint,
                            size: 100,
                            color: Color(0xFF3491E3), // Simplified for now, use image/assets if available
                          ),
                          // Simulate the "completely scanning" look with a subtle pulse/overlay if needed
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Fingerprint for United Union Bank',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Place your finger in fingerprint sensor until the icon completely.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF667085),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Cancel Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: AppTheme.buttonGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
