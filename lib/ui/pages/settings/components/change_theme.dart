import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import de la localisation

ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!; // Accéder aux traductions
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, currentThemeMode, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(lang.themes, // Utilisation de la chaîne localisée
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: currentThemeMode,
                onChanged: (value) => _changeTheme(value, context),
                title:
                    Text(lang.darkMode), // Utilisation de la chaîne localisée
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: currentThemeMode,
                onChanged: (value) => _changeTheme(value, context),
                title:
                    Text(lang.lightMode), // Utilisation de la chaîne localisée
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: currentThemeMode,
                onChanged: (value) => _changeTheme(value, context),
                title:
                    Text(lang.systemMode), // Utilisation de la chaîne localisée
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeTheme(ThemeMode? themeMode, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('theme', themeMode!.name);
    appThemeMode.value = themeMode;
    context.pop();
  }
}
