import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

class MealView extends StatefulWidget {
  final String mealType;
  const MealView({super.key, required this.mealType});

  @override
  State<MealView> createState() => _MealViewState();
}

class _MealViewState extends State<MealView> {
  QueryDocumentSnapshot<Recipe>? _lastRecipe;
  late Future<List<QueryDocumentSnapshot<Recipe>>> _listRecipes;
  late AppLocalizations lang = AppLocalizations.of(context)!;
  List<QueryDocumentSnapshot<Recipe>> _hitoryListRecipes = [];
  final bool _isLoading = false; // Indicateur de chargement

  void _loadRecipes() {
    if (_lastRecipe != null) {
      _listRecipes =
          RecipeProvider.getRecipeWitchMeal(_lastRecipe!, widget.mealType, 2);
      return;
    } else {
      _listRecipes = RecipeProvider.getByMeal(widget.mealType, 2);
    }
  }

  @override
  void initState() {
    super.initState();
    // init recipes list
    _loadRecipes();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang.mealtype(widget.mealType)),
      ),
      body: FutureBuilder(
        future: _listRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox();
          }
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.isNotEmpty) {
              _lastRecipe = snapshot.data!.last;
              _hitoryListRecipes.addAll(snapshot.data ?? []);
              _hitoryListRecipes = _hitoryListRecipes.toSet().toList();
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ..._hitoryListRecipes
                        .map((e) => RecipeCard(recipe: e.data()))
                        ,
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      TextButton(
                        onPressed: () {
                          _loadRecipes();
                          setState(() {});
                        },
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
          return const SizedBox();
        },
      ),
    );
  }
}
