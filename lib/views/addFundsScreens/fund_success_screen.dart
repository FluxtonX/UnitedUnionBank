import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../theme/theme.dart';
import '../homeScreen/home_screen.dart';
import 'add_funds_screen.dart';

class FundSuccessScreen extends StatefulWidget {
  final double amount;
  final double newBalance;
  final bool isConfirmed;

  const FundSuccessScreen({
    super.key,
    required this.amount,
    required this.newBalance,
    this.isConfirmed = true,
  });

  @override
  State<FundSuccessScreen> createState() => _FundSuccessScreenState();
}

class _FundSuccessScreenState extends State<FundSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Animated Checkmark
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                            center: Alignment.center,
                            radius: 0.8,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF26A69A)
                                  .withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        widget.isConfirmed ? 'Funds Added!' : 'Payment Received',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        widget.isConfirmed
                            ? 'Your wallet has been topped up successfully'
                            : 'Stripe confirmed your payment. Your wallet balance may update shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Amount Card
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Amount Added',
                              '+\$${widget.amount.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF26A69A),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                color: Colors.grey.withValues(alpha: 0.15),
                                height: 1,
                              ),
                            ),
                            _buildInfoRow(
                              widget.isConfirmed ? 'New Balance' : 'Expected Balance',
                              '\$${widget.newBalance.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF1B558C),
                              isBold: true,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                color: Colors.grey.withValues(alpha: 0.15),
                                height: 1,
                              ),
                            ),
                            _buildInfoRow(
                              'Date',
                              _formattedDate(),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              'Status',
                              widget.isConfirmed ? 'Completed' : 'Updating',
                              valueColor: widget.isConfirmed
                                  ? const Color(0xFF26A69A)
                                  : const Color(0xFFF59E0B),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    // Back to Home Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: GestureDetector(
                        onTap: () => Get.offAll(() => const HomeScreen()),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3491E3), Color(0xFF1B558C)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B558C)
                                    .withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Back to Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextButton(
                        onPressed: () =>
                            Get.off(() => const AddFundsScreen()),
                        child: Text(
                          'Add More Funds',
                          style: TextStyle(
                            color: const Color(0xFF3491E3),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
