import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import 'index.dart';
import 'package:dio/dio.dart';
import '../util/index.dart';
import 'base.dart';
import 'package:flutter/material.dart';

class EventsRepository extends BaseRepository {
  List<Events> allEvents;
  List<Events> myEvents;
  String token = "", id = "", email = "";
  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    id = prefs.getString("id");
    email = prefs.getString("email");
    try {
      print("Started Loading events");
      // Receives the data and parse it
      final Response<List> response = await Dio().get("${Url.URL}/api/events",
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));

      allEvents = [for (final item in response.data) Events.fromJson(item)];
      allEvents = allEvents.reversed.toList();
      print(allEvents);
      finishLoading();
      print("Events loaded");
    } catch (_) {
      receivedError();
    }
  }

  Events getEventIndex(int index) {
    return allEvents[index];
  }

  getEventId(String id) {
    for (var i = 0; i < allEvents.length; i++) {
      if (allEvents[i].id == id) {
        return i;
      }
    }
  }

  eventsCount() {
    String count = allEvents.length.toString();
    return count;
  }
}
