import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionStatus { pending, success, failed }

enum TransactionType { deposit, withdrawal, transfer }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final TransactionType type;
  final String? stripePaymentIntentId;
  final String? description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    this.currency = 'usd',
    required this.status,
    this.type = TransactionType.deposit,
    this.stripePaymentIntentId,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'type': type.name,
      'stripePaymentIntentId': stripePaymentIntentId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'usd',
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.deposit,
      ),
      stripePaymentIntentId: map['stripePaymentIntentId'],
      description: map['description'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  factory TransactionModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return TransactionModel.fromMap(data);
  }
}
