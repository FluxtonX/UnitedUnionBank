import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricController extends GetxController {
  static BiometricController get instance => Get.find();

  final LocalAuthentication auth = LocalAuthentication();
  final GetStorage storage = GetStorage();

  var canCheckBiometrics = false.obs;
  var isBiometricEnabled = false.obs;
  var isAuthenticating = false.obs;
  var availableBiometrics = <BiometricType>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkHardwareSupport();
    _loadSettings();
  }

  // --- Credential Storage ---

  void saveCredentials(String email, String password) {
    debugPrint('Raw password storage is disabled for fintech security.');
  }

  Map<String, String>? getSavedCredentials() {
    debugPrint('Biometric password replay is disabled.');
    return null;
  }

  void clearCredentials() {
    try {
      storage.remove('saved_email');
      storage.remove('saved_password');
      debugPrint('Credentials cleared');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }
  }

  Future<void> _checkHardwareSupport() async {
    try {
      canCheckBiometrics.value =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (canCheckBiometrics.value) {
        availableBiometrics.value = await auth.getAvailableBiometrics();
        debugPrint('Available biometrics: $availableBiometrics');
      }
    } on PlatformException catch (e) {
      canCheckBiometrics.value = false;
      debugPrint('Hardware support error: $e');
    }
  }

  void _loadSettings() {
    isBiometricEnabled.value = storage.read('biometric_enabled') ?? false;
    debugPrint('Biometric enabled: ${isBiometricEnabled.value}');
  }

  Future<bool> authenticate() async {
    isAuthenticating.value = true;
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to access your United Union Bank account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Login',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );
      debugPrint('Authentication result: $didAuthenticate');
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    } finally {
      isAuthenticating.value = false;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      // If enabling, we must authenticate first to confirm
      bool success = await authenticate();
      if (success) {
        isBiometricEnabled.value = true;
        storage.write('biometric_enabled', true);
        debugPrint('Biometric enabled successfully');
      } else {
        debugPrint('Biometric authentication failed during toggle');
      }
    } else {
      isBiometricEnabled.value = false;
      storage.write('biometric_enabled', false);
      clearCredentials();
      debugPrint('Biometric disabled');
    }
  }
}

void debugPrint(String message) {
  print('[BiometricController] $message');
}
