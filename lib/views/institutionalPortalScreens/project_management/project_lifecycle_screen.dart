import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:united_union_bank/views/institutionalPortalScreens/project_management/project_details_screen.dart';
import '../../../../theme/theme.dart';

const kDashNavy = Color(0xFF0D2554);
const kDashAccentBlue = Color(0xFF3B61DA);
const kBgLightBlue = Color(0xFFE9F1FC);
const kBorderLightBlue = Color(0xFF8BA9D1);
const kSolidBlue = Color(0xFF03449E);
const kCyanCard = Color(0xFF2E84A9);
const kBtnBlue = Color(0xFF2242AC);
const kBtnDark = Color(0xFF1D263B);

class ProjectLifecycleScreen extends StatelessWidget {
  final String projectTitle;

  const ProjectLifecycleScreen({super.key, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient Header ──
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),

                // ── White Rounded Body ──
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                        child: Column(
                          children: [
                            _buildTimeline(),
                            const SizedBox(height: 20),
                            _buildOverallProgressCard(context),
                            const SizedBox(height: 20),
                            _buildBottomButtons(),
                          ],
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Project Lifecycle',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  projectTitle,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // balance back button
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _TimelineStep(
          icon: Icons.edit_note_rounded,
          isCompleted: true,
          card: _buildCompletedCard(
            'Design',
            'Architecture and feasibility study\nfinalized.',
          ),
        ),
        _TimelineStep(
          icon: Icons.build_rounded,
          isCompleted: true,
          card: _buildCompletedCard(
            'Development',
            'Infrastructure and logistics chain\nestablished.',
          ),
        ),
        _TimelineStep(
          icon: Icons.rocket_launch_rounded,
          isCompleted: true,
          hasDot: true,
          card: _buildImplementationCard(),
        ),
        _TimelineStep(
          icon: Icons.rate_review_rounded,
          isCompleted: false,
          isLast: true,
          card: _buildReviewCard(),
        ),
      ],
    );
  }

  Widget _buildCompletedCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgLightBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderLightBlue.withAlpha(150), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kSolidBlue,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: kSolidBlue,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'COMPLETED',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: kSolidBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImplementationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSolidBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kSolidBlue.withValues(alpha: 0.2),
            blurRadius: 10,
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
                'Implementation',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '78%',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.78,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'IN PROGRESS - ON SCHEDULE',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kBorderLightBlue,
                ),
              ),
              Text(
                'PENDING',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: kBorderLightBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Final audit and impact\nassessment phase.',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProjectDetailsScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: kCyanCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OVERALL PROGRESS',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '78%',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EST. COMPLETION',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'March 2026',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kBtnBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Update Status',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kBtnDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            icon: const Icon(
              Icons.ios_share_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Share Report',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final bool isCompleted;
  final bool hasDot;
  final bool isLast;
  final Widget card;

  const _TimelineStep({
    required this.icon,
    required this.isCompleted,
    this.hasDot = false,
    this.isLast = false,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Graphic Node
          SizedBox(
            width: 56,
            child: Column(
              children: [
                _buildNode(),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade800),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: card,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    if (isCompleted) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSolidBlue,
              border: Border.all(color: Colors.lightBlue.shade400, width: 3),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (hasDot)
            Positioned(
              right: -2,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kSolidBlue,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      );
    }

    // Grey Dashed-like Node
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
        // Since Flutter dashed borders require an external package (like dotted_border)
        // or a CustomPainter, we'll emulate the look using a dark solid border to ensure robust behavior.
        border: Border.all(color: Colors.grey.shade700, width: 2),
      ),
      child: Icon(icon, color: Colors.grey.shade700, size: 24),
    );
  }
}
