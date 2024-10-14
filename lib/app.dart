import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/ui/pages/settings/components/change_theme.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'package:cookia/utils/themes/dark.dart';
import 'package:cookia/utils/themes/light.dart';

class App extends StatefulWidget {
  const App({super.key}); 

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: 'Hello',
      );
    }
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    // block orientation to vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _setupInteractedMessage();
    _initGoogleMobileAds();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appLocale,
      builder: (context, local, child) {
        return ValueListenableBuilder(
          valueListenable: appThemeMode,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              routerConfig: routerConfig,
              locale: local,
              themeMode: themeMode,
              theme: themeLight(),
              darkTheme: themeDark(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              title: 'Scan Gourmet',
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}