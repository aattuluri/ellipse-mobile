import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../util/index.dart';
import 'base.dart';
import 'index.dart';

class UserDetailsRepository extends BaseRepository {
  List<UserDetails> allUserDetails = [];
  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadPref();
    try {
      print("Started Loading userdetails");
      // Receives the data and parse it
      http.Response response = await http.get(
        "${Url.URL}/api/users/me",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      allUserDetails = (json.decode(response.body) as List)
          .map((data) => UserDetails.fromJson(data))
          .toList();
      prefs.setString("name", allUserDetails[0].name);
      prefs.setString("collegeName", allUserDetails[0].college_name);
      finishLoading();
      print("UserDetails loaded");
    } catch (_) {
      receivedError();
      print("error");
    }
  }

  UserDetails getUserDetails(int index) => allUserDetails[index];
}
