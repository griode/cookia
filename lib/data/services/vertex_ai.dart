import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/services/firebase_notification.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class VertexAI {
// function url
  static const _urlRecipe =
      "https://generate-recipe-by-preferences-fn-kdraj6z2ta-ew.a.run.app";
  static const _urlRecipeImage =
      "https://generate-recipe-by-image-fn-kdraj6z2ta-ew.a.run.app";
  static const _urlCreateMenu =
      "https://program-menu-for-user-fn-kdraj6z2ta-ew.a.run.app";
  static const _urlGenerateByText =
      "https://generate-recipe-by-text-fn-kdraj6z2ta-ew.a.run.app";

// Requets haders
  static const _headers = {
    "Content-Type": "application/json",
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "moran-open": "turnKuiopQVER3T4Klop0DIOn",
  };

// Generate recipe by user preferences
  static Future<List<Recipe>> generateRecipe() async {
    if (currentUserAuth != null) {
      try {
        var response = await http.post(
          Uri.parse(_urlRecipe),
          body: json.encode({
            "existingRecipes": currentUserAuth!.existingRecipes ?? [],
            "language": appLocale.value.toString(),
            "allergies": currentUserAuth!.allergens,
            "diet": currentUserAuth!.diet,
            "cuisine": currentUserAuth!.cuisine,
          }),
          headers: _headers,
        );
        // convert data
        final data = jsonDecode(response.body) as List<dynamic>;
        final recipes = data.map((json) => Recipe.fromJson(json)).toList();
        return recipes;
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    }
    return [];
  }

// Generate witch image
  static Future<Map<String, dynamic>?> generateWitchImages(
      List<File> images) async {
    try {
      // convert images to base64
      final fileImagesBase64 = [];
      for (File file in images) {
        final bytes = await file.readAsBytes();
        final ext = file.path.split(".").last;
        fileImagesBase64.add({
          "base64": base64Encode(bytes),
          "mimeType": "image/$ext",
        });
      }

      // Call function to generate content
      var response = await http.post(
        Uri.parse(_urlRecipeImage),
        body: json.encode({
          "language": appLocale.value.toString(),
          "images": fileImagesBase64,
        }),
        headers: _headers,
      );
      // convert data
      final jsonData = jsonDecode(response.body);
      final recipes =
          jsonData["data"].map((json) => Recipe.fromJson(json)).toList();

      return {
        "message": jsonData["message"],
        "recipes": recipes,
      };
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  static Future<bool> createMenu() async {
    try {
      var response = await http.post(
        Uri.parse(_urlCreateMenu),
        body: json.encode({
          "user_id": currentUserAuth!.id,
          "language": appLocale.value.languageCode,
          "registrationToken": appDeviceToken,
        }),
        headers: _headers,
      );
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Generate witch text
  static Future<Map<String, dynamic>?> generateWitchText(String text) async {
    try {
      // Call function to generate content
      var response = await http.post(
        Uri.parse(_urlGenerateByText),
        body: json.encode({
          "text": text,
          "language": appLocale.value.toString(),
        }),
        headers: _headers,
      );
      // convert data
      final jsonData = jsonDecode(response.body);
      final recipes =
          jsonData["data"].map((json) => Recipe.fromJson(json)).toList();

      return {
        "message": jsonData["message"],
        "recipes": recipes,
      };
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
