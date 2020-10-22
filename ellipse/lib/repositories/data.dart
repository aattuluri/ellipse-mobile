import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/index.dart';
import '../util/index.dart';
import 'base.dart';
import 'index.dart';

class DataRepository extends BaseRepository {
  List<Data1> allData1 = [];
  List<String> requirements = [];
  List<String> tags = [];
  List<String> eventTypes = [];

  @override
  Future<void> loadData() async {
    loadPref();
    try {
      finishLoading();
      print("Started Loading data");
      // Receives the data and parse it

      http.Response response = await http.get(
        "${Url.URL}/api/event/get_event_keywords",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      allData1 = (json.decode(response.body) as List)
          .map((data) => Data1.fromJson(data))
          .toList();

      for (var i = 0; i < allData1.length; i++) {
        // print(allData1[i].type + "---" + allData1[i].title);
        String title = allData1[i].title.toString();
        if (allData1[i].type == "EventRequirements") {
          requirements.add(title);
        } else if (allData1[i].type == "EventTags") {
          tags.add(title);
        } else if (allData1[i].type == "EventTypes") {
          eventTypes.add(title);
        } else {}
      }
      requirements = requirements.toSet().toList();
      tags = tags.toSet().toList();
      eventTypes = eventTypes.toSet().toList();
      print("Data loaded");
    } catch (_) {
      receivedError();
      print("error");
    }
  }
}
