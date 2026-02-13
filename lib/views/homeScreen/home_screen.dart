import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';
import '../tabs/accounts_tab.dart';
import '../tabs/impact_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/invest_tab.dart';
import '../tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // The actual index in the _tabs list

  final List<Widget> _tabs = const [
    HomeTab(),
    AccountsTab(),
    ImpactTab(),
    InvestTab(),
    ProfileTab(),
  ];

  static const List<_NavTabData> _tabData = [
    _NavTabData(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavTabData(
        Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Account'),
    _NavTabData(Icons.language_outlined, Icons.language, 'Impact'),
    _NavTabData(Icons.trending_up, Icons.trending_up, 'Invest'),
    _NavTabData(Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    // Generate the order of tabs to display: active tab moves to index 2
    List<int> displayOrder = [];
    List<int> others = [];
    for (int i = 0; i < _tabData.length; i++) {
        if (i != _selectedTab) others.add(i);
    }
    
    // Order: others[0], others[1], active, others[2], others[3]
    displayOrder.add(others[0]);
    displayOrder.add(others[1]);
    displayOrder.add(_selectedTab);
    displayOrder.add(others[2]);
    displayOrder.add(others[3]);

    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
           top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Container(
          clipBehavior: Clip.none,
          height: 80, // Safely increased height
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: displayOrder.map((index) => _buildNavItem(index)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedTab == index;
    final data = _tabData[index];

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isSelected) ...[
              Transform.translate(
                offset: const Offset(0, -16),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [Color(0xFF3491E3), Color(0xFF1B558C)],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B558C).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      data.filledIcon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B558C),
                ),
              ),
              const SizedBox(height: 6),
            ] else ...[
              Icon(
                data.outlineIcon,
                color: const Color(0xFF666666),
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                data.label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8), // Matching bottom spacing
            ],
          ],
        ),
      ),
    );
  }
}

class _NavTabData {
  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;

  const _NavTabData(this.outlineIcon, this.filledIcon, this.label);
}
