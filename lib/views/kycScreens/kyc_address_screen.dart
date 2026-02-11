import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';
import '../../customWidgets/custom_text_field.dart';
import '../../utils/image_picker_helper.dart';
import 'kyc_success_screen.dart';

class KycAddressScreen extends StatefulWidget {
  const KycAddressScreen({super.key});

  @override
  State<KycAddressScreen> createState() => _KycAddressScreenState();
}

class _KycAddressScreenState extends State<KycAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  File? _proofImage;
  bool _showProofError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _pickProofDocument() async {
    final file = await ImagePickerHelper.pickWithSourceSheet(context);
    if (file != null) {
      setState(() {
        _proofImage = file;
        _showProofError = false;
      });
    }
  }

  // ── Validators ──────────────────────────────────────────────────────
  String? _validateStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Street address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete street address';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    if (value.trim().length < 2) {
      return 'Enter a valid city';
    }
    return null;
  }

  String? _validatePostal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s\-]{3,10}$').hasMatch(value.trim())) {
      return 'Invalid postal code';
    }
    return null;
  }

  void _handleContinue() {
    final formValid = _formKey.currentState!.validate();
    setState(() {
      _showProofError = _proofImage == null;
    });

    if (!formValid || _proofImage == null) {
      if (_proofImage == null) {
        Get.snackbar(
          'Missing Document',
          'Please upload proof of address',
          backgroundColor: AppTheme.error.withValues(alpha: 0.1),
          colorText: AppTheme.error,
          margin: const EdgeInsets.all(20),
          snackPosition: SnackPosition.TOP,
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _isLoading = false);
      Get.to(() => const KycSuccessScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          _buildMiniHeader(),
          Expanded(
            child: Transform.translate(
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SECURITY CHECK',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textHint,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildProgressSection(),
                        const SizedBox(height: 28),

                        Text(
                          'Residential Address',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please enter your permanent home address as per your legal documents.',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        CustomTextField(
                          label: 'Street Address',
                          hintText: 'e.g. 123 Silver Oak Avenue',
                          controller: _streetController,
                          keyboardType: TextInputType.streetAddress,
                          validator: _validateStreet,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomTextField(
                                label: 'City',
                                hintText: 'San Francisco',
                                controller: _cityController,
                                validator: _validateCity,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                label: 'Postal Code',
                                hintText: '94105',
                                controller: _postalController,
                                keyboardType: TextInputType.number,
                                validator: _validatePostal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Proof of Address
                        Row(
                          children: [
                            Text(
                              'Proof of Address',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (_proofImage != null) ...[
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _proofImage = null),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.error.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.close,
                                          size: 14, color: AppTheme.error),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Remove',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload a utility bill or bank statement (max 5MB)',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Upload area with preview
                        GestureDetector(
                          onTap: _pickProofDocument,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: _proofImage != null ? 180 : 130,
                            decoration: BoxDecoration(
                              color: _proofImage != null
                                  ? Colors.transparent
                                  : AppTheme.primaryLight
                                      .withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _showProofError
                                    ? AppTheme.error
                                    : (_proofImage != null
                                        ? AppTheme.success
                                            .withValues(alpha: 0.5)
                                        : AppTheme.primaryLight
                                            .withValues(alpha: 0.3)),
                                width: _showProofError ? 2 : 1.5,
                              ),
                            ),
                            child: _proofImage != null
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        child: Image.file(
                                          _proofImage!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.success,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.check,
                                              color: AppTheme.white,
                                              size: 14),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withValues(alpha: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Tap to change',
                                              style: GoogleFonts.outfit(
                                                fontSize: 11,
                                                color: AppTheme.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined,
                                          color: _showProofError
                                              ? AppTheme.error
                                              : AppTheme.primary,
                                          size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Click to upload document',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          color: _showProofError
                                              ? AppTheme.error
                                              : AppTheme.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _showProofError
                                            ? 'This document is required'
                                            : 'PDF, JPG, PNG',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: _showProofError
                                              ? AppTheme.error
                                              : AppTheme.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Map placeholder
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppTheme.scaffoldBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(double.infinity, 140),
                                painter: _MapGridPainter(),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.location_on,
                                    color: AppTheme.white, size: 22),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),
                        _buildContinueButton(),
                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            'Your data is encrypted and securely processed',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 40),
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: AppTheme.white, size: 20),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Verify Address',
                    style: GoogleFonts.outfit(
                      color: AppTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Step 3: Address Verification',
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            Text('3 of 3',
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryLight)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(
            value: 1.0,
            minHeight: 8,
            backgroundColor: AppTheme.divider,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
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
        onPressed: _isLoading ? null : _handleContinue,
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
                  Text('Continue',
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white)),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward,
                      size: 20, color: AppTheme.white),
                ],
              ),
      ),
    );
  }
}

/// Draws a subtle grid on the map placeholder
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.divider
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
