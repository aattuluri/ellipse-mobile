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

class UserDetailsRepository extends BaseRepository {
  List<UserDetails> allUserDetails = [];
  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadPref();
    try {
      startLoading();
      print("Started Loading userDetails");
      // Receives the data and parse it
      http.Response response = await http.get(
        "${Url.URL}/api/users/me",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      allUserDetails = (json.decode(response.body) as List)
          .map((data) => UserDetails.fromMap(data))
          .toList();
      prefs.setString("name", allUserDetails[0].name);
      prefs.setString("collegeName", allUserDetails[0].collegeName);
      prefs.setString("collegeId", allUserDetails[0].collegeId);
      print("UserDetails loaded");
      notifyListeners();
      finishLoading();
    } catch (e) {
      receivedError();
      print(e);
    }
  }

  UserDetails getUserDetails(int index) => allUserDetails[index];
}
