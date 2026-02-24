import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';
import '../verifyEmailScreen/verify_email_screen.dart';

class CauseOption {
  final String title;
  final String subtitle;
  final IconData icon;

  CauseOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class CausesScreen extends StatefulWidget {
  const CausesScreen({super.key});

  @override
  State<CausesScreen> createState() => _CausesScreenState();
}

class _CausesScreenState extends State<CausesScreen> {
  final List<CauseOption> _options = [
    CauseOption(title: 'Climate Action', subtitle: 'Save our planet', icon: Icons.air),
    CauseOption(title: 'Food Security', subtitle: 'Nutritious meals', icon: Icons.restaurant_menu),
    CauseOption(title: 'Poverty', subtitle: 'End world hunger', icon: Icons.favorite_border),
    CauseOption(title: 'Education', subtitle: 'Future of learning', icon: Icons.menu_book),
    CauseOption(title: 'Clean Water', subtitle: 'Pure water access', icon: Icons.water_drop_outlined),
    CauseOption(title: 'Peace', subtitle: 'Global harmony', icon: Icons.handshake_outlined),
    CauseOption(title: 'Sustainable Energy', subtitle: 'Green power', icon: Icons.eco_outlined),
    CauseOption(title: 'Healthcare', subtitle: 'Medical for all', icon: Icons.medical_services_outlined),
  ];

  final Set<int> _selectedIndices = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _handleContinue() {
    Get.to(() => const VerifyEmailScreen());
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
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your Contributions',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          final option = _options[index];
                          final isSelected = _selectedIndices.contains(index);

                          return GestureDetector(
                            onTap: () => _toggleSelection(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                                    : AppTheme.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.divider,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: [
                                  if (!isSelected)
                                    BoxShadow(
                                      color: AppTheme.divider.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    option.icon,
                                    size: 32,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    option.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    option.subtitle,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _selectedIndices.length < 2
                          ? Text(
                              'Select at least 2 to continue',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : _buildContinueButton(),
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
        onPressed: _handleContinue,
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.white),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 40),
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppTheme.white,
                      size: 20,
                    ),
                  ),
                  Text(
                    'United Union Bank',
                    style: GoogleFonts.outfit(
                      color: AppTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleContinue,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'What Causes Do You\nCare About?',
                style: GoogleFonts.outfit(
                  color: AppTheme.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Select all that apply. We'll personalize\nyour experience.",
                style: GoogleFonts.outfit(
                  color: AppTheme.white.withValues(alpha: 0.8),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
