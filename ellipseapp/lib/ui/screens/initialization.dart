import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:EllipseApp/ui/widgets/index.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/routes.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class Initialization extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization>
    with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool updateRequired;
  Future loggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = (prefs.getBool('loggedIn') ?? false);
    if (loggedIn) {
      try {
        loadPref();
        checkConnectivity();
      } catch (e) {
        print(e);
        resetPref();
        Navigator.pushNamed(context, Routes.intro);
      }
      ;
    } else {
      Navigator.pushNamed(context, Routes.intro);
    }
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      getVersion();
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
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
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
        final _event = context.read<EventsRepository>().event(Id);
        Navigator.pushNamed(context, Routes.info_page,
            arguments: {'type': 'user', 'event_': _event});
      } else if (isApp) {}
    }
  }

  check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    getFirebaseToken(context);

    final responsev = await http.get(
      "${Url.URL}/api/users/me",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $prefToken",
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    if (responsev.statusCode == 401) {
      Navigator.pushNamed(context, Routes.signin);
    } else {
      final responsen = await http.get(
        "${Url.URL}/api/get_unseen_notifications_count",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      final responseJson = json.decode(responsen.body);
      print("Notifications Count");
      saveInt("notificationsCount", responseJson);
      print(responseJson);

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
        _firebaseMessaging.getToken().then((deviceToken) async {
          await http.post(
            '${Url.URL}/api/add_firebase_notification_token_to_user',
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $prefToken'
            },
            body: jsonEncode(<dynamic, dynamic>{'token': '$deviceToken'}),
          );
        });
        Navigator.pushNamed(
          context,
          Routes.start,
          arguments: {'currentTab': 0},
        );
        print("All details checked");
      } else {
        Navigator.pushNamed(context, Routes.signin);
      }
    }
  }

  getVersion() async {
    http.Response response = await http.get("${Url.URL}/api/get_version");
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (jsonResponse != null) {
      Map<String, dynamic> versionDetails = jsonResponse;
      setState(() {
        updateRequired = jsonResponse['required'];
      });
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        String version = packageInfo.version;
        //String version = '1.0.2';
        print(version);
        print(versionDetails['version_name']);
        print(updateRequired);
        if (version == versionDetails['version_name']) {
          check();
        } else if (version != versionDetails['version_name'] &&
            updateRequired) {
          _showCompulsoryUpdateDialog(
            context,
            "Please update the app to continue\nNew Version : ${versionDetails['version_name']}",
          );
        } else if (version != versionDetails['version_name'] &&
            !updateRequired) {
          _showOptionalUpdateDialog(
            context,
            "A newer version of the app is available\nNew Version : ${versionDetails['version_name']}",
          );
        } else {
          Navigator.pushNamed(context, Routes.signin);
        }
      });
    }
  }

  _onUpdateNowClicked() {
    'https://play.google.com/store/apps/details?id=com.ellipse.ellipseapp'
        .launchUrl;
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22),
                ),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              );
      },
    );
  }

  _showOptionalUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      'Later',
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22),
                ),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: _onUpdateNowClicked,
                  ),
                  FlatButton(
                    child: Text('Later'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    loggedIn();
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
    return Scaffold(body: LoaderCircular('Loading'));
  }
}
