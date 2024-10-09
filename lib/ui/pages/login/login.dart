import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/authentication/google_auth.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/pages/settings/terms_privacy_page.dart';
import 'package:cookia/ui/widgets/loading.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/head_image.png"),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Scan Gourmet",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    AppLocalizations.of(context)!.welcomeMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _login,
                      icon: Image.asset(
                        "assets/icons/google.png",
                        width: 24.0,
                        height: 24.0,
                      ),
                      label: Text(
                          AppLocalizations.of(context)!.continueWithGoogle),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: GestureDetector(
                      child: Text(
                        AppLocalizations.of(context)!.conditionAndTerms,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const TermsPrivacyPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    Loading.show(context);
    signInWithGoogle().then(
      (userCredential) {
        if (userCredential.user != null) {
          UserProvider.get().then(
            (user) {
              context.pop();
              if (user != null) {
                context.goNamed(AppRouteName.home.name);
              } else {
                context.goNamed(AppRouteName.register.name);
              }
            },
          ).onError(
            (error, stackTrace) {
              context.pop();
              _showErrorSnackBar(AppLocalizations.of(context)!.loginFailed);
            },
          );
        }
      },
    ).onError((error, stackTrace) {
      context.pop();
      debugPrint(error.toString());
      _showErrorSnackBar(AppLocalizations.of(context)!.anErrorOccurred);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
