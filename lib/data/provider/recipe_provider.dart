import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/utils/router/router_config.dart';

class RecipeProvider {
  static final recipesCollection =
      FirebaseFirestore.instance.collection("recipes").withConverter(
            fromFirestore: Recipe.fromFireStore,
            toFirestore: (value, options) => value.toFireStore(),
          );

  static Future<Recipe?> getById(String recipeId) async {
    try {
      var response = await recipesCollection.doc(recipeId).get();
      return response.data();
    } catch (error) {
      return null;
    }
  }

  static Stream<QuerySnapshot<Recipe>>? limite({int limit = 4}) {
    try {
      var response = recipesCollection
          .limit(limit)
          .where("created_by", isEqualTo: currentUserAuth!.id)
          .snapshots();
      return response;
    } catch (_) {
      return null;
    }
  }

  static Future<QueryDocumentSnapshot<Recipe>?> limiteFuture(
      String country) async {
    try {
      var response = await recipesCollection
          .limit(1)
          .where("created_by", isEqualTo: currentUserAuth!.id)
          .where("continent", isEqualTo: country)
          .get();

      return response.docs.first;
    } catch (_) {
      return null;
    }
  }

  static Stream<QuerySnapshot<Recipe>>? getSnapshotAll() {
    return recipesCollection
        .where("create_by", isEqualTo: currentUserAuth!.id)
        .snapshots();
  }

  // add new recipe to your favorite
  Future<bool> add(Recipe recipe) async {
    try {
      recipe.language = appLocale.value.toString();
      await recipesCollection.add(recipe);
      // add recipe name to user existing recipes
      if (currentUserAuth!.existingRecipes != null) {
        currentUserAuth?.existingRecipes?.add(recipe.name);
      } else {
        currentUserAuth?.existingRecipes = [recipe.name];
      }
      UserProvider.update({
        "existingRecipes": currentUserAuth?.existingRecipes,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<QueryDocumentSnapshot<Recipe>>> findAll(
      {required DocumentSnapshot<Object?> startAt, int limit = 10}) async {
    try {
      var response2 = await recipesCollection
          .orderBy("created_at")
          .startAfterDocument(startAt)
          .limit(limit)
          .get();
      return response2.docs;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<Recipe>> searchByNameOrIngredients(String query) async {
    try {
      // Build a query for searching by name or ingredients
      var querySnapshot = (await recipesCollection
              .where("created_by", isEqualTo: currentUserAuth!.id)
              .get())
          .docs
          .map((doc) => doc.data());

      // Convert the QuerySnapshot to a List of Recipes
      return querySnapshot
          .where((recipe) =>
              recipe.name!.toLowerCase().contains(query.toLowerCase()) ||
              recipe.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // Meal manager methode
  static Future<List<QueryDocumentSnapshot<Recipe>>> getRecipeWitchMeal(
      DocumentSnapshot<Object?> lastReicpe, String mealType, int limit) async {
    try {
      String language = currentUserAuth!.language ?? "";
      var response = await recipesCollection
          .orderBy("created_at")
          .where('language', isEqualTo: language)
          .where('meal_type', isEqualTo: mealType)
          .startAfterDocument(lastReicpe)
          .limit(limit)
          .get();
      return response.docs;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Recipe>>> getByMeal(
      String mealType, int limit) async {
    try {
      String language = currentUserAuth!.language ?? "";
      var response = await recipesCollection
          .orderBy("created_at")
          .where('language', isEqualTo: language)
          .where('meal_type', isEqualTo: mealType)
          .limit(limit)
          .get();
      return response.docs;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  // Get recipe for continent
  static Future<List<QueryDocumentSnapshot<Recipe>>> getRecipeWitchContinent(
      DocumentSnapshot<Object?> lastReicpe,
      String continentName,
      int limit) async {
    try {
      String language = currentUserAuth!.language ?? "";
      var response = await recipesCollection
          .orderBy("created_at")
          .where('language', isEqualTo: language)
          .where('continent', isEqualTo: continentName)
          .startAfterDocument(lastReicpe)
          .limit(limit)
          .get();
      return response.docs;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Recipe>>> getByContinent(
      String continentName, int limit) async {
    try {
      String language = currentUserAuth!.language ?? "";
      var response = await recipesCollection
          .orderBy("created_at")
          .where('language', isEqualTo: language)
          .where('continent', isEqualTo: continentName)
          .limit(limit)
          .get();
      return response.docs;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  static void delete() {
    recipesCollection.where('image', isEqualTo: '');
  }
}
