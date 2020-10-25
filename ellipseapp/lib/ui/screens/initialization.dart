import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/routes.dart';

class Initialization extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization>
    with WidgetsBindingObserver {
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
      //Navigator.pushNamed(context, Routes.splash_screen);
      Navigator.pushNamed(context, Routes.intro);
    }
  }

  check_connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      //Navigator.pushNamed(context, Routes.intro);
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

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);
  }

  void _handleDeepLink(PendingDynamicLinkData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool('loggedIn') ?? false);
    final Uri deepLink = data?.link;
    if (deepLink != null && loggedin) {
      print('_handleDeepLink | deeplink: $deepLink');
      var isEvent = deepLink.pathSegments.contains('event');
      var isApp = deepLink.pathSegments.contains('app');
      print(isEvent);
      print(isApp);
      if (isEvent) {
        String id = deepLink
            .toString()
            .trim()
            .replaceAll("${Url.DYNAMIC_LINK_REMOVE}", "");
        String Id = id.trim();
        print(Id);
        final _event = context.read<EventsRepository>().getEventIndex(Id);
        Navigator.pushNamed(context, Routes.info_page,
            arguments: {'index': _event, 'type': 'user'});
      } else if (isApp) {}
    }
  }

  get() async {}

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    get();
    //this.initDynamicLinks();
    loggedin();
    firebase();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      this.initDynamicLinks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container()));
  }
}
