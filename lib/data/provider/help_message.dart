import 'package:cloud_firestore/cloud_firestore.dart';

class HelpMessage {
  final String email;
  final String name;
  final String message;
  final _collection = FirebaseFirestore.instance.collection("help");

  HelpMessage({required this.email, required this.message, required this.name});

  Future<bool> sendMessage() async {
    try {
      await _collection.add({
        "email": email,
        "name": name,
        "message": message,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
