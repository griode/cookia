import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/ui/widgets/error_generate.dart';
import 'package:cookia/ui/widgets/loading_generate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

class TextResultGenerate extends StatefulWidget {
  final String text;
  const TextResultGenerate({super.key, required this.text});

  @override
  State<TextResultGenerate> createState() => _TextResultGenerateState();
}

class _TextResultGenerateState extends State<TextResultGenerate> {
  late AppLocalizations lang = AppLocalizations.of(context)!;
  late Future<Map<String, dynamic>?> recipeData;
  List recipes = [];

  @override
  void initState() {
    super.initState();
    recipeData = VertexAI.generateWitchText(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                return const LoadingGenerate();
              }
              if (snapshot.hasData) {
                // update user activity
                UserProvider.updateActivity();
                recipes = snapshot.data!["recipes"];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                  ),
                );
              }
              return ErrorGenerate(onPressed: () {
                setState(() {
                  recipeData = VertexAI.generateWitchText(widget.text);
                });
              });
            },
          ),
        ),
        _backButton(),
      ],
    );
  }

  Widget _backButton() {
    return Positioned(
      right: 8.0,
      top: 8.0,
      child: IconButton(
        onPressed: () {
          context.pop(recipes);
          context.pop(recipes);
        },
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
