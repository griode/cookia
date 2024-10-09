import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/ui/widgets/error_generate.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

class ScanImage extends StatefulWidget {
  final List<File> images;

  const ScanImage({super.key, required this.images});
  @override
  State<ScanImage> createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage>
    with SingleTickerProviderStateMixin {
  int currentImageIndex = 0;
  late List<File> images;
  late Future<Map<String, dynamic>?> recipeData;

  late AnimationController _animationController;
  late Animation<double> _scanAnimation;
  late AppLocalizations lang = AppLocalizations.of(context)!;
  late List recipes = [];

  @override
  void initState() {
    super.initState();
    recipeData = VertexAI.generateWitchImages(widget.images);
    images = widget.images;
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            currentImageIndex = (currentImageIndex + 1) % images.length;
          });
          _animationController.forward(from: 0.0);
        }
      });
    _scanAnimation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 32,
              left: 12,
              right: 12,
            ),
            child: FutureBuilder(
              future: recipeData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _loadingScan();
                }

                if (snapshot.hasData && snapshot.data != null) {
                  recipes = snapshot.data!["recipes"];
                   // update user activity
                  UserProvider.updateActivity();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48.0),
                      Text(
                        recipes.isEmpty
                            ? lang.contentNotFound
                            : lang.hereAreYou,
                        style: const TextStyle(fontSize: 24.0),
                      ),
                      const SizedBox(height: 8),
                      Text("<< ${snapshot.data!["message"]} >>"),
                      const SizedBox(height: 16.0),
                      ...recipes.map((recipe) {
                        return RecipeCard(recipe: recipe);
                      })
                    ],
                  );
                }
                return ErrorGenerate(onPressed: () {});
              },
            ),
          ),
          _backButton(),
        ],
      ),
    );
  }

  Widget _loadingScan() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12.0),
        Container(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 260,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: Image.file(
                        images[currentImageIndex],
                        key: ValueKey<int>(currentImageIndex),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.width *
                          _scanAnimation.value,
                      child: Container(
                        height: 4.0,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
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

  Widget _backButton() {
    return Positioned(
      right: 8.0,
      top: 8.0,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(recipes),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          side: const BorderSide(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
