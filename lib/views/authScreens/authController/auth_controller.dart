import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_union_bank/model/user_model.dart';
import 'package:united_union_bank/views/authScreens/verifyEmailScreen/verify_email_screen.dart';
import 'package:united_union_bank/views/homeScreen/home_screen.dart';
import 'package:united_union_bank/views/authScreens/loginScreen/login_screen.dart';
import 'package:united_union_bank/views/kycScreens/kyc_overview_screen.dart';
import 'package:united_union_bank/controllers/biometric_controller.dart' hide debugPrint;

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      userModel.value = null;
    } else {
      await _fetchUserData(user.uid);
    }
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

  // --- Handle Core Navigation Logic ---
  void handleNavigation() {
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

    // 2. KYC Completion Check
    if (userModel.value != null && !userModel.value!.kycCompleted) {
      Get.offAll(() => const KycOverviewScreen());
      return;
    }

    // 3. Final Destination
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

      // Always save credentials securely so they are ready if the user enables biometrics later
      BiometricController.instance.saveCredentials(email, password);

      handleNavigation();
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
      
      // Always save credentials securely so they are ready if the user enables biometrics later
      BiometricController.instance.saveCredentials(email, password);

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
  Future<void> completeKyc() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        'kycCompleted': true,
      });
      // Refresh local model
      await _fetchUserData(uid);
    }
  }

  // --- Logout ---
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }
}
