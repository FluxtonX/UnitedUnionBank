import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';
import '../../utils/image_picker_helper.dart';
import 'kyc_selfie_screen.dart';

class KycIdentityScreen extends StatefulWidget {
  const KycIdentityScreen({super.key});

  @override
  State<KycIdentityScreen> createState() => _KycIdentityScreenState();
}

class _KycIdentityScreenState extends State<KycIdentityScreen> {
  int _selectedDocType = 0;
  final List<String> _docTypes = ['CNIC', 'Passport', 'License'];

  File? _frontImage;
  File? _backImage;

  bool _showFrontError = false;
  bool _showBackError = false;

  Future<void> _pickImage({required bool isFront}) async {
    final file = await ImagePickerHelper.pickWithSourceSheet(context);
    if (file != null) {
      setState(() {
        if (isFront) {
          _frontImage = file;
          _showFrontError = false;
        } else {
          _backImage = file;
          _showBackError = false;
        }
      });
    }
  }

  void _validateAndContinue() {
    setState(() {
      _showFrontError = _frontImage == null;
      _showBackError = _backImage == null;
    });

    if (_frontImage != null && _backImage != null) {
      Get.to(() => const KycSelfieScreen());
    } else {
      Get.snackbar(
        'Missing Documents',
        'Please upload both front and back side of your document',
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
                      _buildProgressSection('Step 1 of 3', '33% Complete', 0.33),
                      const SizedBox(height: 4),
                      Text(
                        'Identity Verification',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Document type selector
                      _buildDocTypeSelector(),
                      const SizedBox(height: 28),

                      // Title
                      Text(
                        'Upload Government ID',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please select your document type and upload high-quality photos of both sides.',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Front Side
                      _buildUploadSection(
                        label: 'Front Side',
                        image: _frontImage,
                        hasError: _showFrontError,
                        onTap: () => _pickImage(isFront: true),
                        onRemove: () => setState(() => _frontImage = null),
                      ),
                      const SizedBox(height: 20),

                      // Back Side
                      _buildUploadSection(
                        label: 'Back Side',
                        image: _backImage,
                        hasError: _showBackError,
                        onTap: () => _pickImage(isFront: false),
                        onRemove: () => setState(() => _backImage = null),
                      ),
                      const SizedBox(height: 28),

                      _buildUploadTips(),
                      const SizedBox(height: 28),

                      _buildContinueButton(),
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

  Widget _buildProgressSection(String step, String percent, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(step,
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            Text(percent,
                style: GoogleFonts.outfit(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppTheme.divider,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildDocTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_docTypes.length, (index) {
          final isSelected = _selectedDocType == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDocType = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      isSelected ? Border.all(color: AppTheme.divider) : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _docTypes[index],
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUploadSection({
    required String label,
    required File? image,
    required bool hasError,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            if (image != null) ...[
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.close, size: 14, color: AppTheme.error),
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
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: image != null ? 180 : 140,
            decoration: BoxDecoration(
              color: image != null
                  ? Colors.transparent
                  : AppTheme.primaryLight.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasError
                    ? AppTheme.error
                    : (image != null
                        ? AppTheme.success.withValues(alpha: 0.5)
                        : AppTheme.primaryLight.withValues(alpha: 0.3)),
                width: hasError ? 2 : 1.5,
              ),
            ),
            child: image != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Success badge
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
                              color: AppTheme.white, size: 14),
                        ),
                      ),
                      // Tap hint
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
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
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: hasError ? AppTheme.error : AppTheme.primary,
                        size: 32,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Take photo or upload',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: hasError
                              ? AppTheme.error
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (hasError) ...[
                        const SizedBox(height: 4),
                        Text(
                          'This image is required',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UPLOAD TIPS',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ensure all details are readable, no glare or shadows, and the ID is not expired.',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool isReady = _frontImage != null && _backImage != null;
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
