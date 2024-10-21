import 'package:cookia/init_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cookia/app.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/firebase_notification.dart';
import 'package:cookia/firebase_options.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'data/services/local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase service
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize user``
  if (FirebaseAuth.instance.currentUser != null) {
    currentUserAuth = await UserProvider.get();
  } else {
    currentUserAuth = null;
  }

  // initialization app check
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  // Initialize local notification
  await FirebaseNotification.init();
  await LocalNotifications.init();

  // init app language and theme
  await initApp();

  runApp(const App());
}