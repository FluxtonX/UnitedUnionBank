import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';
import '../../config/app_images.dart';

/// The dashboard content shown in the Home tab within the main HomeScreen shell.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(),
            _buildVerificationBanner(),
            _buildBalanceCard(),
            _buildQuickActions(),
            _buildImpactSection(),
            _buildRecentTransactions(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Top gradient header ──────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'United Union Bank',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppTheme.white.withValues(alpha: 0.3), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(AppImages.appLogo, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Verification banner ──────────────────────────────────────────────
  Widget _buildVerificationBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_user_outlined,
                color: AppTheme.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Verification',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Verify your identity to unlock all features',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppTheme.white, size: 14),
        ],
      ),
    );
  }

  // ── Balance card ─────────────────────────────────────────────────────
  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BALANCE',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHint,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        size: 14, color: AppTheme.primaryLight),
                    const SizedBox(width: 4),
                    Text(
                      'Impact Score: 850',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$12,450.00',
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.visibility_outlined,
                  size: 20, color: AppTheme.textHint),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⊛ + 2,480 GBT',
                style: GoogleFonts.outfit(
                    fontSize: 13, color: AppTheme.textSecondary),
              ),
              Text(
                'View Details >',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quick‑action buttons ─────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.send, 'label': 'Send', 'color': AppTheme.sendBg},
      {
        'icon': Icons.call_received,
        'label': 'Request',
        'color': AppTheme.requestBg
      },
      {
        'icon': Icons.volunteer_activism,
        'label': 'Donate',
        'color': AppTheme.donateBg
      },
      {
        'icon': Icons.swap_horiz,
        'label': 'Exchange',
        'color': AppTheme.exchangeBg
      },
      {
        'icon': Icons.trending_up,
        'label': 'Invest',
        'color': AppTheme.investBg
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((a) {
          return Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(a['icon'] as IconData,
                    color: a['color'] as Color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                a['label'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Your Impact Today section ────────────────────────────────────────
  Widget _buildImpactSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Impact Today',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'View All →',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildImpactCard(Icons.park, '47', 'Trees Planted',
                  '+3 this week', AppTheme.success),
              const SizedBox(width: 10),
              _buildImpactCard(Icons.restaurant, '230', 'Meals Provided',
                  '+15 this week', AppTheme.primaryLight),
              const SizedBox(width: 10),
              _buildImpactCard(Icons.local_hospital, '12', 'Medical Visits',
                  '3 communities', AppTheme.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(
      IconData icon, String value, String label, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                    fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text(sub,
                style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── Recent transactions ──────────────────────────────────────────────
  Widget _buildRecentTransactions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'See All →',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTransactionTile(
              Icons.coffee, Colors.brown, 'Starbucks',
              'Coffee & Dining • Today', '-\$4.50', false),
          _buildTransactionTile(
              Icons.account_balance, AppTheme.success, 'Direct Deposit',
              'Salary • Yesterday', '+\$3,280.00', true),
          _buildTransactionTile(
              Icons.favorite, Colors.redAccent, 'UNICEF',
              'Donation • Mar 1', '-\$25.00', false),
          _buildTransactionTile(
              Icons.swap_horiz, AppTheme.exchangeBg, 'Currency Exchange',
              'USD→EUR • Feb 28', '-\$100.00', false),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(IconData icon, Color iconColor, String title,
      String subtitle, String amount, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.outfit(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppTheme.success : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
