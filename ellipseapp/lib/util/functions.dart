import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

getFirebaseToken(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _firebaseMessaging.getToken().then((deviceToken) {
    print("FirebaseToken");
    print("$deviceToken");
    prefs.setString("firebaseMessagingToken", "$deviceToken".toString());
  });
}

sendFirebaseToken(BuildContext context) async {
  http.Response response = await http.post(
    '${Url.URL}/api/add_firebase_notification_token_to_user',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $prefToken'
    },
    body: jsonEncode(<dynamic, dynamic>{'token': prefFirebaseMessagingToken}),
  );
}

updateSeenNotifications(BuildContext context) async {
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
