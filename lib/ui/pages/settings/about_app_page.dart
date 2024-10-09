import 'package:flutter/material.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang!.about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage(
                    "assets/icons/ios.png",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.appDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                lang.mainFeaturesTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.feature1,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                lang.feature2,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                lang.feature3,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                lang.feature4,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                lang.feature5,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                lang.feature6,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
