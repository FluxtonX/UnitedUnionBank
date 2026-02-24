import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../theme/theme.dart';
import '../../config/app_images.dart';
import '../sendMoneyScreens/bank_transfer_screen.dart';

/// The dashboard content shown in the Home tab within the main HomeScreen shell.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isBalanceVisible = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B558C), // Match header color for seamless look
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
              child: SingleChildScrollView(
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
               
                    _buildBalanceCard(),
                    _buildQuickActions(),
                    _buildImpactSection(),
                    _buildRecentTransactions(),
                    _buildUpdatesSection(),
                    _buildLoadMoreButton(),
                    const SizedBox(height: 40),
                  ],
                ),
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
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
        border: Border(
           bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'GreenBank',
                  style: GoogleFonts.outfit(
                    color: AppTheme.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B558C).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                _isBalanceVisible ? '\$12,450.00' : '\$ ••••••',
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                child: Icon(
                  _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppTheme.textHint,
                ),
              ),
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

  Widget _buildQuickActions() {
    final actions = [
      {'icon': AppIcons.sendIcon, 'label': 'Send'},
      {'icon': AppIcons.requestIcon, 'label': 'Request'},
      {'icon': AppIcons.donateIcon, 'label': 'Donate'},
      {'icon': AppIcons.exchangeIcon, 'label': 'Exchange'},
      {'icon': AppIcons.investIcon, 'label': 'Invest'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((a) {
          return GestureDetector(
            onTap: () {
              if (a['label'] == 'Send') {
                Get.to(() => const BankTransferScreen());
              }
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF3491E3), Color(0xFF1B558C)],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      a['icon'] as String,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  a['label'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
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
              Expanded(
                child: _buildImpactCard(AppIcons.treeIcon, '47', 'Trees Planted',
                    '+3 this week', const Color(0xFF003366)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(AppIcons.mealIcon, '230', 'Meals Provided',
                    '+15 this week', const Color(0xFF003366)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(AppIcons.medicalIcon, '12', 'Medical Visits',
                    '3 communities', const Color(0xFF003366)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(
      String icon, String value, String label, String sub, Color color) {
    return Container(
      height: 106,
      padding: const EdgeInsets.only(top:12,bottom: 2),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(icon, width: 20, height: 20,),
          const SizedBox(height: 6,),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B558C),
            ),
          ),
          const SizedBox(height: 8,),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 2,),
          Text(
            sub,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: const Color(0xFF3491E3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

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
              AppIcons.teaIcon, Colors.brown, 'Starbucks',
              'Coffee & Dining • Today', '-\$4.50', false,
              badge: {'text': '+2', 'icon': AppIcons.treeIcon, 'color': const Color(0xFFC5E1A5)}),
          _buildTransactionTile(
              AppIcons.depositIcon, AppTheme.success, 'Direct Deposit',
              'Salary • Yesterday', '+\$3,280.00', true),
          _buildTransactionTile(
              AppIcons.donateIcon, Colors.redAccent, 'UNICEF',
              'Donation • Mar 1', '-\$25.00', false,
              badge: {'text': '10 meals', 'icon': AppIcons.mealIcon, 'color': const Color(0xFFC5CAE9)}),
          _buildTransactionTile(
              AppIcons.exchangeIcon, AppTheme.exchangeBg, 'Currency Exchange',
              'USD→EUR • Feb 28', '-\$100.00', false),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String iconPath, Color iconColor, String title,
      String subtitle, String amount, bool isPositive, {Map<String, dynamic>? badge}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Image.asset(iconPath, width: 24, height: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.outfit(
                        fontSize: 13, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? const Color(0xFF3491E3) : AppTheme.textPrimary,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (badge['color'] as Color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(badge['icon'] as String, width: 12, height: 12, color: Colors.green[800]),
                      const SizedBox(width: 4),
                      Text(
                        badge['text'] as String,
                        style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[900]),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Updates You Care About section ────────────────────────────────────
  Widget _buildUpdatesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Updates You Care About',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildUpdateCard(
            category: 'Climate Action',
            categoryColor: const Color(0xFF3491E3),
            title: 'Amazon Reforestation Project Reaches 10,000 Trees',
            description: 'Community-led initiative plants native species in the heart of the rainforest...',
            image: AppImages.amazonProjectThumbnail,
            timeInfo: '2h ago • 3 min read',
          ),
          const SizedBox(height: 20),
          _buildUpdateCard(
            category: 'Clean Water',
            categoryColor: const Color(0xFF00BCD4),
            title: 'New Well Provides Clean Water to 500 Families',
            description: 'Your donations helped build sustainable water sources for communities in need...',
            image: AppImages.cleanWaterThumbnail,
            timeInfo: '5h ago • 2 min read',
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard({
    required String category,
    required Color categoryColor,
    required String title,
    required String description,
    required String image,
    required String timeInfo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeInfo,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppTheme.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.bookmark_border, color: AppTheme.textSecondary, size: 22),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Load More',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3491E3),
            ),
          ),
        ),
      ),
    );
  }
}
