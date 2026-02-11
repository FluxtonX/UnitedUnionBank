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
  int _selectedTab = 0; // Home is first tab (index 0)

  final List<Widget> _tabs = const [
    HomeTab(),
    AccountsTab(),
    ImpactTab(),
    InvestTab(),
    ProfileTab(),
  ];

  // Tab config: [outlineIcon, filledIcon, label]
  static const List<_NavTabData> _tabData = [
    _NavTabData(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavTabData(
        Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Accounts'),
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
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabData.length, (index) {
              // Center tab (Accounts at index 1 in screenshots, but we keep
              // it consistent with whatever the user selects)
              return _buildNavItem(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedTab == index;
    final data = _tabData[index];
    // Center tab gets the raised square treatment
    final isCenterTab = index == 2; // Impact (center)

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isCenterTab && isSelected ? 52 : 40,
              height: isCenterTab && isSelected ? 52 : 40,
              transform: isSelected
                  ? (Matrix4.translationValues(0, -4, 0))
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryLight
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                    isCenterTab && isSelected ? 16 : 14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              AppTheme.primaryLight.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isSelected ? data.filledIcon : data.outlineIcon,
                color: isSelected ? AppTheme.white : AppTheme.textHint,
                size: isCenterTab && isSelected ? 26 : 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryLight : AppTheme.textHint,
              ),
            ),
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
