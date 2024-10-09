import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('en'));

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    final listLocal = ["en", "fr", "es", "zh"];

    // Add more languages as needed

    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, currentLocale, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(appLocalizations!.language,
                    style: Theme.of(context).textTheme.titleLarge),
              ),

              ...listLocal.map(
                (e) => RadioListTile<Locale>(
                  value: Locale(e),
                  groupValue: currentLocale,
                  onChanged: (value) => _changeLanguage(value, context),
                  title: Text(appLocalizations.languages(e)),
                ),
              ),
              // Add more languages as needed
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeLanguage(Locale? locale, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('language', locale!.languageCode);
    appLocale.value = locale;
    await UserProvider.update({"language": locale.languageCode});
    context.pop();
  }
}
