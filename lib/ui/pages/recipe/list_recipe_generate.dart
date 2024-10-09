import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListRecipeGenerate extends StatefulWidget {
  final QueryDocumentSnapshot<Recipe> recipe;
  const ListRecipeGenerate({super.key, required this.recipe});

  @override
  State<ListRecipeGenerate> createState() => _ListRecipeGenerateState();
}

class _ListRecipeGenerateState extends State<ListRecipeGenerate> {
  late QueryDocumentSnapshot<Recipe> _lastRecipe;
  late AppLocalizations lang;
  final List<QueryDocumentSnapshot<Recipe>> _recipes = [];
  bool _isLoading = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _lastRecipe = widget.recipe;
    _loadRecipes(); // Chargement initial des recettes
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    final snapshot =
        await RecipeProvider.findAll(startAt: _lastRecipe, limit: 6);
    if (snapshot.isNotEmpty) {
      setState(() {
        _recipes.addAll(snapshot);
        // Élimination des doublons
        _lastRecipe = snapshot.last;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.recipeGenerateTitle),
        leading: backButton(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            ..._recipes.map((e) => RecipeCard(recipe: e.data())),
            const SizedBox(height: 8),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: _loadRecipes,
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Text(
                  lang.showMoreButtonLabel,
                ), // Utilisation du texte localisé
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
