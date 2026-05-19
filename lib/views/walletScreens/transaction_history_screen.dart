import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controllers/wallet_controller.dart';
import '../../model/ledger_entry_model.dart';
import '../../theme/theme.dart';
import 'transaction_detail_screen.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalletController.instance;
    controller.fetchTransactions();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B558C),
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.white),
        ),
        title: Text(
          'Transactions',
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final entries = controller.transactions;
        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No ledger activity yet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchTransactions,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => _tile(entries[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: entries.length,
          ),
        );
      }),
    );
  }

  Widget _tile(LedgerEntryModel entry) {
    final isCredit = entry.isCredit;
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.to(() => TransactionDetailScreen(entry: entry)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: (isCredit ? AppTheme.success : AppTheme.primary)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCredit ? AppTheme.success : AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.description ?? entry.type,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${entry.status} • ${entry.currency.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                entry.signedAmount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? AppTheme.success : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
