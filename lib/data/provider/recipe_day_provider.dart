import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookia/data/model/recipe_day.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';

class RecipeDayProvider {
  static final _dayRecipeCollection =
      FirebaseFirestore.instance.collection("recipe_day").withConverter(
            fromFirestore: RecipeDay.fromFireStore,
            toFirestore: (value, options) => value.toFireStore(),
          );

  static Stream<DocumentSnapshot<RecipeDay>> getRecipesDay() {
    try {
      return _dayRecipeCollection.doc(appLocale.value.toString()).snapshots();
    } catch (error) {
      rethrow;
    }
  }
}
