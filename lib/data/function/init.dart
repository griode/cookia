import 'package:flutter/material.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/ui/pages/settings/components/change_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initAppLanguage() async {
  final pref = await SharedPreferences.getInstance();
  String? language = pref.getString('language');
  if (language == null) {
    appLocale.value = WidgetsBinding.instance.platformDispatcher.locale;
    pref.setString('language', appLocale.value.languageCode);
  } else {
    appLocale.value = Locale(language);
  }
}

Future<void> initTheme() async {
  final pref = await SharedPreferences.getInstance();
  final themeName = pref.getString("theme");
  if (themeName == null) {
    appThemeMode.value = ThemeMode.system;
  } else {
    pref.setString("theme", themeName);
    switch (themeName) {
      case "light":
        appThemeMode.value = ThemeMode.light;
        break;
      case "dark":
        appThemeMode.value = ThemeMode.dark;
        break;
      default:
        appThemeMode.value = ThemeMode.system;
        break;
    }
  }
}
