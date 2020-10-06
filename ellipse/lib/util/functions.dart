import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
getFirebaseToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _firebaseMessaging.getToken().then((deviceToken) {
    print("FirebaseToken");
    print("$deviceToken");
    prefs.setString("firebaseMessagingToken", "$deviceToken".toString());
  });
}

sendFirebaseToken() async {}

updateSeenNotifications() async {
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

getNotificationsCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(
    "${Url.URL}/api/get_unseen_notifications_count",
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    },
  );
  final responseJson = json.decode(response.body);
  print("Notifications Count");
  print(responseJson);
  prefs.setInt("notificationsCount", responseJson);
}
