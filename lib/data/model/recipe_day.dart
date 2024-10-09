import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDay {
  final Timestamp? createdAt;
  final String? recipeId;
  final String? language;

  RecipeDay(
      {required this.createdAt,
      required this.language,
      required this.recipeId});

  factory RecipeDay.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RecipeDay(
      createdAt: data!["created_at"],
      language: data["language"],
      recipeId: data["recipe_id"],
    );
  }

  toFireStore() => {
        "created_at": createdAt,
        "language": language,
        "recipe_id": recipeId,
      };
}
