import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import 'index.dart';
import 'package:dio/dio.dart';
import '../util/index.dart';
import 'base.dart';
import 'package:flutter/material.dart';

class NotificationsRepository extends BaseRepository {
  List<Notifications> allNotifications;
  String token = "", id = "", email = "";

  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    id = prefs.getString("id");
    email = prefs.getString("email");
    try {
      print("Started Loading notifications");
      // Receives the data and parse it
      final Response<List> response =
          await Dio().get("${Url.URL}/api/get_notifications",
              options: Options(
                headers: {"Authorization": "Bearer $token"},
              ));
      print(response.data);
      allNotifications = [
        for (final item in response.data) Notifications.fromJson(item)
      ];
      allNotifications = allNotifications.reversed.toList();
      finishLoading();
      print("Notificationss loaded");
    } catch (_) {
      receivedError();
      print("error");
    }
  }

  Notifications getNotifications(int index) => allNotifications[index];
}
