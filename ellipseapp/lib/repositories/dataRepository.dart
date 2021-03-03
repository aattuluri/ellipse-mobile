import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../providers/index.dart';
import '../util/index.dart';
import 'baseRepository.dart';
import 'index.dart';

class DataRepository extends BaseRepository {
  final List<String> designations = [
    "Student",
    "Faculty",
    "Club/Organization",
    "Institution",
    "Others"
  ];
  Map<String, dynamic> designationsData = {};
  Map<String, dynamic> collegesData = {};
  List<Data1> allData = [];
  List<String> requirements = [];
  Map<String, dynamic> requirementsData = {};
  List<String> tags = [];
  Map<String, dynamic> tagsData = {};
  List<String> eventTypes = [];
  Map<String, dynamic> eventTypesData = {};

  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = (prefs.getBool('loggedIn') ?? false);
    loadPref();
    try {
      startLoading();
      print("Started Loading data");
      // Receives the data and parse it
      http.Response response1 =
          await httpGetWithoutHeaders("${Url.URL}/api/colleges");
      List<dynamic> colleges = json.decode(response1.body.toString());
      colleges = colleges.toSet().toList();
      for (var i = 0; i < colleges.length; i++) {
        collegesData[colleges[i]['_id']] = colleges[i]['name'];
      }
      print('colleges');
      print(collegesData);
      for (var i = 0; i < designations.length; i++) {
        designationsData[designations[i]] = designations[i];
      }
      if (loggedIn) {
        http.Response response2 = await http.get(
          "${Url.URL}/api/event/get_event_keywords",
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $prefToken",
            HttpHeaders.contentTypeHeader: "application/json"
          },
        );
        allData = (json.decode(response2.body) as List)
            .map((data) => Data1.fromJson(data))
            .toList();
        for (var i = 0; i < allData.length; i++) {
          String title = allData[i].title.toString();
          if (allData[i].type == "EventRequirements") {
            requirements.add(title);
          } else if (allData[i].type == "EventTags") {
            tags.add(title);
          } else if (allData[i].type == "EventTypes") {
            eventTypes.add(title);
          } else {}
        }
        requirements = requirements.toSet().toList();
        tags = tags.toSet().toList();
        eventTypes = eventTypes.toSet().toList();
        for (var i = 0; i < requirements.length; i++) {
          requirementsData[requirements[i]] = requirements[i];
        }
        for (var i = 0; i < tags.length; i++) {
          tagsData[tags[i]] = tags[i];
        }
        for (var i = 0; i < eventTypes.length; i++) {
          eventTypesData[eventTypes[i]] = eventTypes[i];
        }
        print("Data loaded");
      } else {}
      notifyListeners();
      finishLoading();
    } catch (e) {
      receivedError();
      print(e);
    }
  }
}
