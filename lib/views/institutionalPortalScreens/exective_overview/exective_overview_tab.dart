import '../../../theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExectiveOverviewTab extends StatelessWidget {
  ExectiveOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Full-screen gradient background ──
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          ),

          // ── Content over gradient ──
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const DashboardHeader(),
                const SizedBox(height: 20),

                // ── White rounded body ──
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.scaffoldBg,
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
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ProjectStatusSection(),
                            SizedBox(height: 24),
                            SystemStatusSection(),
                            SizedBox(height: 24),
                            VerificationAuditSection(),
                            SizedBox(height: 28),
                            InitiateButton(),
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
}

const kDashNavy = Color(0xFF0D2554);
const kDashAccentBlue = Color(0xFF1A6FBF);
const kDashGreen = Color(0xFF2ECC71);
const kDashOrange = Color(0xFFF39C12);

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Executive Overview',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white60,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SECURE SESSION',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _HeaderIconBtn(icon: Icons.notifications_none_rounded),
          const SizedBox(width: 10),
          _HeaderIconBtn(icon: Icons.tune_rounded),
        ],
      ),
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  const _HeaderIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class InitiateButton extends StatelessWidget {
  const InitiateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kDashAccentBlue, kDashNavy],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: kDashNavy.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            'Initiate New Project',
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectStatusSection extends StatelessWidget {
  const ProjectStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('PROJECT STATUS'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: '12',
                label: 'ACTIVE PROJECTS',
                isHighlighted: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value: '\$12.4M',
                label: 'TOTAL FUNDING',
                isHighlighted: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value: '8',
                label: 'IMPACT SCORE',
                isHighlighted: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlighted;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlighted
            ? kDashAccentBlue.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(
                color: kDashAccentBlue.withValues(alpha: 0.35),
                width: 1.5,
              )
            : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: kDashAccentBlue.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? kDashAccentBlue : kDashNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1.4,
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class StatusItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String count;
  final Color bgColor;
  final Color iconColor;
  final Color? subtitleColor;
  final Color countColor;

  const StatusItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.bgColor,
    required this.iconColor,
    required this.countColor,
    this.subtitleColor,
  });
}

// ── Section ───────────────────────────────────────────────────────────────────
class SystemStatusSection extends StatelessWidget {
  const SystemStatusSection({super.key});

  static const _items = [
    StatusItem(
      icon: Icons.settings_suggest_outlined,
      title: 'Planning',
      subtitle: 'Resource Allocation',
      count: '08',
      bgColor: Color(0xFFEEF3FF),
      iconColor: Color(0xFF6B7FD4),
      countColor: kDashNavy,
    ),
    StatusItem(
      icon: Icons.architecture_outlined,
      title: 'Development',
      subtitle: 'In Progress',
      count: '12',
      bgColor: Color(0xFFEDFFF5),
      iconColor: kDashGreen,
      subtitleColor: kDashGreen,
      countColor: kDashGreen,
    ),
    StatusItem(
      icon: Icons.rocket_launch_outlined,
      title: 'Execution',
      subtitle: 'Field Operations',
      count: '22',
      bgColor: Color(0xFFF3F0FF),
      iconColor: Color(0xFF7B6FD4),
      countColor: kDashNavy,
    ),
    StatusItem(
      icon: Icons.verified_user_outlined,
      title: 'Completed',
      subtitle: 'Impact Verified',
      count: '05',
      bgColor: Color(0xFFFFF8EE),
      iconColor: kDashOrange,
      subtitleColor: kDashOrange,
      countColor: kDashOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel('SYSTEM STATUS'),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kDashGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'LIVE',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: kDashGreen,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_items.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < _items.length - 1 ? 10 : 0),
            child: StatusCard(item: _items[i]),
          );
        }),
      ],
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────
class StatusCard extends StatelessWidget {
  final StatusItem item;
  const StatusCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: kDashNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: item.subtitleColor ?? Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.count,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: item.countColor,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationAuditSection extends StatelessWidget {
  const VerificationAuditSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('VERIFICATION AUDIT'),
        const SizedBox(height: 12),
        AuditCard(
          title: 'Uganda Infrastructure Grant',
          time: '2 hours ago',
          detail: 'Board Approval Hash: #772x',
          status: 'VERIFIED',
          statusColor: kDashGreen,
          accentColor: kDashGreen,
        ),
        const SizedBox(height: 10),
        AuditCard(
          title: 'Kenya Medical Logistics',
          time: '5 hours ago',
          detail: 'Financial Re-allocation',
          status: 'ADJUSTED',
          statusColor: kDashAccentBlue,
          accentColor: kDashAccentBlue,
        ),
      ],
    );
  }
}

// ── Audit Card ────────────────────────────────────────────────────────────────
class AuditCard extends StatelessWidget {
  final String title;
  final String time;
  final String detail;
  final String status;
  final Color statusColor;
  final Color accentColor;

  const AuditCard({
    super.key,
    required this.title,
    required this.time,
    required this.detail,
    required this.status,
    required this.statusColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left accent strip
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kDashNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(label: status, color: statusColor),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$time  •  $detail',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
