class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? profileImage;
  final String? phoneNumber;
  final bool kycCompleted;
  final bool kycSkipped;
  final String kycStatus;
  final bool onboardingCompleted;
  final List<String> interests;
  final double walletBalance;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    this.profileImage,
    this.phoneNumber,
    this.kycCompleted = false,
    this.kycSkipped = false,
    String? kycStatus,
    this.onboardingCompleted = false,
    this.interests = const [],
    this.walletBalance = 0.0,
  }) : kycStatus = kycStatus ?? (kycCompleted ? 'approved' : 'not_started');

  bool get isKycApproved => kycStatus == 'approved';

  bool get needsInterestSelection => !onboardingCompleted || interests.length < 2;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'kycCompleted': kycCompleted,
      'kycSkipped': kycSkipped,
      'kycStatus': kycStatus,
      'onboardingCompleted': onboardingCompleted,
      'interests': interests,
      'walletBalance': walletBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      profileImage: map['profileImage'],
      phoneNumber: map['phoneNumber'],
      kycCompleted: map['kycCompleted'] ?? false,
      kycSkipped: map['kycSkipped'] ?? false,
      kycStatus: map['kycStatus'],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
      interests: List<String>.from(map['interests'] ?? const []),
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);
}
