import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:united_union_bank/views/institutionalPortalScreens/project_management/project_lifecycle_screen.dart';
import '../../../theme/theme.dart';

// UI Constants matching the design
const kDashNavy = Color(0xFF0D2554);
const kDashAccentBlue = Color(0xFF3B61DA);
const kDashGreen = Color(0xFF14A35B);
const kDashOrange = Color(0xFFE88A1A);
const kProgressBlue = Color(0xFF2B449A);

class ProjectManagementTab extends StatelessWidget {
  const ProjectManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient Background ──
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ── Header Title ──
                Text(
                  'Project Management',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Search & Filter ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C7CA6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Search projects...',
                                    hintStyle: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C7CA6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── White Rounded Body ──
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
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        itemCount: _projects.length,
                        itemBuilder: (context, index) {
                          return _ProjectCard(item: _projects[index]);
                        },
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

// ── Static Mock Data ──

class _ProjectItem {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final double progress;

  const _ProjectItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.progress,
  });
}

const _projects = [
  _ProjectItem(
    title: 'Clean Water — Uganda',
    subtitle: 'UNICEF',
    status: 'EXECUTION',
    statusColor: kDashGreen,
    progress: 0.78,
  ),
  _ProjectItem(
    title: 'School Meals — Ghana',
    subtitle: 'WFP',
    status: 'DEVELOPMENT',
    statusColor: kDashAccentBlue,
    progress: 0.45,
  ),
  _ProjectItem(
    title: 'Medical Clinic — Kenya',
    subtitle: 'WHO',
    status: 'PLANNING',
    statusColor: kDashOrange,
    progress: 0.20,
  ),
  _ProjectItem(
    title: 'Reforestation — Brazil',
    subtitle: 'UN Environment',
    status: 'EXECUTION',
    statusColor: kDashGreen,
    progress: 0.92,
  ),
];

// ── Item Card Widget ──

class _ProjectCard extends StatelessWidget {
  final _ProjectItem item;
  const _ProjectCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectLifecycleScreen(projectTitle: item.title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDashNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: item.statusColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Progress',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                Text(
                  '${(item.progress * 100).toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kProgressBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: item.progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(kProgressBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
