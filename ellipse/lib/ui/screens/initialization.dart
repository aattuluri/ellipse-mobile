import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/index.dart';
import '../../util/routes.dart';

class Initialization extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool('loggedIn') ?? false);
    if (loggedin) {
      loadPref();
      check_connectivity();
    } else {
      //Navigator.push(
      //  context,
      // MaterialPageRoute(builder: (context) => OnBoarding()),
      // );
      Navigator.pushNamed(context, Routes.splash_screen);
    }
  }

  check_connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      Navigator.pushNamed(
        context,
        Routes.start,
        arguments: {'current_tab': 0},
      );
      print("internet  available");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      Navigator.pushNamed(
        context,
        Routes.start,
        arguments: {'current_tab': 0},
      );
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

  @override
  void initState() {
    loggedin();
    firebase();
    super.initState();
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
    return SafeArea(child: Scaffold(body: Container()));
  }
}
