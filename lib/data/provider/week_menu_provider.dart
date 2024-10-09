import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookia/data/model/week_menu.dart';
import 'package:cookia/utils/router/router_config.dart';
import 'package:flutter/material.dart';

class WeekMenuProvider {
  static final _weeklyCollection =
      FirebaseFirestore.instance.collection('week_menu').withConverter(
            fromFirestore: WeekMenu.fromFireStore,
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Future<WeekMenu?> getMenuUser(String userID) async {
    if (userID.isEmpty) return null;
    try {
      var result = await _weeklyCollection.doc(userID).get();
      return result.data();
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  static Future<bool> addMenuToRecipe(Map<String, dynamic> menu) async {
    try {
      await _weeklyCollection.doc(currentUserAuth!.id).update({"menu": menu});
      return true;
    } catch (_) {
      return false;
    }
  }
}
