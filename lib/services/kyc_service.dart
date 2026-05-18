import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'api_client.dart';

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

  static Future<String> submitMockKycCase(MockKycSubmission submission) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('User must be authenticated to submit KYC.');
    }

    final formData = FormData.fromMap({
      'provider': 'mock_onfido',
      'documentType': submission.documentType,
      'streetAddress': submission.streetAddress,
      'city': submission.city,
      'postalCode': submission.postalCode,
      'documentFront': await MultipartFile.fromFile(
        submission.documentFront.path,
        filename: 'document_front.jpg',
      ),
      'documentBack': await MultipartFile.fromFile(
        submission.documentBack.path,
        filename: 'document_back.jpg',
      ),
      'selfie': await MultipartFile.fromFile(
        submission.selfie.path,
        filename: 'selfie.jpg',
      ),
      'addressProof': await MultipartFile.fromFile(
        submission.addressProof.path,
        filename: 'address_proof.jpg',
      ),
    });

    final response = await ApiClient.dio.post(
      '/kyc/cases',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    final data = Map<String, dynamic>.from(response.data as Map);
    return data['caseId'] as String? ?? data['id'] as String;
  }
}
