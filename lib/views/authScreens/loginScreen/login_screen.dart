import 'package:flutter/material.dart' hide debugPrint;
import 'package:get/get.dart';

import 'package:united_union_bank/views/authScreens/authController/auth_controller.dart';
import 'package:united_union_bank/views/authScreens/loginScreen/partner_login_screen.dart';
import 'package:united_union_bank/views/authScreens/loginScreen/phone_login_screen.dart';
import '../../../customWidgets/custom_text_field.dart';
import '../../../theme/theme.dart';
import '../signUpScreen/sign_up_screen.dart';
import '../forgotPasswordScreen/forgot_password_screen.dart';
import '../../../controllers/biometric_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validators ──────────────────────────────────────────────────────
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone number is required';
    }
    // Accepts email or phone (10+ digits)
    final isEmail = RegExp(
      r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$',
    ).hasMatch(value.trim());
    final isPhone = RegExp(r'^\+?\d{10,15}$').hasMatch(value.trim());
    if (!isEmail && !isPhone) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  final AuthController _authController = AuthController.instance;

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authController.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Success case is handled by Get.offAll(...) inside authController.login
    } catch (e) {
      debugPrint("Login Failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'EMAIL ',
                          hintText: 'Enter your email ',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: 'PASSWORD',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          labelTrailing: GestureDetector(
                            onTap: () =>
                                Get.to(() => const ForgotPasswordScreen()),
                            child: Text(
                              'Forgot?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSignInButton(),
                        const SizedBox(height: 28),
                        _buildDividerRow('or login with'),
                        const SizedBox(height: 28),
                        _buildGoogleSignInButton(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildBiometricButton(
                                Icons.face_retouching_natural,
                                'Face ID',
                                onTap: _handleBiometricLogin,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildBiometricButton(
                                Icons.fingerprint,
                                'Touch ID',
                                onTap: _handleBiometricLogin,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPhoneLoginButton(),
                        const SizedBox(height: 36),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const SignUpScreen()),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () =>
                              Get.to(() => const InstitutionalLoginScreen()),
                          child: Text(
                            'Partner Login',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProtectedBadge(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Sign in to access your secure digital\nvault and manage your global finances.',
                  style: TextStyle(
                    color: AppTheme.white.withValues(alpha: 0.7),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppTheme.buttonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignIn,
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
                  color: AppTheme.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppTheme.white,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDividerRow(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(color: AppTheme.textHint, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.divider)),
      ],
    );
  }

  void _handleBiometricLogin() async {
    final biometricController = BiometricController.instance;

    // 1. Check if enabled
    if (!biometricController.isBiometricEnabled.value) {
      Get.defaultDialog(
        title: "Biometrics Disabled",
        middleText: "Please log in manually with your password first, then enable Biometric Login in your Profile settings.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
      return;
    }

    // 2. Perform Hardware Authentication
    bool authenticated = await biometricController.authenticate();
    if (!authenticated) return;

    // 3. Retrieve Credentials
    final credentials = biometricController.getSavedCredentials();
    if (credentials == null) {
      Get.defaultDialog(
        title: "Setup Required",
        middleText: "For security, we need to link your biometric data to your account.\n\nPlease log in manually using your email and password one time to complete the setup.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
      return;
    }

    // 4. Execute Login
    setState(() => _isLoading = true);
    try {
      await _authController.login(
        credentials['email']!,
        credentials['password']!,
      );
    } catch (e) {
      debugPrint("Biometric Login Failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await _authController.signInWithGoogle();
    } catch (e) {
      debugPrint('Google login failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSocialSignInButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppTheme.primary, size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return _buildSocialSignInButton(
      label: 'Continue with Google',
      icon: Icons.g_mobiledata,
      onTap: _handleGoogleSignIn,
    );
  }

  Widget _buildBiometricButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
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

  Widget _buildPhoneLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => const PhoneLoginScreen()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_outlined, color: AppTheme.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Phone Number',
                style: TextStyle(
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
        const Icon(Icons.lock_outline, size: 14, color: AppTheme.textHint),
        const SizedBox(width: 6),
        Text(
          'YOUR DATA IS PROTECTED',
          style: TextStyle(
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
