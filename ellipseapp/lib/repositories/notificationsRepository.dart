import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../providers/index.dart';
import '../util/index.dart';
import 'baseRepository.dart';
import 'index.dart';

class NotificationsRepository extends BaseRepository {
  List<Notifications> allNotifications = [];

  @override
  Future<void> loadData() async {
    loadPref();
    try {
      startLoading();
      print("Started Loading notifications");
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
      notifyListeners();
      finishLoading();
      print("Notifications loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }
}
