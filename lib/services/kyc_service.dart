import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MockKycSubmission {
  const MockKycSubmission({
    required this.documentType,
    required this.documentFront,
    required this.documentBack,
    required this.selfie,
    required this.addressProof,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
  });

  final String documentType;
  final File documentFront;
  final File documentBack;
  final File selfie;
  final File addressProof;
  final String streetAddress;
  final String city;
  final String postalCode;
}

class KycService {
  KycService._();

  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> submitMockKycCase(MockKycSubmission submission) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('User must be authenticated to submit KYC.');
    }

    final caseId = 'kyc_${DateTime.now().millisecondsSinceEpoch}';
    final basePath = 'kyc/${user.uid}/$caseId';

    final frontPath = await _uploadFile(
      path: '$basePath/document_front.jpg',
      file: submission.documentFront,
    );
    final backPath = await _uploadFile(
      path: '$basePath/document_back.jpg',
      file: submission.documentBack,
    );
    final selfiePath = await _uploadFile(
      path: '$basePath/selfie.jpg',
      file: submission.selfie,
    );
    final addressPath = await _uploadFile(
      path: '$basePath/address_proof.jpg',
      file: submission.addressProof,
    );

    final callable = _functions.httpsCallable('submitKycCase');
    final result = await callable.call(<String, dynamic>{
      'caseId': caseId,
      'provider': 'mock_onfido',
      'documentType': submission.documentType,
      'documentFrontPath': frontPath,
      'documentBackPath': backPath,
      'selfiePath': selfiePath,
      'addressProofPath': addressPath,
      'personalInfo': {
        'streetAddress': submission.streetAddress,
        'city': submission.city,
        'postalCode': submission.postalCode,
      },
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    return data['caseId'] as String;
  }

  static Future<String> _uploadFile({
    required String path,
    required File file,
  }) async {
    final ref = _storage.ref(path);
    await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return path;
  }
}
