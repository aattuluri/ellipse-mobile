//import 'package:http/http.dart';
//import 'package:http/http.dart' as http
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import 'index.dart';
import 'package:dio/dio.dart';
import '../util/index.dart';
import 'base.dart';

/// Repository that holds a list of launches.
class EventsRepository extends BaseRepository {
  List<Events> allEvents;
  String token = "", id = "", email = "";
  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    id = prefs.getString("id");
    email = prefs.getString("email");
    try {
      // Receives the data and parse it
      final Response<List> response = await Dio().get("${Url.URL}/api/events",
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));

      allEvents = [for (final item in response.data) Events.fromJson(item)];

      finishLoading();
    } catch (_) {
      receivedError();
    }
  }

  Events getEvents(int index) => allEvents[index];
}
