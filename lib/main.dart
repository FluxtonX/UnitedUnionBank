import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:united_union_bank/firebase_options.dart';
import 'package:united_union_bank/views/splashScreen/splash_screen.dart';

import 'config/app_utils.dart';
import 'config/stripe_constants.dart';

import 'package:united_union_bank/views/authScreens/authController/auth_controller.dart';
import 'package:united_union_bank/controllers/biometric_controller.dart'
    hide debugPrint;
import 'package:united_union_bank/controllers/wallet_controller.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Stripe.publishableKey = StripeConstants.publishableKey;

    Get.put(BiometricController());
    Get.put(AuthController());
    Get.put(WalletController());
  } catch (e) {
    debugPrint('Initialization Error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'United Union Bank',
      theme: AppTheme.theme,
      home: const SplashScreen(),
      builder: (context, child) {
        CustomScreenUtil.init(context);
        return child!;
      },
    );
  }
}
