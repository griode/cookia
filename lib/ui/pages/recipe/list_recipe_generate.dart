import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookia/ui/widgets/larg_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListRecipeGenerate extends StatefulWidget {
  const ListRecipeGenerate({super.key});

  @override
  State<ListRecipeGenerate> createState() => ListRecipeGenerateState();
}

class ListRecipeGenerateState extends State<ListRecipeGenerate> {
  QueryDocumentSnapshot<Recipe>? _lastRecipe;
  late Future<List<QueryDocumentSnapshot<Recipe>>> _listRecipes;
  late AppLocalizations lang = AppLocalizations.of(context)!;
  List<QueryDocumentSnapshot<Recipe>> _historyListRecipes = [];
  final bool _isLoading = false; // Indicateur de chargement

  void _loadRecipes() {
    if (_lastRecipe != null) {
      _listRecipes = RecipeProvider.findAllWitchLast(
        lastRecipe: _lastRecipe!,
        limit: 10,
      );
      return;
    } else {
      _listRecipes = RecipeProvider.findAll(10);
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
        title: Text(lang.recipeGenerateTitle),
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
              _historyListRecipes.addAll(snapshot.data ?? []);
              _historyListRecipes = _historyListRecipes.toSet().toList();
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ..._historyListRecipes
                        .map((e) => LargeRecipeCard(recipe: e.data())),
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
