import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:united_union_bank/model/user_model.dart';
import 'package:united_union_bank/services/api_client.dart';
import 'package:united_union_bank/views/authScreens/causesScreen/causes_screen.dart';
import 'package:united_union_bank/views/authScreens/verifyEmailScreen/verify_email_screen.dart';
import 'package:united_union_bank/views/homeScreen/home_screen.dart';
import 'package:united_union_bank/views/authScreens/loginScreen/login_screen.dart';
import 'package:united_union_bank/views/kycScreens/kyc_overview_screen.dart';
import 'package:united_union_bank/views/kycScreens/kyc_status_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GetStorage _storage = GetStorage();

  late Rx<User?> _firebaseUser;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onReady() {
    super.onReady();
    ApiClient.onUnauthorized = _handleUnauthorizedSession;
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      if (_isPhoneLoggedIn) {
        _loadPhoneLoginData();
      } else {
        userModel.value = null;
      }
    } else {
      await _fetchUserData(user, createIfMissing: true);
    }
  }

  bool get _isPhoneLoggedIn => _storage.read('phone_login_verified') ?? false;

  bool get _phoneKycCompleted => _storage.read('phone_kyc_completed') ?? false;

  String get _kycSkippedKey {
    final uid = _auth.currentUser?.uid;
    return uid == null ? 'kyc_skipped' : 'kyc_skipped_$uid';
  }

  bool get _hasSkippedKyc => _storage.read(_kycSkippedKey) ?? false;

  UserModel _phoneUserModel() {
    final String phone = _storage.read('phone_login_number') ?? '';
    final String name = _storage.read('phone_login_name') ?? '';
    final String email = _storage.read('phone_login_email') ?? '';
    return UserModel(
      uid: phone,
      email: email,
      name: name.isNotEmpty ? name : 'Phone User',
      phoneNumber: phone,
      createdAt: DateTime.tryParse(
            _storage.read('phone_login_created_at') ?? '',
          ) ??
          DateTime.now(),
      kycCompleted: _phoneKycCompleted,
    );
  }

  void _loadPhoneLoginData() {
    userModel.value = _phoneUserModel();
  }

  Future<bool> _fetchUserData(User user, {bool createIfMissing = false}) async {
    try {
      final response = await ApiClient.dio.get('/users/me');
      userModel.value = UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 && createIfMissing) {
        return _upsertBackendProfile(user);
      }
      if (e.response?.statusCode == 401) {
        await _handleUnauthorizedSession();
        return false;
      }
      debugPrint("Error fetching user data: $e");
      return false;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return false;
    }
  }

  Future<void> refreshCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _fetchUserData(user, createIfMissing: true);
    }
  }

  Future<bool> _upsertBackendProfile(User user) async {
    try {
      final fallbackName = user.displayName ??
          (user.email != null && user.email!.contains('@')
              ? user.email!.split('@').first
              : 'User');
      final response = await ApiClient.dio.post('/users/me', data: {
        'uid': user.uid,
        'email': user.email ?? '',
        'name': fallbackName,
        'phoneNumber': user.phoneNumber,
        'profileImage': user.photoURL,
      });
      userModel.value = UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _handleUnauthorizedSession();
      } else {
        debugPrint('Error creating backend user profile: $e');
      }
      return false;
    } catch (e) {
      debugPrint('Error creating backend user profile: $e');
      return false;
    }
  }

  Future<void> savePhoneLoginSession({
    required String phoneNumber,
    required String name,
    required String email,
    bool kycCompleted = false,
  }) async {
    await _storage.write('phone_login_verified', true);
    await _storage.write('phone_login_number', phoneNumber);
    await _storage.write('phone_login_name', name);
    await _storage.write('phone_login_email', email);
    await _storage.write('phone_login_created_at', DateTime.now().toIso8601String());
    await _storage.write('phone_kyc_completed', kycCompleted);
    await _storage.write('phone_kyc_skipped', false);

    userModel.value = UserModel(
      uid: phoneNumber,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      kycCompleted: kycCompleted,
    );
  }

  Future<void> _clearPhoneLoginSession() async {
    await _storage.remove('phone_login_verified');
    await _storage.remove('phone_login_number');
    await _storage.remove('phone_login_name');
    await _storage.remove('phone_login_email');
    await _storage.remove('phone_login_created_at');
    await _storage.remove('phone_kyc_completed');
    await _storage.remove('phone_kyc_skipped');
  }

  Future<void> _handleUnauthorizedSession() async {
    userModel.value = null;
    await _clearPhoneLoginSession();
    if (Get.currentRoute != '/LoginScreen') {
      Get.offAll(() => const LoginScreen());
    }
    Get.snackbar(
      'Session Expired',
      'Please log in again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      colorText: Colors.orange,
    );
  }

  Future<void> setPhoneKycSkipped(bool skipped) async {
    await _storage.write('phone_kyc_skipped', skipped);
  }

  Future<void> skipKycForNow() async {
    await _storage.write(_kycSkippedKey, true);
    Get.offAll(() => const HomeScreen());
    Get.snackbar(
      'Verification Skipped',
      'You can browse the app, but wallet features require KYC approval.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      colorText: Colors.orange,
    );
  }

  Future<void> saveUserInterests(List<String> interests) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final response = await ApiClient.dio.patch('/users/me/onboarding', data: {
        'interests': interests,
        'onboardingCompleted': true,
      });

      userModel.value = UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final created = await _upsertBackendProfile(user);
        if (!created) return;
        final response = await ApiClient.dio.patch('/users/me/onboarding', data: {
          'interests': interests,
          'onboardingCompleted': true,
        });
        userModel.value = UserModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        return;
      }
      if (e.response?.statusCode == 401) {
        await _handleUnauthorizedSession();
        return;
      }
      rethrow;
    }
  }

  /// Phase 0 safety: users can submit KYC, but only backend/admin review can approve it.
  Future<void> submitKycForReview() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _fetchUserData(user, createIfMissing: true);
  }

  // --- Handle Core Navigation Logic ---
  Future<void> handleNavigation() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    // 1. Email Verification Check
    if (!user.emailVerified) {
      Get.offAll(() => const VerifyEmailScreen());
      return;
    }

    final profile = userModel.value;
    if (profile == null) {
      final loaded = await _fetchUserData(user, createIfMissing: true);
      if (!loaded) {
        await logout();
        return;
      }
    }

    final currentProfile = userModel.value;

    if (currentProfile == null || currentProfile.needsInterestSelection) {
      Get.offAll(() => const CausesScreen());
      return;
    }

    if (currentProfile.kycStatus == 'not_started' && !_hasSkippedKyc) {
      Get.offAll(() => const KycOverviewScreen());
      return;
    }

    if (!currentProfile.isKycApproved && !_hasSkippedKyc) {
      Get.offAll(() => const KycStatusScreen());
      return;
    }

    Get.offAll(() => const HomeScreen());
  }

  // --- Register ---
  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: credential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        kycCompleted: false,
        kycStatus: 'not_started',
        onboardingCompleted: false,
      );

      final response = await ApiClient.dio.post('/users/me', data: user.toMap());
      userModel.value = UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );

      await credential.user!.sendEmailVerification();

      Get.snackbar(
        "Success",
        "Account created! Verification email sent.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      Get.offAll(() => const CausesScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Registration Failed",
        e.message ?? "An error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      rethrow;
    } catch (e) {
      await _auth.signOut();
      userModel.value = null;
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }

  // --- Login ---
  Future<void> login(String email, String password) async {
    try {
      final credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'missing-user',
          message: 'Unable to load the signed in user.',
        );
      }

      final loaded = await _fetchUserData(user, createIfMissing: true);
      if (!loaded) {
        await logout();
        throw FirebaseAuthException(
          code: 'profile-sync-failed',
          message: 'Unable to sync your account profile. Please try again.',
        );
      }

      await handleNavigation();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Invalid credentials",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      rethrow;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }

  // --- KYC ---
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'google-sign-in-failed',
          message: 'Unable to sign in with Google.',
        );
      }

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final UserModel userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Google User',
          createdAt: DateTime.now(),
          kycCompleted: false,
          kycStatus: 'not_started',
          onboardingCompleted: false,
          profileImage: user.photoURL,
        );
        await ApiClient.dio.post('/users/me', data: userModel.toMap());
      } else {
        try {
          await ApiClient.dio.get('/users/me');
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            final UserModel userModel = UserModel(
              uid: user.uid,
              email: user.email ?? '',
              name: user.displayName ?? 'Google User',
              createdAt: DateTime.now(),
              kycCompleted: false,
              kycStatus: 'not_started',
              onboardingCompleted: false,
              profileImage: user.photoURL,
            );
            await ApiClient.dio.post('/users/me', data: userModel.toMap());
          } else {
            rethrow;
          }
        }
      }

      final loaded = await _fetchUserData(user, createIfMissing: true);
      if (!loaded) {
        await logout();
        return;
      }
      await handleNavigation();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Google Sign In Failed',
        e.message ?? 'Unable to sign in with Google.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      rethrow;
    } catch (e) {
      Get.snackbar(
        'Google Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      rethrow;
    }
  }

  Future<void> completeKyc() => submitKycForReview();

  // --- Logout ---
  Future<void> logout() async {
    await _auth.signOut();
    await _clearPhoneLoginSession();
    userModel.value = null;
    Get.offAll(() => const LoginScreen());
  }
}
