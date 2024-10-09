import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LoadingGenerate extends StatelessWidget {
  const LoadingGenerate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 36.0),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LinearProgressIndicator(
              minHeight: 24,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 100,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FadeAnimatedText(
                  duration: const Duration(seconds: 4),
                  AppLocalizations.of(context)!.analysePleaseWait,
                ),
                FadeAnimatedText(
                  duration: const Duration(seconds: 4),
                  AppLocalizations.of(context)!.yourRecipeBeing,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}