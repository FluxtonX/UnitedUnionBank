import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:united_union_bank/model/user_model.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  late Rx<User?> _firebaseUser;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onReady() {
    super.onReady();
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
      await _fetchUserData(user.uid);
    }
  }

  bool get _isPhoneLoggedIn => _storage.read('phone_login_verified') ?? false;

  bool get _phoneKycCompleted => _storage.read('phone_kyc_completed') ?? false;

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

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        userModel.value = UserModel.fromSnapshot(doc);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> refreshCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _fetchUserData(uid);
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

  Future<void> setPhoneKycSkipped(bool skipped) async {
    await _storage.write('phone_kyc_skipped', skipped);
  }

  Future<void> saveUserInterests(List<String> interests) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'interests': interests,
      'onboardingCompleted': true,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    await _fetchUserData(user.uid);
  }

  /// Phase 0 safety: users can submit KYC, but only backend/admin review can approve it.
  Future<void> submitKycForReview() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'kycStatus': 'submitted',
      'kycCompleted': false,
      'kycSubmittedAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    await _fetchUserData(uid);
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
      await _fetchUserData(user.uid);
    }

    final currentProfile = userModel.value;

    if (currentProfile == null || currentProfile.needsInterestSelection) {
      Get.offAll(() => const CausesScreen());
      return;
    }

    if (currentProfile.kycStatus == 'not_started') {
      Get.offAll(() => const KycOverviewScreen());
      return;
    }

    if (!currentProfile.isKycApproved) {
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

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toMap());

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
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }

  // --- Login ---
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      handleNavigation();
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
        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      }

      await _fetchUserData(user.uid);
      handleNavigation();
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
    Get.offAll(() => const LoginScreen());
  }
}
