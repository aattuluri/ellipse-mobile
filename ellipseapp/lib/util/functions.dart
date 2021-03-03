import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/index.dart';
import 'index.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<void> scheduleNotification(BuildContext context, int id, String title,
    String subtitle, DateTime datetime, String payload) async {
  LocalNotificationsProvider.scheduleNotifications(context,
      id: id,
      title: title,
      subtitle: subtitle,
      date: datetime,
      payload: payload);
}

Future<void> getFirebaseToken(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _firebaseMessaging.getToken().then((deviceToken) {
    print("FirebaseToken");
    print("$deviceToken");
    prefs.setString("firebaseMessagingToken", "$deviceToken".toString());
  });
}

Future<void> updateSeenNotifications(BuildContext context) async {
  final response = await http.get(
    "${Url.URL}/api/update_notification_status",
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    },
  );
  final responseJson = json.decode(response.body);
  print(responseJson);
}

prefSaveInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

prefSaveString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

prefSaveBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}
