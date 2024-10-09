import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/provider/user_provider.dart';

import 'local_notifications.dart';

// global deviceToken
String? appDeviceToken;

class FirebaseNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> handleMessageBackground(RemoteMessage message) async {
    debugPrint(message.data.toString());
  }

  static Future<void> handlerListenMessage(RemoteMessage event) async {
    var data = event.notification;
    await LocalNotifications.showNotification(
      title: data!.title ?? "",
      body: data.body ?? "",
    );
  }

  static Future<void> init() async {
    try {
      await _firebaseMessaging.requestPermission();
      appDeviceToken = await _firebaseMessaging.getToken();
      // Update user token
      await UserProvider.update({
        "registrationToken": appDeviceToken,
      });
      // Add list methode
      FirebaseMessaging.onMessage.listen(handlerListenMessage);
      FirebaseMessaging.onBackgroundMessage(handleMessageBackground);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
