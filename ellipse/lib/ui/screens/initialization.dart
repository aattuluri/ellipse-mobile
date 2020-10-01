import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/index.dart';
import '../../util/routes.dart';
import '../screens/index.dart';

class Initialization extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title = "Title";
  String helper = "helper";
  //String token = "", id = "", email = "", college_id = "";
  bool ischecking = false;
  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool('loggedIn') ?? false);
    if (loggedin) {
      loadPref();
      check_connectivity();
      // getPref();
    } else {
      Navigator.pushNamed(context, Routes.splash_screen);
    }
  }

/*
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });

  }
*/
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
          'Authorization': 'Bearer $prefToken'
        },
        body: jsonEncode(<dynamic, dynamic>{'id': '$prefId'}),
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
            OtpPageEmailVerify(prefEmail, "email_verification"),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 402) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => Check(),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 403) {
      setState(() {
        preferences.setString("collegeId", "${response.body}".toString());
      });
      Navigator.pushNamed(
        context,
        Routes.start,
        arguments: {'current_tab': 0},
      );
      setState(() {
        ischecking = false;
      });
      print("All details checked");
    } else {
      setState(() {
        ischecking = false;
      });
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  @override
  void initState() {
    loggedin();
    getFirebaseToken();
    firebase();
    super.initState();
  }

  getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((deviceToken) {
      print("FirebaseToken");
      print("$deviceToken");
      prefs.setString("firebaseMessagingToken", "$deviceToken".toString());
    });
  }

  firebase() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          //messages.add(Message(
          //    title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          // messages.add(Message(
          //   title: '${notification['title']}',
          //  body: '${notification['body']}',
          //));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
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
