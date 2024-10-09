import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth {
  final String? id;
  late String fullName;
  late String? email;
  late Timestamp birth;
  late List allergens;
  late String diet;
  late String? info;
  final String? language;
  final String? cuisine;
  late List? existingRecipes;
  late dynamic weight;
  late dynamic size;
  late String? gender;
  late String? registrationToken;
  late int numberAuthorizedRequest;
  late bool isPremium;
  late Timestamp? lastRequest;
  late int numberRequest;

  UserAuth({
    this.id,
    this.registrationToken,
    required this.fullName,
    required this.email,
    required this.birth,
    required this.allergens,
    required this.diet,
    this.info,
    this.language,
    this.cuisine,
    this.existingRecipes,
    this.weight,
    this.size,
    this.gender,
    required this.numberAuthorizedRequest,
    required this.isPremium,
    this.lastRequest,
    required this.numberRequest,
  });

  toFirestore() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'birth': birth,
        'allergens': allergens,
        'diet': diet,
        'info': info,
        'language': language,
        'cuisine': cuisine,
        'existingRecipes': existingRecipes,
        'weight': weight,
        'size': size,
        'gender': gender,
        'registrationToken': registrationToken,
        'numberAuthorizedRequest': numberAuthorizedRequest,
        'isPremium': isPremium,
        'lastRequest': lastRequest,
        'numberRequest': numberRequest
      };

  factory UserAuth.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserAuth(
      id: snapshot.id,
      fullName: data!['fullName'],
      email: data['email'],
      birth: data['birth'],
      allergens: data['allergens'],
      diet: data['diet'],
      info: data['info'],
      language: data['language'],
      cuisine: data['cuisine'],
      existingRecipes: data['existingRecipes'],
      weight: data['weight'],
      size: data['size'],
      gender: data['gender'],
      registrationToken: data['registrationToken'],
      numberAuthorizedRequest: data['numberAuthorizedRequest'],
      isPremium: data['isPremium'],
      lastRequest: data['lastRequest'],
      numberRequest: data['numberRequest'],
    );
  }
}
