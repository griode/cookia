import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  late String? image;
  late String? id;
  late String? createdBy;
  final String? name;
  final List ingredients;
  final List instructions;
  final dynamic duration;
  final dynamic servings;
  final String difficulty;
  final String cuisine;
  final String? description;
  final dynamic nutritionFacts;
  final String? diet;
  late String? language;
  late dynamic index;
  final Timestamp createdAt;
  final String continent;
  final String mealType;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.duration,
    required this.servings,
    required this.difficulty,
    this.image,
    this.id,
    this.diet,
    this.createdBy,
    this.nutritionFacts,
    required this.cuisine,
    this.description,
    this.language,
    this.index,
    required this.createdAt,
    required this.continent,
    required this.mealType,
  });

  factory Recipe.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Recipe(
        id: snapshot.id,
        index: data?['index'],
        createdBy: data?['created_by'],
        image: data?['image'],
        name: data?['recipe_name'],
        ingredients: data?['ingredients'],
        instructions: data?['instructions'],
        duration: data?['duration_to_cook'],
        servings: data?['servings'],
        diet: data?['diet'],
        difficulty: data?['difficulty'],
        nutritionFacts: data?['nutrition_facts'],
        cuisine: data?['cuisine'],
        language: data?['language'],
        description: data?['description'],
        createdAt: data?['created_at'],
        continent: data?['continent'],
        mealType: data?['meal_type']);
  }

  factory Recipe.fromJson(dynamic json) => Recipe(
        image: json['image'],
        name: json['recipe_name'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        duration: json['duration_to_cook'],
        servings: json['servings'],
        difficulty: json['difficulty'],
        nutritionFacts: json['nutrition_facts'],
        cuisine: json['cuisine'],
        description: json['description'],
        language: json['language'],
        diet: json['diet'],
        index: json['index'],
        createdAt: Timestamp.now(),
        continent: json['continent'],
        mealType: json['meal_type'],
      );

  toFireStore() => {
        'created_by': createdBy,
        'image': image,
        'recipe_name': name,
        'ingredients': ingredients,
        'instructions': instructions,
        'duration_to_cook': duration,
        'servings': servings,
        'difficulty': difficulty,
        'nutrition_facts': nutritionFacts,
        'cuisine': cuisine,
        'description': description,
        'diet': diet,
        'language': language,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'index': index,
        'continent': continent,
        'meal_type': mealType
      };
}
