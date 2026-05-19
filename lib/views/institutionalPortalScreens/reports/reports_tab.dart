import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

const kDashNavy = Color(0xFF0D2554);
const kDashAccentBlue = Color(0xFF3B61DA);
const kExportBlue = Color(0xFF233A9A);
const kIconBgColor = Color(0xFFEEF3F8);

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

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
                const SizedBox(height: 16),

                // ── Header Titles ──
                Text(
                  'Audit Trail & Compliance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-time oversight for global impact projects',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Filter & Export Actions ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Filter Button
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Filter by date...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Export Button
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: kExportBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.ios_share_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Export',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── White Rounded Content Area ──
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
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        children: [
                          ..._auditItems.map((item) => _AuditCard(item: item)),
                          const SizedBox(height: 8),
                          const _CompliantStatusCard(),
                        ],
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

// ── Shared Data Model ──

class _AuditItem {
  final IconData icon;
  final String title;
  final String author;
  final String time;

  const _AuditItem({
    required this.icon,
    required this.title,
    required this.author,
    required this.time,
  });
}

const _auditItems = [
  _AuditItem(
    icon: Icons.account_balance_wallet_rounded,
    title: 'Budget Approved',
    author: 'Sarah Chen • Admin',
    time: '2024-02-13 14:23',
  ),
  _AuditItem(
    icon: Icons.description_rounded,
    title: 'Document Upload',
    author: 'John Smith • PM',
    time: '2024-02-13 11:45',
  ),
  _AuditItem(
    icon: Icons.edit_note_rounded,
    title: 'Status Change',
    author: 'Maria Garcia • Partner',
    time: '2024-02-12 16:30',
  ),
  _AuditItem(
    icon: Icons.verified_rounded,
    title: 'Compliance Review',
    author: 'System Auto',
    time: '2024-02-12 09:00',
  ),
  _AuditItem(
    icon: Icons.payments_rounded,
    title: 'Fund Transfer',
    author: 'David Lee • Finance',
    time: '2024-02-11 13:15',
  ),
];

// ── UI Components ──

class _AuditCard extends StatelessWidget {
  final _AuditItem item;
  const _AuditCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading Circular Icon
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: kIconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: kDashAccentBlue, size: 22),
          ),
          const SizedBox(width: 14),

          // Center Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: kDashNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.author,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Trailing Details Text
          Row(
            children: [
              Text(
                'Details',
                style: TextStyle(
                  color: kDashAccentBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.arrow_right_alt_rounded,
                color: kDashAccentBlue,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompliantStatusCard extends StatelessWidget {
  const _CompliantStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2F0F9), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2944AB),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'All Systems Compliant',
                style: TextStyle(
                  color: const Color(0xFF2944AB),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Last comprehensive audit: Feb 10,2024',
            style: TextStyle(
              color: const Color(0xFF6781B8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
