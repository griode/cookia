import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookia/ui/pages/abonement/subscription_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/ui/pages/settings/components/change_theme.dart';
import 'package:cookia/utils/router/app_route_name.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var userAuth = FirebaseAuth.instance.currentUser;
  UserAuth? user;
  AppLocalizations? _appLocalizations;

  @override
  void initState() {
    user = currentUserAuth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userAuth = FirebaseAuth.instance.currentUser;
    _appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalizations!.settings),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: GestureDetector(
                onTap: () => context
                    .pushNamed(AppRouteName.profile.name)
                    .then((value) => setState(() {})),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          CachedNetworkImageProvider(userAuth!.photoURL ?? ""),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userAuth!.displayName ?? "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            user!.info ?? "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 12),
            ListTile(
              onTap: () => context
                  .pushNamed(AppRouteName.alergie.name, extra: user)
                  .then(
                    (value) => setState(() {
                      user = currentUserAuth;
                    }),
                  ),
              leading: const Icon(HugeIcons.strokeRoundedDates),
              title: Text(_appLocalizations!.recipePreferences),
              subtitle: Text(
                "${user!.diet}, ${user!.allergens.join(', ')}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              onTap: () => _changeLanguage(context),
              leading: const Icon(HugeIcons.strokeRoundedLanguageCircle),
              title: Text(_appLocalizations!.language),
              subtitle: ValueListenableBuilder(
                valueListenable: appLocale,
                builder: (context, value, child) {
                  return Text(_appLocalizations!.languages(value.toString()));
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: appThemeMode,
              builder: (context, value, child) {
                return ListTile(
                    onTap: () => _changeTheme(context),
                    leading: Theme.of(context).brightness.name == 'light'
                        ? const Icon(HugeIcons.strokeRoundedSun01)
                        : const Icon(HugeIcons.strokeRoundedMoon02),
                    title: Text(_appLocalizations!.themes),
                    subtitle: Text(_appLocalizations!.themeName(value.name)));
              },
            ),
            ListTile(
              onTap: () async {
                Share.share("https://scangourmet.onrender.com");
              },
              leading: const Icon(HugeIcons.strokeRoundedShare01),
              title: Text(_appLocalizations!.sharedFriends),
            ),
            ListTile(
              onTap: () => context.pushNamed(AppRouteName.contact.name),
              leading: const Icon(HugeIcons.strokeRoundedHelpCircle),
              title: Text(_appLocalizations!.help),
              subtitle: Text(_appLocalizations!.questionNotices),
            ),
            ListTile(
              onTap: () =>
                  context.pushNamed(AppRouteName.privacyConditions.name),
              leading: const Icon(HugeIcons.strokeRoundedKey01),
              title: Text(_appLocalizations!.conditionAndPrivacy),
            ),
            ListTile(
              onTap: () => context.pushNamed(AppRouteName.about.name),
              leading: const Icon(HugeIcons.strokeRoundedFile01),
              title: Text(_appLocalizations!.about),
            ),
            ListTile(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => const SubscriptionPage(),
              ),
              leading: const Icon(HugeIcons.strokeRoundedFile01),
              title: Text("Subscription"),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ChangeTheme(),
    );
  }

  void _changeLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ChangeLanguage(),
    );
  }
}
