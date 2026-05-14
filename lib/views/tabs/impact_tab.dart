import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/impact_models.dart';
import '../../services/impact_service.dart';
import '../../theme/theme.dart';
import '../../config/app_images.dart';
import '../donationScreens/donation_screen.dart';

class ImpactTab extends StatelessWidget {
  const ImpactTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B558C),
      body: Column(
        children: [
          _buildTopHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildGlobalCommunity(),
                        const SizedBox(height: 32),
                        _buildYourContributions(),
                        const SizedBox(height: 32),
                        _buildRecentActivity(),
                        const SizedBox(height: 24),
                        _buildBottomActions(),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: _buildShareFAB(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Impact',
                          style: GoogleFonts.outfit(
                            color: AppTheme.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Since joining • Feb 2025',
                          style: GoogleFonts.outfit(
                            color: AppTheme.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AppIcons.notificationIcon,
                        width: 26,
                        height: 26,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE54D4D),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildImpactPointsIndicator(),
            const SizedBox(height: 16),
            _buildChangemakerBadge(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactPointsIndicator() {
    double currentPoints = 850;
    double maxPoints = 1000;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: CircularProgressPainter(
              progress: currentPoints,
              maxProgress: maxPoints,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$currentPoints',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Impact Points',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildChangemakerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
          const SizedBox(width: 6),
          Text(
            'Changemaker',
            style: GoogleFonts.outfit(
              color: const Color(0xFF1B558C),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalCommunity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Community',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<ImpactProjectModel>>(
            stream: ImpactService.activeProjects(),
            builder: (context, snapshot) {
              final summary = ImpactSummary.fromProjects(snapshot.data ?? const []);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlobalStat(
                    AppIcons.activeUserIcon,
                    '${snapshot.data?.length ?? 0}',
                    'Projects',
                  ),
                  _buildGlobalStat(
                    AppIcons.donatedIcon,
                    '\$${summary.totalDonated.toStringAsFixed(0)}',
                    'Total Donated',
                  ),
                  _buildGlobalStat(
                    AppIcons.treeIcon,
                    '${summary.treesPlanted}',
                    'Trees Planted',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalStat(String iconPath, String value, String label) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B558C),
            //borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              color: Colors.white,
              width: 32,
              height: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildYourContributions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Contributions',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'View All →',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3491E3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<DonationRecordModel>>(
            stream: ImpactService.userDonations(),
            builder: (context, snapshot) {
              final summary =
                  ImpactSummary.fromDonations(snapshot.data ?? const []);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildContributionCard(
                    Icons.favorite_outline,
                    '\$${summary.totalDonated.toStringAsFixed(0)}',
                    'Donated',
                    '${snapshot.data?.length ?? 0} gifts',
                  ),
                  _buildContributionCard(
                    Icons.restaurant_outlined,
                    '${summary.mealsFunded}',
                    'Meals Funded',
                    'From donations',
                  ),
                  _buildContributionCard(
                    Icons.park_outlined,
                    '${summary.treesPlanted}',
                    'Trees Planted',
                    'From donations',
                  ),
                  _buildContributionCard(
                    Icons.medical_services_outlined,
                    '${summary.healthcareSupport}',
                    'Care Support',
                    'Visits funded',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContributionCard(IconData icon, String value, String label, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1B558C), size: 20),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B558C),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              sub,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: const Color(0xFF3491E3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<DonationRecordModel>>(
            stream: ImpactService.userDonations(),
            builder: (context, snapshot) {
              final donations = snapshot.data ?? const [];
              if (donations.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    'No donation activity yet.',
                    style: GoogleFonts.outfit(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              final visible = donations.take(5).toList();
              return Column(
                children: List.generate(visible.length, (index) {
                  final donation = visible[index];
                  return _buildActivityItem(
                    color: const Color(0xFFFF7043),
                    time: _formatDate(donation.createdAt),
                    title:
                        'Donated \$${donation.amount.toStringAsFixed(2)} to ${donation.projectTitle}',
                    subtitle: _impactSubtitle(donation),
                    isLast: index == visible.length - 1,
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required Color color,
    required String time,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.grey.withValues(alpha: 0.1),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppTheme.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: const Color(0xFF3491E3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.to(() => const DonationScreen()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3491E3), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Donate',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF3491E3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3491E3), Color(0xFF1B558C)],
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Get.to(() => const DonationScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Fund Impact',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareFAB() {
    return GestureDetector(
      onTap: () => Get.to(() => const DonationScreen()),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Color(0xFF3491E3), Color(0xFF1B558C)],
            center: Alignment.center,
            radius: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B558C).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  String _impactSubtitle(DonationRecordModel donation) {
    final parts = <String>[];
    if (donation.mealsFunded > 0) parts.add('${donation.mealsFunded} meals');
    if (donation.treesPlanted > 0) parts.add('${donation.treesPlanted} trees');
    if (donation.healthcareSupport > 0) {
      parts.add('${donation.healthcareSupport} care visits');
    }
    return parts.isEmpty ? 'Impact recorded' : parts.join(' • ');
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}


class CircularProgressPainter extends CustomPainter {
  final double progress; // e.g., 850
  final double maxProgress; // e.g., 1000

  CircularProgressPainter({required this.progress, this.maxProgress = 1000});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10; // leave some padding
    final strokeWidth = 10.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground progress arc
    final foregroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * 3.14159 * (progress / maxProgress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // start at 12 o'clock
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
