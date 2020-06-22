import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  //function to add event
  void add_event(
      String base64Image,
      String fileName,
      String user_id,
      String _nameController,
      String _descriptionController,
      String _start_timeController,
      String _finish_timeController) async {
    String myUrl = "http://192.168.43.215:4000/events";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json'
    }, body: {
      "base64Image": "$base64Image",
      "fileName": "$fileName",
      "user_id": "$user_id",
      "name": "$_nameController",
      "description": "$_descriptionController",
      "start_time": "$_start_timeController",
      "finish_time": "$_finish_timeController"
    });
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  //function to fetch events
  Future<List> getData() async {
    final response = await http.get("http://192.168.43.215:4000/events");
    return json.decode(response.body);
  }

  //function for update or put
  void editarProduct(
      String _id, String name, String price, String stock) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.1.56:3000/event/$_id";
    http.put(myUrl, body: {
      "name": "$name",
      "price": "$price",
      "stock": "$stock"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //function for delete
  Future<void> removeRegister(String _id) async {
    String myUrl = "http://192.168.1.56:3000/event/$_id";

    Response res = await http.delete("$myUrl");

    if (res.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Can't delete post.";
    }
  }

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

//function read
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
