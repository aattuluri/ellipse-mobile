//import 'package:http/http.dart';
//import 'package:http/http.dart' as http
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';

class ApiService {
  String token = "", id = "", email = "";

  Future<Response<List>> getEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    id = prefs.getString("id");
    email = prefs.getString("email");

    return Dio().get("${Url.URL}/api/events",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ));
  }
}
