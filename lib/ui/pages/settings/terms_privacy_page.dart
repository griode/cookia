import 'package:flutter/material.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang!.conditionAndPrivacy),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.conditionsTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.conditionsContent,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Text(
                lang.privacyPolicyTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.privacyPolicyContent,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
