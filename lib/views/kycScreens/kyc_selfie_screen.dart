import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';
import 'kyc_address_screen.dart';
import '../kycController/kyc_selfie_controller.dart';

class KycSelfieScreen extends StatelessWidget {
  const KycSelfieScreen({
    super.key,
    required this.documentType,
    required this.documentFront,
    required this.documentBack,
  });

  final String documentType;
  final File documentFront;
  final File documentBack;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KycSelfieController());

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
                      // Progress (Updated to match design "Step 1 of 3")
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

                      // Selfie frame / Camera Preview
                      _buildCameraView(controller),

                      const SizedBox(height: 20),

                      // Status badge
                      _buildStatusBadge(controller),

                      const SizedBox(height: 36),

                      // Camera controls
                      _buildCameraControls(controller),

                      const SizedBox(height: 36),

                      // Continue button
                      _buildContinueButton(controller),

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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppTheme.white,
                  size: 20,
                ),
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
            Text(
              'Step 1 of 3',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
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
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(
            value: 0.33,
            minHeight: 8,
            backgroundColor: AppTheme.divider,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0000AA)),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraView(KycSelfieController controller) {
    return Center(
      child: Obx(() {
        final capturedImage = controller.capturedImage.value;

        return Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Real Camera Preview or Captured Image
              ClipOval(
                child: capturedImage != null
                    ? Image.file(
                        capturedImage,
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      )
                    : _buildCameraContent(controller),
              ),

              // Dashed circle guide
              if (capturedImage == null && !controller.hasError.value)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DashedCirclePainter(
                      color: controller.isFaceAligned.value
                          ? AppTheme.white
                          : AppTheme.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),

              // Status indicator placeholder
              if (capturedImage == null && !controller.hasError.value)
                Positioned(
                  top: 40,
                  right: 40,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppTheme.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCameraContent(KycSelfieController controller) {
    if (controller.hasError.value) {
      return Container(
        color: const Color(0xFFFEE2E2),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.error,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppTheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.retryInitialization(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.outfit(
                      color: AppTheme.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (controller.isCameraInitialized.value) {
      return AspectRatio(
        aspectRatio: 1,
        child: CameraPreview(controller.cameraController!),
      );
    }

    return Container(
      color: Colors.black87,
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.white),
      ),
    );
  }

  Widget _buildStatusBadge(KycSelfieController controller) {
    return Center(
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: controller.isFaceAligned.value
                  ? AppTheme.divider
                  : AppTheme.divider,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isFaceAligned.value)
                const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF000088),
                  size: 22,
                ),
              const SizedBox(width: 8),
              Text(
                controller.statusMessage.value,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraControls(KycSelfieController controller) {
    return Obx(() {
      final hasImage = controller.capturedImage.value != null;
      final isReady =
          controller.isCameraInitialized.value && !controller.hasError.value;

      return Opacity(
        opacity: isReady || hasImage ? 1.0 : 0.5,
        child: IgnorePointer(
          ignoring: !isReady && !hasImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery
              GestureDetector(
                onTap: controller.pickFromGallery,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppTheme.scaffoldBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GALLERY',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Shutter Button
              GestureDetector(
                onTap: hasImage
                    ? controller.resetCapture
                    : controller.takePicture,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000088),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000088).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    hasImage ? Icons.refresh : Icons.camera_alt,
                    color: AppTheme.white,
                    size: 32,
                  ),
                ),
              ),

              // Flip Camera
              GestureDetector(
                onTap: controller.switchCamera,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppTheme.scaffoldBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flip_camera_ios_outlined,
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'FLIP',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContinueButton(KycSelfieController controller) {
    return Obx(() {
      final bool isReady = controller.capturedImage.value != null;

      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: isReady ? const Color(0xFF0044BB) : AppTheme.divider,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isReady
              ? [
                  BoxShadow(
                    color: const Color(0xFF0044BB).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isReady
              ? () => Get.to(
                    () => KycAddressScreen(
                      documentType: documentType,
                      documentFront: documentFront,
                      documentBack: documentBack,
                      selfie: controller.capturedImage.value!,
                    ),
                  )
              : null,
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
              Text(
                'Continue',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppTheme.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
