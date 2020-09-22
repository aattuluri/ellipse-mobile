import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../util/routes.dart';
import '../screens/index.dart';

class Initialization extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  String token = "", id = "", email = "", college_id = "";
  bool ischecking = false;
  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool(Constants.LOGGED_IN) ?? false);
    if (loggedin) {
      getPref();
    } else {
      Navigator.pushNamed(context, Routes.splash_screen);
      //Navigator.pushNamed(context, Routes.main_screen);
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    check_connectivity();
  }

  check_connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      check();
      print("internet  available");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      check();
      print("internet  available");
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      Navigator.pushNamed(context, Routes.connection_error);
      print("Error in connection");
      return false;
    } else {
      Navigator.pushNamed(context, Routes.connection_error);
      print("Error in connection");
      return false;
    }
  }

  check() async {
    setState(() {
      ischecking = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    http.Response response;
    try {
      response = await http.post(
        '${Url.URL}/api/users/check',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<dynamic, dynamic>{'id': '$id'}),
      );
    } catch (e) {
      Navigator.pushNamed(context, Routes.signin);
    }
    //var jsonResponse = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 401) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
            OtpPageEmailVerify(email, "email_verification"),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 402) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => Check(),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 403) {
      setState(() {
        preferences.setString("college_id", "${response.body}".toString());
      });
      print(college_id);
      Navigator.pushNamed(
        context,
        Routes.start,
        arguments: {'currebt_tab': 0},
      );
      setState(() {
        ischecking = false;
      });
      print("All details checked");
    } else {
      setState(() {
        preferences.setBool(Constants.CHECKED, false);
      });
      setState(() {
        ischecking = false;
      });
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  @override
  void initState() {
    loggedin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 40,
          ),
          Text(
            "Loading",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Please Wait.......",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    )));
  }
}
