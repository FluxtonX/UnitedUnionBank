import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';
import 'enter_receiver_details_screen.dart';

class BankOption {
  final String name;
  final Color iconColor;
  final String initials;

  BankOption({required this.name, required this.iconColor, required this.initials});
}

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  final List<BankOption> _banks = [
    BankOption(name: 'Advans Microfinance Bank', iconColor: Colors.blueAccent, initials: 'A'),
    BankOption(name: 'Al Baraka Islamic Bank Limited', iconColor: Colors.redAccent, initials: 'AB'),
    BankOption(name: 'Alfa Pay', iconColor: Colors.orangeAccent, initials: 'AP'),
    BankOption(name: 'Allied Bank Limited', iconColor: Colors.indigo, initials: 'A'),
    BankOption(name: 'Apna MicrofinanceBank', iconColor: Colors.green, initials: 'A'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabs(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFavourites(),
                            _buildBankList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 50),
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppTheme.white,
                  size: 20,
                ),
              ),
              Text(
                'Bank Transfer',
                style: GoogleFonts.outfit(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Help',
                style: GoogleFonts.outfit(
                  color: AppTheme.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF3491E3), width: 2),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Send Money',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3491E3),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Center(
                  child: Text(
                    'History',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textHint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavourites() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Bank Favourites',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'See All',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Get.to(() => EnterReceiverDetailsScreen(
                bankName: 'Meminy Bank',
                bankIconColor: const Color(0xFF8B5CF6),
                bankInitials: 'M',
              ));
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3491E3), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'J',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3491E3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'John',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.scaffoldBg,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Bank by name',
                hintStyle: GoogleFonts.outfit(color: AppTheme.textHint),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ..._banks.map((bank) => _buildBankTile(bank)),
        ],
      ),
    );
  }

  Widget _buildBankTile(BankOption bank) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EnterReceiverDetailsScreen(
          bankName: bank.name,
          bankIconColor: bank.iconColor,
          bankInitials: bank.initials,
        ));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bank.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      bank.initials,
                      style: GoogleFonts.outfit(
                        color: bank.iconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    bank.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppTheme.textHint,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.divider),
        ],
      ),
    );
  }
}
