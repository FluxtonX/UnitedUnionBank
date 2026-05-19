import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:united_union_bank/views/institutionalPortalScreens/exective_overview/exective_overview_tab.dart';
import 'package:united_union_bank/views/institutionalPortalScreens/project_management/project_management_tab.dart';
import 'package:united_union_bank/views/institutionalPortalScreens/reports/reports_tab.dart';

const _kNavy = Color(0xFF0D2554);

class PortalMainTabScreen extends StatefulWidget {
  const PortalMainTabScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PortalMainTabScreenState createState() => _PortalMainTabScreenState();
}

class _PortalMainTabScreenState extends State<PortalMainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
     ExectiveOverviewTab(),
    const ProjectManagementTab(),
    const ReportsTab(),
    const Center(child: Text('working on........')),
  ];

  final _navItems = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'OVERVIEW'),
    _NavItem(icon: Icons.business_center_rounded, label: 'PROJECTS'),
    _NavItem(icon: Icons.insert_chart_rounded, label: 'REPORTS'),
    _NavItem(icon: Icons.settings_rounded, label: 'SETTINGS'),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final selected = _currentIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? _kNavy.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _navItems[i].icon,
                        color: selected ? _kNavy : Colors.grey.shade400,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _navItems[i].label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: selected ? _kNavy : Colors.grey.shade400,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
