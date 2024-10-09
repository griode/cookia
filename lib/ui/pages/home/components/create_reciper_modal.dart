import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cookia/ad_helper.dart';
import 'package:cookia/data/function/upload_file.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/pages/home/components/create_recipe_witch_text.dart';
import 'package:cookia/ui/pages/home/components/generate_recipe.dart';
import 'package:cookia/ui/pages/home/components/scan_image.dart';

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

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      HugeIcons.strokeRoundedChef,
                      size: 54.0,
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Text(
                        _lang.howCanIAssist,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  await checkUserActivity();
                  createByImage(context);
                },
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearchVisual,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppLocalizations.of(context)!.scanProduct),
              ),
              const Divider(height: 0),
              ListTile(
                onTap: () => generate(context),
                leading: Icon(
                  HugeIcons.strokeRoundedBbqGrill,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(_lang.discoverSuggested),
              ),
              const Divider(height: 0),
              ListTile(
                onTap: () => _generateWitchDescription(),
                leading: Icon(
                  HugeIcons.strokeRoundedText,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(_lang.generateWitchDescription),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createByImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? xFile =
                      await _imagePicker.pickImage(source: ImageSource.camera);
                  if (xFile == null) return;
                  final image = File(xFile.path);
                  showScanResult([image]);
                },
                child: Column(
                  children: [
                    const CircleAvatar(
                      child: Icon(HugeIcons.strokeRoundedCamera01),
                    ),
                    const SizedBox(height: 4.0),
                    Text(AppLocalizations.of(context)!.camera),
                  ],
                ),
              ),
              const SizedBox(width: 20.0),
              GestureDetector(
                onTap: () async {
                  XFile? xFile =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (xFile == null) return;
                  final image = File(xFile.path);
                  showScanResult([image]);
                },
                child: Column(
                  children: [
                    const CircleAvatar(
                      child: Icon(HugeIcons.strokeRoundedImage01),
                    ),
                    const SizedBox(height: 4.0),
                    Text(AppLocalizations.of(context)!.gallery),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void generate(BuildContext context) {
    checkUserActivity();
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) => const GenerateRecipe(),
    ).then((value) {
      context.pop();
      if (value != null) {
        var recipe = value as List<Recipe>;
        for (var element in recipe) {
          _saveRecipe(element);
        }
      }
    });
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    recipe.image = await uploadImageFromUrl(recipe.image!, "recipes", "png");
    recipe.createdBy = FirebaseAuth.instance.currentUser!.uid;
    await _recipeProvider.add(recipe);
  }

  Future<void> showScanResult(List<File> images) async {
    await checkUserActivity();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return ScanImage(images: images);
      },
    ).then((value) {
      if (value != null) {
        for (var element in value) {
          _saveRecipe(element);
        }
      }
      context.pop();
    });
  }

  void _generateWitchDescription() {
    checkUserActivity();
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.0),
                ),
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

  Future<void> checkUserActivity() async {
    int response = await UserProvider.checkActivity();
    if (response <= 0) {
      _rewardedAd?.show(
        onUserEarnedReward: (_, reward) {
          debugPrint(reward.amount.toString());
        },
      );
    }
  }
}
