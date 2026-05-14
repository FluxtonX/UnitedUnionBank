import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide debugPrint;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:united_union_bank/firebase_options.dart';
import 'package:united_union_bank/views/splashScreen/splash_screen.dart';
import 'config/app_utils.dart';
import 'config/stripe_constants.dart';
import 'services/app_check_service.dart';
import 'package:united_union_bank/views/authScreens/authController/auth_controller.dart';
import 'package:united_union_bank/controllers/biometric_controller.dart' hide debugPrint;
import 'package:united_union_bank/controllers/wallet_controller.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AppCheckService.activate();

    try {
      // Initialize Stripe
      Stripe.publishableKey = StripeConstants.publishableKey;
    } catch (e) {
      debugPrint('Stripe Initialization Error (App might need a rebuild for native dependencies): $e');
    }

    // Initialize BiometricController first
    Get.put(BiometricController());
    // Initialize AuthController
    Get.put(AuthController());
    // Initialize WalletController
    Get.put(WalletController());
  } catch (e) {
    debugPrint('Firebase/Stripe Initialization Error: $e');
  }
  await GetStorage.init();
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'United Union Bank',
      theme: AppTheme.theme,
      home: const SplashScreen(),
      builder: (context, child) {
        CustomScreenUtil.init(context);
        return DevicePreview.appBuilder(context, child);
      },
    );
  }
}
