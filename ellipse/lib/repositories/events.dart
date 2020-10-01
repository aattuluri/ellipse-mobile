import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../util/index.dart';
import 'base.dart';
import 'index.dart';

class EventsRepository extends BaseRepository {
  List<Events> allEvents;
  List<Events> myEvents;
  List<dynamic> registered = [];
  // String token = "", id = "", email = "";
  @override
  Future<void> loadData() async {
    loadPref();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //token = prefs.getString("token");
    //id = prefs.getString("id");
    //email = prefs.getString("email");
    try {
      print("Started Loading events");
      // Receives the data and parse it
      final Response<List> response = await Dio().get("${Url.URL}/api/events",
          options: Options(
            headers: {"Authorization": "Bearer $prefToken"},
          ));

      allEvents = [for (final item in response.data) Events.fromJson(item)];
      allEvents = allEvents.reversed.toList();
      print(allEvents);
      finishLoading();
      print("Events loaded");
    } catch (_) {
      receivedError();
    }
    /////Get Registered Events/////
    try {
      print("Started Loading Registered events");
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $prefToken",
        HttpHeaders.contentTypeHeader: "application/json"
      };
      http.Response response1 = await http.get(
          "${Url.URL}/api/user/registeredEvents?id=$prefId",
          headers: headers);
      print('Response status: ${response1.statusCode}');
      print('Response body: ${response1.body}');
      if (response1.statusCode == 200) {
        registered = json.decode(response1.body);
        print("Registered Events loaded");
      } else {
        throw Exception('Failed to load data');
      }
      if (registered.isNotEmpty) {
        for (var i = 0; i < allEvents.length; i++) {
          for (var j = 0; j < registered.length; j++) {
            if (registered[j]['event_id'] == allEvents[i].id) {
              allEvents[i].registered = true;
            }
          }
        }
      }
    } catch (_) {
      receivedError();
    }
  }

  Events getEvents(int index) {
    return allEvents[index];
  }

  getEventIndex(String id) {
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
