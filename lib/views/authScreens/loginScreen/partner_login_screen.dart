import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:united_union_bank/views/institutionalPortalScreens/portal_main/portal_main_tab_screen.dart';

import '../../../customWidgets/custom_text_field.dart';
import '../../../theme/theme.dart';

class InstitutionalLoginScreen extends StatefulWidget {
  const InstitutionalLoginScreen({super.key});

  @override
  State<InstitutionalLoginScreen> createState() =>
      _InstitutionalLoginScreenState();
}

class _InstitutionalLoginScreenState extends State<InstitutionalLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _isLoading = false);
      Get.offAll(() => const PortalMainTabScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'INSTITUTIONAL EMAIL',
                        hintText: 'e.g. name@un-impact.org',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.alternate_email,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'SECURITY PASSWORD',
                        hintText: 'enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 32),
                      _buildLoginButton(),
                      const SizedBox(height: 28),
                      _buildDividerRow('or login with'),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBiometricButton(
                              Icons.face_retouching_natural,
                              'Face ID',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBiometricButton(
                              Icons.fingerprint,
                              'Touch ID',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trouble signing in?',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textHint,
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppTheme.textHint,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'Contact Admin',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textHint,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildProtectedBadge(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3898D4), Color(0xFF0D2554)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  Column(
                    children: [
                      Text(
                        'Secure Access Portal',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'IMPACT MANAGEMENT SYSTEM',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.info_outline, color: Colors.white, size: 28),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Partner login',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Authorized Personnel for NGOs, UN & Global\nInvestors',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF04489A), // Dark blue button
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF04489A).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Secure Login',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDividerRow(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: GoogleFonts.outfit(color: AppTheme.textHint, fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
      ],
    );
  }

  Widget _buildBiometricButton(IconData icon, String label) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF0D2554),
                size: 22,
              ), // Dark blue icon
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtectedBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.shield_outlined, size: 14, color: AppTheme.textHint),
        const SizedBox(width: 6),
        Text(
          'AES-256 ENCRYPTED SESSION',
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: AppTheme.textHint,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
