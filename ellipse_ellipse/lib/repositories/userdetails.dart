import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import 'index.dart';
import 'package:dio/dio.dart';
import '../util/index.dart';
import 'base.dart';
import 'package:flutter/material.dart';

/// Repository that holds a list of launches.
class UserDetailsRepository extends BaseRepository {
  List<UserDetails> allUserDetails;
  String token = "", id = "", email = "";

  @override
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    id = prefs.getString("id");
    email = prefs.getString("email");
    try {
      print("Started Loading userdetails");
      // Receives the data and parse it
      final Response<List> response = await Dio().get("${Url.URL}/api/users/me",
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
      print(response.data);
      allUserDetails = [
        for (final item in response.data) UserDetails.fromJson(item)
      ];

      finishLoading();
      print("UserDetails loaded");
    } catch (_) {
      receivedError();
      print("error");
    }
  }

  UserDetails getUserDetails(int index) => allUserDetails[index];
}
