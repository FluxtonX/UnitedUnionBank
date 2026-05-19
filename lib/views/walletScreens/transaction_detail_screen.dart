import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../model/ledger_entry_model.dart';
import '../../theme/theme.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.entry});

  final LedgerEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final isCredit = entry.isCredit;

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
          'Transaction Detail',
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
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
                    size: 32,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  entry.signedAmount,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isCredit ? AppTheme.success : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _titleFor(entry),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _detailCard([
            _row('Status', entry.status),
            _row('Type', entry.type),
            _row('Direction', entry.direction),
            _row('Currency', entry.currency.toUpperCase()),
            if (entry.balanceAfter != null)
              _row('Balance After', '\$${entry.balanceAfter!.toStringAsFixed(2)}'),
            _row('Date', _formatDate(entry.createdAt)),
            _row('Entry ID', entry.entryId),
            if (entry.sourceType != null) _row('Source', entry.sourceType!),
            if (entry.sourceId != null) _row('Source ID', entry.sourceId!),
          ]),
        ],
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _titleFor(LedgerEntryModel entry) {
    if (entry.description?.isNotEmpty ?? false) return entry.description!;
    switch (entry.type) {
      case 'deposit':
        return 'Wallet deposit';
      case 'donation':
        return 'Donation';
      case 'withdrawal_hold':
        return 'Withdrawal request';
      default:
        return entry.type;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
