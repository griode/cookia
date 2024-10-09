import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/ui/widgets/error_generate.dart';
import 'package:cookia/ui/widgets/loading_generate.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

class GenerateRecipe extends StatefulWidget {
  const GenerateRecipe({super.key});

  @override
  State<GenerateRecipe> createState() => _GenerateRecipeState();
}

class _GenerateRecipeState extends State<GenerateRecipe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<List<Recipe>> _recipeFuture;
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _recipeFuture = _generateAndSaveRecipes();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Recipe>> _generateAndSaveRecipes() async {
    List<Recipe> recipes = await VertexAI.generateRecipe();
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: FutureBuilder(
                future: _recipeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingGenerate();
                  }

                  if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return ErrorGenerate(onPressed: () {
                      setState(() {
                        _recipeFuture = _generateAndSaveRecipes();
                      });
                    });
                  }
                  // update user activity
                  UserProvider.updateActivity();
                  recipes = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48.0),
                      Text(
                        AppLocalizations.of(context)!.hereAreYou,
                        style: const TextStyle(fontSize: 24.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(AppLocalizations.of(context)!.hopeYou),
                      const SizedBox(height: 12.0),
                      ...recipes.map((recipe) {
                        return RecipeCard(recipe: recipe);
                      })
                    ],
                  );
                },
              ),
            ),
          ),
          _backButton(),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Positioned(
      right: 8.0,
      top: 8.0,
      child: IconButton(
        onPressed: () => context.pop(recipes),
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
