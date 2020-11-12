import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../util/index.dart';
import 'base.dart';
import 'index.dart';

class NotificationsRepository extends BaseRepository {
  List<Notifications> allNotifications = [];

  @override
  Future<void> loadData() async {
    try {
      print("Started Loading notifications");
      // Receives the data and parse it

      http.Response response = await http.get(
        "${Url.URL}/api/get_notifications",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      allNotifications = (json.decode(response.body) as List)
          .map((data) => Notifications.fromJson(data))
          .toList();
      allNotifications = allNotifications.reversed.toList();
      finishLoading();
      print("Notificationss loaded");
    } catch (_) {
      receivedError();
      print("error");
    }
  }
}
