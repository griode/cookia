import 'package:flutter/material.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/ui/pages/settings/components/change_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Constants for preference keys
const String _languageKey = 'language';
const String _themeKey = 'theme';

Future<void> initApp() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  // Initialize app settings (language and theme) in parallel
  await Future.wait([
    _initializeLanguage(pref),
    _initializeTheme(pref),
  ]);
}

Future<void> _initializeLanguage(SharedPreferences pref) async {
  // Retrieve stored language, or use system locale if not set
  final String? storedLanguage = pref.getString(_languageKey);
  if (storedLanguage == null) {
    final Locale systemLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    appLocale.value = systemLocale;
    await pref.setString(_languageKey, systemLocale.languageCode);
  } else {
    appLocale.value = Locale(storedLanguage);
  }
}

Future<void> _initializeTheme(SharedPreferences pref) async {
  // Retrieve stored theme, or fallback to system theme
  final String themeName = pref.getString(_themeKey) ?? "system";
  final ThemeMode selectedTheme = _getThemeModeFromName(themeName);

  if (appThemeMode.value != selectedTheme) {
    appThemeMode.value = selectedTheme;
    if (themeName == "system") {
      await pref.setString(_themeKey, "system");
    }
  }
}

ThemeMode _getThemeModeFromName(String themeName) {
  switch (themeName) {
    case "light":
      return ThemeMode.light;
    case "dark":
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}