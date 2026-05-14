import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/impact_models.dart';

class ImpactService {
  ImpactService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<List<ImpactProjectModel>> activeProjects() {
    return _firestore
        .collection('projects')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ImpactProjectModel.fromSnapshot(doc))
              .toList(),
        );
  }

  static Stream<List<DonationRecordModel>> userDonations() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);

    return _firestore
        .collection('donations')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DonationRecordModel.fromSnapshot(doc))
              .toList(),
        );
  }
}
