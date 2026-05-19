import 'package:flutter/material.dart';


const kDashNavy = Color(0xFF0D2554);
const kDashAccentBlue = Color(0xFF3B61DA);
const kBgLightBlue = Color(0xFFEDF3FB);
const kCardBg = Color(0xFFE9F1FA);
const kTextBlue = Color(0xFF133682);
const kSectionTitleColor = Color(0xFF86A0BE);

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient Background for Header
          Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2F89C6), Color(0xFF0F285D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context),
                const SizedBox(height: 16),

                // White Rounded Body
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
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildGlobalStatusCard(),
                            const SizedBox(height: 32),
                            _buildLifecycleSection(),
                            const SizedBox(height: 32),
                            _buildFieldTeamSection(),
                            const SizedBox(height: 32),
                            _buildMilestonesSection(),
                            const SizedBox(height: 32),
                            _buildAuditTrailSection(),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  'Clean Water Initiative',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Secured Portal • NGO-772',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balances the Row
        ],
      ),
    );
  }

  // ── 1. GLOBAL STATUS CARD ──
  Widget _buildGlobalStatusCard() {
    return Transform.translate(
      offset: const Offset(0, -20),
      // Use negative margin-like translation to overlay it slightly
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF004499), // Deep blue
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF004499).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GLOBAL STATUS',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '75.4%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF32AEF1), // Bright Cyany-blue
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'IN PROGRESS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'EST. COMPLETION: OCT 2024',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.754,
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF32AEF1)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.public, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'East Africa Cluster',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '\$4.2M Allocated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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

  // ── 2. PROJECT LIFECYCLE ──
  Widget _buildLifecycleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROJECT LIFECYCLE',
            style: TextStyle(
              color: kSectionTitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Timeline Steps
          _buildLifecycleStep(
            nodeContent: _buildCheckedCircle(),
            title: 'Phase 02: Infrastructure Dev',
            subtitle: 'Supplier contracts signed and validated.',
            titleColor: kTextBlue.withValues(alpha: 0.6),
            isLast: false,
          ),
          _buildLifecycleStep(
            nodeContent: _buildActiveCircle(),
            title: 'Phase 03:\nImplementation',
            subtitle: 'Groundwater drilling active in Cluster B.',
            titleColor: kTextBlue.withValues(alpha: 0.8),
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF3F8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ACTIVE',
                style: TextStyle(
                  color: kDashNavy,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLast: false,
            isNextBlue: false, // line after this is light blue?
          ),
          _buildLifecycleStep(
            nodeContent: _buildLockedCircle(),
            title: 'Phase 04: Compliance Review',
            subtitle: 'Awaiting implementation completion.',
            titleColor: kTextBlue.withValues(alpha: 0.6),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckedCircle() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF389EE5),
        shape: BoxShape.circle,
        border: Border.all(color: kDashNavy, width: 2),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 24),
    );
  }

  Widget _buildActiveCircle() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF07215B),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF389EE5), width: 2.5),
      ),
      child: const Icon(Icons.sync_rounded, color: Colors.white, size: 22),
    );
  }

  Widget _buildLockedCircle() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF07215B), width: 2),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Color(0xFF389EE5),
        size: 20,
      ),
    );
  }

  Widget _buildLifecycleStep({
    required Widget nodeContent,
    required String title,
    required String subtitle,
    required Color titleColor,
    required bool isLast,
    bool isNextBlue = true,
    Widget? trailingWidget,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                nodeContent,
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isNextBlue
                          ? const Color(0xFF389EE5)
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailingWidget != null) trailingWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. ACTIVE FIELD TEAM ──
  Widget _buildFieldTeamSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE FIELD TEAM',
            style: TextStyle(
              color: kSectionTitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamMember('Dr. Aris V.', 'LEAD DEV', isOnline: true),
              _buildTeamMember('Sarah L.', 'NGO LIAISON'),
              _buildTeamMember('K. Mwangi', 'SAFETY SPC.'),
              _buildTeamMember('Elena R.', 'BUDGETING'),
              _buildAddMember(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, {bool isOnline = false}) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFF1E355B), // placeholder avatar bg
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white70, size: 30),
            ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2147),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: const Color(0xFFE8F1FC),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          role,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddMember() {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 2),
            // Dashed look is ideal, solid will suffice for mock
          ),
          child: const Icon(Icons.add, color: Color(0xFF4C6A98), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Add Mem...',
          style: TextStyle(
            color: const Color(0xFFE8F1FC),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '', // Spacer for layout matching
          style: const TextStyle(fontSize: 8),
        ),
      ],
    );
  }

  // ── 4. CRITICAL MILESTONES ──
  Widget _buildMilestonesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CRITICAL MILESTONES',
                style: TextStyle(
                  color: kSectionTitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: kDashNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMilestoneCard(
            icon: Icons.water_drop_rounded,
            iconBg: const Color(0xFF909ACD),
            title: 'Cluster B Drilling',
            date: 'Aug 28, 2024',
            badgeText: '2 DAYS LEFT',
            badgeColor: const Color(0xFFEB602E),
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            icon: Icons.people_alt_rounded,
            iconBg: const Color(0xFF2E3A59),
            title: 'Village Training',
            date: 'Sep 05, 2024',
            badgeText: 'UPCOMING',
            badgeColor: const Color(0xFF7D879E),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String date,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: kTextBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 14,
          ),
        ],
      ),
    );
  }

  // ── 5. SECURITY AUDIT TRAIL ──
  Widget _buildAuditTrailSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.security,
                    color: kSectionTitleColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SECURITY AUDIT TRAIL',
                    style: TextStyle(
                      color: kSectionTitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Text(
                'ENCRYPTED_LOGS_V2',
                style: TextStyle(
                  color: Colors.blue.withValues(alpha: 0.4),
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildAuditLog(
            color: const Color(0xFF1EA786),
            contentSpan: TextSpan(
              text: 'Aris V. updated Implementation status to ',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: '75.4%',
                  style: TextStyle(
                    color: kTextBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: 'Today at 14:22 • IP: 192.168.1.44',
          ),
          _buildAuditLog(
            color: const Color(0xFF6A79A5), // Dark purple/blue
            contentSpan: TextSpan(
              text:
                  'System Log: Milestone "Cluster A Inspection" verified by 3-factor stakeholder consensus.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: 'Yesterday at 18:05 - Blockchain Ref: 0x77d...',
          ),
          _buildAuditLog(
            color: Colors.grey.shade400,
            contentSpan: TextSpan(
              text: 'Sarah L. uploaded revised terrain maps for Cluster C.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: 'Aug 24 at 11:10',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLog({
    required Color color,
    required TextSpan contentSpan,
    required String subtitle,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withAlpha(80),
                      width: 2,
                    ), // soft glow
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: contentSpan),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
