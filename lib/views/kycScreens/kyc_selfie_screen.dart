import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/theme.dart';
import '../../utils/image_picker_helper.dart';
import 'kyc_address_screen.dart';

class KycSelfieScreen extends StatefulWidget {
  const KycSelfieScreen({super.key});

  @override
  State<KycSelfieScreen> createState() => _KycSelfieScreenState();
}

class _KycSelfieScreenState extends State<KycSelfieScreen> {
  File? _selfieImage;
  bool _showError = false;

  Future<void> _takeSelfie() async {
    final file = await ImagePickerHelper.pickFromCamera(
      preferredCamera: CameraDevice.front,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (file != null) {
      setState(() {
        _selfieImage = file;
        _showError = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final file = await ImagePickerHelper.pickFromGallery(
      imageQuality: 85,
      maxWidth: 800,
    );
    if (file != null) {
      setState(() {
        _selfieImage = file;
        _showError = false;
      });
    }
  }

  void _validateAndContinue() {
    if (_selfieImage != null) {
      Get.to(() => const KycAddressScreen());
    } else {
      setState(() => _showError = true);
      Get.snackbar(
        'Selfie Required',
        'Please take a selfie to verify your identity',
        backgroundColor: AppTheme.error.withValues(alpha: 0.1),
        colorText: AppTheme.error,
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.TOP,
      );
    }
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress
                      _buildProgressSection(),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Identity Verification',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryLight,
                            ),
                          ),
                          Text(
                            'Selfie Verification',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Title
                      Text(
                        'Take a Selfie',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Position your face within the frame and ensure you\'re in a well-lit environment.',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Selfie frame / preview
                      _buildSelfieFrame(),

                      const SizedBox(height: 20),

                      // Status badge
                      _buildStatusBadge(),

                      const SizedBox(height: 28),

                      // Camera controls
                      _buildCameraControls(),

                      const SizedBox(height: 28),

                      // Continue button
                      _buildContinueButton(),

                      const SizedBox(height: 16),

                      // Security note
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
                    'Verification',
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
            Text('Step 2 of 3',
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            Text('66% Complete',
                style: GoogleFonts.outfit(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(
            value: 0.66,
            minHeight: 8,
            backgroundColor: AppTheme.divider,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfieFrame() {
    return Center(
      child: GestureDetector(
        onTap: _takeSelfie,
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _showError
                  ? AppTheme.error
                  : (_selfieImage != null
                      ? AppTheme.success
                      : AppTheme.primary),
              width: 4,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selfieImage == null ? AppTheme.scaffoldBg : null,
            ),
            child: _selfieImage != null
                ? Stack(
                    children: [
                      ClipOval(
                        child: Image.file(
                          _selfieImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Re-take overlay
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Tap to retake',
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
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 120,
                        color: _showError
                            ? AppTheme.error.withValues(alpha: 0.4)
                            : AppTheme.textHint.withValues(alpha: 0.5),
                      ),
                      // Dashed circle overlay
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DashedCirclePainter(
                            color: _showError
                                ? AppTheme.error.withValues(alpha: 0.3)
                                : AppTheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      // Hint badge
                      Positioned(
                        top: 20,
                        right: 30,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _showError
                                ? AppTheme.error
                                : AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _showError
                                ? Icons.close
                                : Icons.auto_awesome,
                            color: AppTheme.white,
                            size: 14,
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

  Widget _buildStatusBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _showError
                ? AppTheme.error.withValues(alpha: 0.3)
                : (_selfieImage != null
                    ? AppTheme.success.withValues(alpha: 0.3)
                    : AppTheme.divider),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _selfieImage != null
                  ? Icons.check_circle
                  : (_showError
                      ? Icons.error_outline
                      : Icons.info_outline),
              color: _selfieImage != null
                  ? AppTheme.success
                  : (_showError
                      ? AppTheme.error
                      : AppTheme.textHint),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _selfieImage != null
                  ? 'Selfie captured successfully'
                  : (_showError
                      ? 'Please take your selfie'
                      : 'Tap the camera button below'),
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _selfieImage != null
                    ? AppTheme.success
                    : (_showError
                        ? AppTheme.error
                        : AppTheme.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gallery
        GestureDetector(
          onTap: _pickFromGallery,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.scaffoldBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.photo_library_outlined,
                    color: AppTheme.textSecondary, size: 24),
              ),
              const SizedBox(height: 6),
              Text('GALLERY',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppTheme.textSecondary,
                  )),
            ],
          ),
        ),
        const SizedBox(width: 28),

        // Camera (main button)
        GestureDetector(
          onTap: _takeSelfie,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppTheme.buttonGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, color: AppTheme.white, size: 28),
          ),
        ),
        const SizedBox(width: 28),

        // Remove / Reset
        GestureDetector(
          onTap: _selfieImage != null
              ? () => setState(() {
                    _selfieImage = null;
                    _showError = false;
                  })
              : null,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selfieImage != null
                      ? AppTheme.error.withValues(alpha: 0.08)
                      : AppTheme.scaffoldBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _selfieImage != null
                      ? Icons.delete_outline
                      : Icons.flip_camera_ios_outlined,
                  color: _selfieImage != null
                      ? AppTheme.error
                      : AppTheme.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _selfieImage != null ? 'REMOVE' : 'FLIP',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: _selfieImage != null
                      ? AppTheme.error
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    final bool isReady = _selfieImage != null;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: isReady ? AppTheme.buttonGradient : null,
        color: isReady ? null : AppTheme.textHint.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isReady
            ? [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: _validateAndContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Continue',
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward, size: 20, color: AppTheme.white),
          ],
        ),
      ),
    );
  }
}

/// Draws a dashed circle as a face alignment guide
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final radius = size.width / 2 - 10;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * 3.14159 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace)) / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashWidth / radius,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
