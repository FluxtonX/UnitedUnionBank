import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_images.dart';
import '../../theme/theme.dart';
import '../authScreens/loginScreen/login_screen.dart';
import '../profileScreens/personal_information_screen.dart';
import '../profileScreens/email_settings_screen.dart';
import '../profileScreens/phone_number_screen.dart';
import '../profileScreens/notifications_screen.dart';
import '../profileScreens/privacy_security_screen.dart';
import '../profileScreens/app_settings_screen.dart';
import '../profileScreens/help_center_screen.dart';
import '../profileScreens/terms_privacy_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003876),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF003876), Color(0xFF4DAAF8)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.scaffoldBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: _buildStatCardsRow(),
                        ),

                        // MENU SECTIONS
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: Column(
                            children: [
                              _buildSectionHeader('ACCOUNT'),
                              _buildSectionCard([
                                _buildMenuItem(AppIcons.personIcon, 'Personal Information', onTap: () => Get.to(() => const PersonalInformationScreen())),
                                _buildMenuItem(AppIcons.emailIcon, 'Email Settings', onTap: () => Get.to(() => const EmailSettingsScreen())),
                                _buildMenuItem(AppIcons.phoneIcon, 'Phone Number', badge: 'Verified', onTap: () => Get.to(() => const PhoneNumberScreen())),
                              ]),
                              const SizedBox(height: 24),

                              _buildSectionHeader('PREFERENCES'),
                              _buildSectionCard([
                                _buildMenuItem(AppIcons.notificationIcon, 'Notifications', badge: '3 new', onTap: () => Get.to(() => const NotificationsScreen())),
                                _buildMenuItem(AppIcons.privacyIcon, 'Privacy & Security', onTap: () => Get.to(() => const PrivacySecurityScreen())),
                                _buildMenuItem(AppIcons.settingsIcon, 'App Settings', onTap: () => Get.to(() => const AppSettingsScreen())),
                              ]),
                              const SizedBox(height: 24),

                              _buildSectionHeader('SUPPORT'),
                              _buildSectionCard([
                                _buildMenuItem(AppIcons.helpIcon, 'Help Center', onTap: () => Get.to(() => const HelpCenterScreen())),
                                _buildMenuItem(AppIcons.termsIcon, 'Terms & Privacy', onTap: () => Get.to(() => const TermsPrivacyScreen())),
                              ]),
                              const SizedBox(height: 32),
                              _buildLogoutButton(context),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for the Stat Cards Row
  Widget _buildStatCardsRow() {
    return Row(
      children: [
        _buildStatCard('47', 'Trees Planted'),
        const SizedBox(width: 12),
        _buildStatCard('230', 'Meals Provided'),
        const SizedBox(width: 12),
        _buildStatCard('\$350', 'Total Donated'),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90, height: 90,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Text('JD', style: GoogleFonts.outfit(color: const Color(0xFF003876), fontSize: 26, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Text('John Doe', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text('john.doe@email.com', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopBadge('⭐ Impact Score: 850', const Color(0xFF53A1D8)),
              const SizedBox(width: 10),
              _buildTopBadge('🌟 Changemaker', const Color(0xFF53A1D8)),
            ],
          ),
          const SizedBox(height: 80), // Creates space for the sheet to overlap
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.03),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0,right: 10.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIcons.logoutIcon, height: 24, width: 24),
            const SizedBox(width: 10),
            Text('Log Out', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF3491E3))),
          ],
        ),
      ),
    );
  }
  Widget _buildTopBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: AppTheme.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF236EB6),
              Color(0xFF1B558C),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: GoogleFonts.outfit(
                color: AppTheme.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppTheme.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Log Out',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: GoogleFonts.outfit(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAll(() => const LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.outfit(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String icon, String title, {String? badge, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
         leading: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.iconFill,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),

        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badge == 'Verified'
                      ? const Color(0xFF0D78C1)
                      : const Color(0xFF0D78C1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

}
