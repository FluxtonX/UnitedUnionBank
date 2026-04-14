import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:united_union_bank/views/kycScreens/kyc_overview_screen.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  Timer? _timer;
  final RxInt secondsRemaining = 60.obs;
  Timer? _verificationTimer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
    startResendTimer();
  }

  /// Send/Resend Verification Email
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Logic for counting down the resend button
  void startResendTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  /// Periodically check if email is verified
  void setTimerForAutoRedirect() {
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.offAll(() => const KycOverviewScreen());
      }
    });
  }

  /// Manually check verification status
  Future<void> checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        Get.offAll(() => const KycOverviewScreen());
      } else {
        Get.snackbar("Info", "Email not verified yet. Please check your inbox.");
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _verificationTimer?.cancel();
    super.onClose();
  }
}
