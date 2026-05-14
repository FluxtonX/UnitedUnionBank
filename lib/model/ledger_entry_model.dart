import 'package:cloud_firestore/cloud_firestore.dart';

class LedgerEntryModel {
  const LedgerEntryModel({
    required this.entryId,
    required this.uid,
    required this.currency,
    required this.amount,
    required this.direction,
    required this.type,
    required this.status,
    this.sourceType,
    this.sourceId,
    this.description,
    this.balanceAfter,
    required this.createdAt,
  });

  final String entryId;
  final String uid;
  final String currency;
  final double amount;
  final String direction;
  final String type;
  final String status;
  final String? sourceType;
  final String? sourceId;
  final String? description;
  final double? balanceAfter;
  final DateTime createdAt;

  bool get isCredit => direction == 'credit';

  String get signedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  factory LedgerEntryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final rawCreatedAt = data['createdAt'];

    DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return LedgerEntryModel(
      entryId: data['entryId'] ?? snapshot.id,
      uid: data['uid'] ?? '',
      currency: data['currency'] ?? 'usd',
      amount: (data['amount'] ?? 0).toDouble(),
      direction: data['direction'] ?? 'credit',
      type: data['type'] ?? 'deposit',
      status: data['status'] ?? 'posted',
      sourceType: data['sourceType'],
      sourceId: data['sourceId'],
      description: data['description'],
      balanceAfter: data['balanceAfter'] == null
          ? null
          : (data['balanceAfter'] as num).toDouble(),
      createdAt: createdAt,
    );
  }
}
