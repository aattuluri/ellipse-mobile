import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../providers/index.dart';
import '../util/index.dart';

class EventsRepository with ChangeNotifier {
  List<Events> get allEvents => _allEvents;
  List<Events> get postedEvents => _postedEvents;
  List<Events> get upcomingEvents => _upcomingEvents;
  List<Events> get ongoingEvents => _ongoingEvents;
  List<Events> get pastEvents => _pastEvents;

  List<Events> _allEvents = [];
  List<Events> _postedEvents = [];
  List<Events> _upcomingEvents = [];
  List<Events> _ongoingEvents = [];
  List<Events> _pastEvents = [];
  List<Registrations> allRegistrations = [];
  bool isLoading = false;
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  /// Signals that information has been downloaded.
  void finishLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    loadPref();
    try {
      startLoading();
      print("Started Loading events");
      http.Response response = await http.get(
        "${Url.URL}/api/events",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      print(json.decode(response.body).toString());
      _allEvents = [
        for (final item in json.decode(response.body)) Events.fromJson(item)
      ];
      Comparator<Events> sortByStartTime =
          (a, b) => a.startTime.compareTo(b.startTime);
      allEvents.sort(sortByStartTime);
      print(allEvents);
      await formatEvents();
      print("Events loaded");
      //////////////////////////////////////////////////////////////////
      print("Started Loading Registrations of User");
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $prefToken",
        HttpHeaders.contentTypeHeader: "application/json"
      };
      http.Response response1 = await http.get(
          "${Url.URL}/api/user/registeredEvents?id=$prefToken",
          headers: headers);
      print('Response status: ${response1.statusCode}');
      print('Response body: ${response1.body}');
      allRegistrations = (json.decode(response1.body) as List)
          .map((data1) => Registrations.fromJson(data1))
          .toList();
      print(allRegistrations);
      print("Registrations loaded");
      notifyListeners();
      finishLoading();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> sortByName() async {
    Comparator<Events> sortByName = (a, b) => a.name.compareTo(b.name);
    allEvents.sort(sortByName);
    await formatEvents();
    print('sorted by name');
    return true;
  }

  Future<bool> sortByTime() async {
    Comparator<Events> sortByTime =
        (a, b) => a.startTime.compareTo(b.startTime);
    allEvents.sort(sortByTime);
    await formatEvents();
    print('sorted by name');
    return true;
  }

  Future<bool> formatEvents() async {
    _postedEvents =
        allEvents.where((item) => item.admin || item.moderator).toList();
    _upcomingEvents = allEvents
        .where((item) =>
            item.startTime.isAfter(DateTime.now()) &&
            (item.oAllowed || item.collegeId == prefCollegeId) &&
            item.status == "active")
        .toList();
    _ongoingEvents = allEvents
        .where((item) =>
            item.startTime.isBefore(DateTime.now()) &&
            item.finishTime.isAfter(DateTime.now()) &&
            (item.oAllowed || item.collegeId == prefCollegeId) &&
            item.status == "active")
        .toList();
    _pastEvents = allEvents
        .where((item) =>
            item.finishTime.isBefore(DateTime.now()) &&
            (item.oAllowed || item.collegeId == prefCollegeId) &&
            item.status == "active")
        .toList();
    notifyListeners();
    return true;
  }

  event(String id) {
    for (var i = 0; i < allEvents.length; i++) {
      if (allEvents[i].eventId == id) {
        return allEvents[i];
      }
    }
  }


}
