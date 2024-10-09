import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/utils/router/router_config.dart';

class UserProvider {
  static final userCollection =
      FirebaseFirestore.instance.collection("users").withConverter(
            fromFirestore: UserAuth.fromFireStore,
            toFirestore: (value, options) => value.toFirestore(),
          );

  static Future<bool> add(UserAuth user) async {
    try {
      await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<UserAuth?> get() async {
    try {
      var response = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      return response.data();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> update(Map<String, dynamic> data) async {
    try {
      await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<int> checkActivity() async {
    if (currentUserAuth != null) {
      if (currentUserAuth!.lastRequest != null) {
        var differenceInMin = currentUserAuth!.lastRequest!
                .toDate()
                .difference(Timestamp.now().toDate())
                .inMinutes *
            -1;
        if (differenceInMin >= 1440) {
          await update({
            'numberAuthorizedRequest': 3,
          });
        }
      }
      return currentUserAuth!.numberAuthorizedRequest;
    } else {
      throw "User not found";
    }
  }

  static Future<bool> updateActivity() async {
    if (currentUserAuth != null) {
      int requestAuthorized = currentUserAuth!.numberAuthorizedRequest - 1;
      Timestamp lastRequest = Timestamp.now();
      var response = await update({
        'lastRequest': lastRequest,
        'numberRequest': currentUserAuth!.numberRequest + 1,
        'numberAuthorizedRequest': requestAuthorized,
      });
      currentUserAuth!.lastRequest = lastRequest;
      currentUserAuth!.numberAuthorizedRequest = requestAuthorized;
      return response;
    } else {
      return false;
    }
  }
}
