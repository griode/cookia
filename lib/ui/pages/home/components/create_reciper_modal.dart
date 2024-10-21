import 'dart:io';
import 'dart:ui';

import 'package:cookia/ad_helper.dart';
import 'package:cookia/data/function/upload_file.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/pages/abonement/subscription_page.dart';
import 'package:cookia/ui/pages/home/components/create_recipe_witch_text.dart';
import 'package:cookia/ui/pages/home/components/generate_recipe.dart';
import 'package:cookia/ui/pages/home/components/scan_image.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final _recipeProvider = RecipeProvider();
  final _imagePicker = ImagePicker();
  RewardedAd? _rewardedAd;
  late final AppLocalizations _lang = AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd(); // Load a new ad
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildListTile(
                icon: HugeIcons.strokeRoundedSearchVisual,
                title: _lang.scanProduct,
                onTap: () => _createByImage(context),
              ),
              _buildListTile(
                icon: HugeIcons.strokeRoundedBbqGrill,
                title: _lang.discoverSuggested,
                onTap: () => _generateRecipe(context),
              ),
              _buildListTile(
                icon: HugeIcons.strokeRoundedText,
                title: _lang.generateWitchDescription,
                onTap: _generateWitchDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(HugeIcons.strokeRoundedChef, size: 54.0),
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              _lang.howCanIAssist,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: HugeIcon(
              icon: icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
        ),
        const Divider(height: 0),
      ],
    );
  }

  Future<void> _createByImage(BuildContext context) async {
    if (await _checkUserActivity()) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildImagePickerOption(
                  icon: HugeIcons.strokeRoundedCamera01,
                  label: _lang.camera,
                  source: ImageSource.camera,
                ),
                const SizedBox(width: 20.0),
                _buildImagePickerOption(
                  icon: HugeIcons.strokeRoundedImage01,
                  label: _lang.gallery,
                  source: ImageSource.gallery,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () async {
        XFile? xFile = await _imagePicker.pickImage(source: source);
        if (xFile == null) return;
        final image = File(xFile.path);
        await _showScanResult([image]);
      },
      child: Column(
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(height: 4.0),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _generateRecipe(BuildContext context) async {
    if (await _checkUserActivity()) {
      final recipes = await showModalBottomSheet<List<Recipe>>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const GenerateRecipe(),
      );

      if (recipes != null) {
        for (var recipe in recipes) {
          await _saveRecipe(recipe);
        }
      }
    }
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    recipe.image = await uploadImageFromUrl(recipe.image!, "recipes", "png");
    recipe.createdBy = FirebaseAuth.instance.currentUser!.uid;
    await _recipeProvider.add(recipe);
  }

  Future<void> _showScanResult(List<File> images) async {
    final scannedRecipes = await showModalBottomSheet<List<Recipe>>(
      context: context,
      useSafeArea: true,
      builder: (context) => ScanImage(images: images),
    );

    if (scannedRecipes != null) {
      for (var recipe in scannedRecipes) {
        await _saveRecipe(recipe);
      }
    }
  }

  Future<void> _generateWitchDescription() async {
    if (await _checkUserActivity()) {
      showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(color: Colors.black.withOpacity(0.0)),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CreateRecipeWitchText(),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<bool> _checkUserActivity() async {
    int response = await UserProvider.checkActivity();

    // Cas des utilisateurs non premium
    if (!currentUserAuth!.isPremium) {
      if (response > 0) return true; // Activité restante disponible

      if (response >= -3) {
        // Montrer les publicités si l'utilisateur a encore une marge
        _rewardedAd?.show(onUserEarnedReward: (_, reward) {
          debugPrint(reward.amount.toString());
        });
        return true;
      }

      // Si le seuil est atteint, on affiche un message et propose de s'abonner
      showSubscriptionDialog(context);
      _showLimitReachedSnackbar(
          "You reached the limit to generate recipes today. Try again in 24 hours or upgrade to the premium plan.");
      return false;
    }

    // Cas des utilisateurs premium
    if (response < -12) {
      _showLimitReachedSnackbar(
          "You reached the limit to generate recipes today. Try again in 24 hours.");
      return false;
    }

    return true; // Utilisateurs premium ont une activité illimitée
  }

  void _showLimitReachedSnackbar(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text(_lang.okBtn),
              onPressed: () => context.pop(),
            )
          ],
        );
      },
    );
  }
}
