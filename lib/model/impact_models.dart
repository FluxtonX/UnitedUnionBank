import 'package:cloud_firestore/cloud_firestore.dart';

class ImpactProjectModel {
  const ImpactProjectModel({
    required this.projectId,
    required this.title,
    required this.category,
    required this.status,
    required this.targetAmount,
    required this.totalDonated,
    required this.mealsFunded,
    required this.treesPlanted,
    required this.healthcareSupport,
  });

  final String projectId;
  final String title;
  final String category;
  final String status;
  final double targetAmount;
  final double totalDonated;
  final int mealsFunded;
  final int treesPlanted;
  final int healthcareSupport;

  double get progress {
    if (targetAmount <= 0) return 0;
    return (totalDonated / targetAmount).clamp(0, 1).toDouble();
  }

  factory ImpactProjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final metrics = Map<String, dynamic>.from(data['metrics'] ?? const {});

    return ImpactProjectModel(
      projectId: data['projectId'] ?? snapshot.id,
      title: data['title'] ?? 'Impact Project',
      category: data['category'] ?? 'impact',
      status: data['status'] ?? 'active',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      totalDonated: (data['totalDonated'] ?? 0).toDouble(),
      mealsFunded: (metrics['mealsFunded'] ?? 0).toInt(),
      treesPlanted: (metrics['treesPlanted'] ?? 0).toInt(),
      healthcareSupport: (metrics['healthcareSupport'] ?? 0).toInt(),
    );
  }
}

class DonationRecordModel {
  const DonationRecordModel({
    required this.donationId,
    required this.projectTitle,
    required this.amount,
    required this.currency,
    required this.receiptNumber,
    required this.mealsFunded,
    required this.treesPlanted,
    required this.healthcareSupport,
    required this.createdAt,
  });

  final String donationId;
  final String projectTitle;
  final double amount;
  final String currency;
  final String receiptNumber;
  final int mealsFunded;
  final int treesPlanted;
  final int healthcareSupport;
  final DateTime createdAt;

  factory DonationRecordModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final metrics = Map<String, dynamic>.from(data['impactMetrics'] ?? const {});
    final rawCreatedAt = data['createdAt'];
    DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return DonationRecordModel(
      donationId: data['donationId'] ?? snapshot.id,
      projectTitle: data['projectTitle'] ?? 'Impact Project',
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'usd',
      receiptNumber: data['receiptNumber'] ?? '',
      mealsFunded: (metrics['meals'] ?? metrics['mealsFunded'] ?? 0).toInt(),
      treesPlanted: (metrics['trees'] ?? metrics['treesPlanted'] ?? 0).toInt(),
      healthcareSupport:
          (metrics['healthcare'] ?? metrics['healthcareSupport'] ?? 0).toInt(),
      createdAt: createdAt,
    );
  }
}

class ImpactSummary {
  const ImpactSummary({
    required this.totalDonated,
    required this.mealsFunded,
    required this.treesPlanted,
    required this.healthcareSupport,
  });

  final double totalDonated;
  final int mealsFunded;
  final int treesPlanted;
  final int healthcareSupport;

  factory ImpactSummary.fromDonations(List<DonationRecordModel> donations) {
    return ImpactSummary(
      totalDonated:
          donations.fold<double>(0, (total, item) => total + item.amount),
      mealsFunded:
          donations.fold<int>(0, (total, item) => total + item.mealsFunded),
      treesPlanted:
          donations.fold<int>(0, (total, item) => total + item.treesPlanted),
      healthcareSupport:
          donations.fold<int>(0, (total, item) => total + item.healthcareSupport),
    );
  }

  factory ImpactSummary.fromProjects(List<ImpactProjectModel> projects) {
    return ImpactSummary(
      totalDonated:
          projects.fold<double>(0, (total, item) => total + item.totalDonated),
      mealsFunded:
          projects.fold<int>(0, (total, item) => total + item.mealsFunded),
      treesPlanted:
          projects.fold<int>(0, (total, item) => total + item.treesPlanted),
      healthcareSupport:
          projects.fold<int>(0, (total, item) => total + item.healthcareSupport),
    );
  }
}
