import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../util/index.dart';
import 'base.dart';
import 'index.dart';

class EventsRepository extends BaseRepository {
  List<Events> allEvents = [];
  List<Registrations> allRegistrations = [];
  @override
  Future<void> loadData() async {
    loadPref();
    try {
      print("Started Loading events");
      http.Response response = await http.get(
        "${Url.URL}/api/events",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      print(json.decode(response.body).toString());
      allEvents = (json.decode(response.body) as List)
          .map((data) => Events.fromJson(data))
          .toList();
      Comparator<Events> sortByStartTime =
          (a, b) => a.start_time.compareTo(b.start_time);
      allEvents.sort(sortByStartTime);
      print(allEvents);
      print("Events loaded");
      /////////////////
      for (var i = 0; i < allEvents.length; i++) {
        if (allEvents[i].user_id == prefId) {
          allEvents[i].moderator = true;
        }
      }
      //////////////////////////////////////////////////////////////////

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
      allRegistrations = (json.decode(response1.body) as List)
          .map((data1) => Registrations.fromJson(data1))
          .toList();
      print(allRegistrations);
      print("Registrations loaded");
/*
      if (allRegistrations.isNotEmpty) {
        for (var i = 0; i < allEvents.length; i++) {
          for (var j = 0; j < allRegistrations.length; j++) {
            if (allRegistrations[j].event_id == allEvents[i].id) {
              allEvents[i].registered = true;
            }
          }
        }
      }
      */
      finishLoading();
    } catch (_) {
      print("ErrorErrorErrorErrorErrorErrorErrorErrorError");
      receivedError();
    }
  }

  Events getEvent(int index) {
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
