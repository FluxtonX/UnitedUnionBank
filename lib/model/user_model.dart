import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? profileImage;
  final String? phoneNumber;
  final bool kycCompleted;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    this.profileImage,
    this.phoneNumber,
    this.kycCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'kycCompleted': kycCompleted,
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
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      name: snapshot['name'] ?? '',
      createdAt: snapshot['createdAt'] != null
          ? DateTime.parse(snapshot['createdAt'])
          : DateTime.now(),
      profileImage: snapshot['profileImage'],
      phoneNumber: snapshot['phoneNumber'],
      kycCompleted: snapshot['kycCompleted'] ?? false,
    );
  }
}
