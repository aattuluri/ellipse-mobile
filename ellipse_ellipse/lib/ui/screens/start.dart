import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../tabs/notifications.dart';
import '../tabs/more.dart';
import 'dart:convert';
import 'dart:async';
import '../screens/index.dart';
import 'package:flutter/material.dart';
import '../tabs/index.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/constants.dart' as Constants;
import 'dart:io';

class StartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String token = "", id = "", email = "";
  bool ischecking = false;
  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool(Constants.LOGGED_IN) ?? false);
    if (loggedin) {
      getPref();
    } else {
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  getPref() async {
    setState(() {
      ischecking = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    http.Response response = await http.post(
      '${Url.URL}/api/users/check',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'id': '$id'}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 401) {
      http.Response response1 = await http.post(
        '${Url.URL}/api/users/emailverify',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{'email': '$email'}),
      );
      print('Response status: ${response1.statusCode}');
      print('Response body: ${response1.body}');
      if (response1.statusCode == 200) {
        print("sent check request");
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => OtpPageEmailVerify(),
        );
        Navigator.of(context).push(route);
        //print(jsonResponse['otp']);
      } else {
        print(response1.body);
      }
    } else if (response.statusCode == 402) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => Check(),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 403) {
      setState(() {
        ischecking = false;
      });
      print("All details checked");
    } else {
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  int currentTab = 0;
  HomeTab homeTab;
  ExploreTab exploreTab;
  EventTab eventTab;
  NotificationsTab notificationsTab;
  MoreTab moreTab;
  List<Widget> pages;
  Widget currentPage;
  @override
  void initState() {
    loggedin();
    homeTab = HomeTab();
    exploreTab = ExploreTab();
    eventTab = EventTab();
    notificationsTab = NotificationsTab();
    moreTab = MoreTab();
    pages = [homeTab, exploreTab, eventTab, notificationsTab, moreTab];

    currentPage = homeTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ischecking
        ? Center(child: const CircularProgressIndicator())
        : Consumer<EventsRepository>(
            builder: (context, model, child) => SafeArea(
              child:
                  //model.isLoading || model.loadingFailed
                  // ? Center(child: const CircularProgressIndicator())
                  //  :
                  Scaffold(
                body: currentPage,
                bottomNavigationBar: BottomNavigationBar(
                  selectedLabelStyle: TextStyle(fontFamily: 'ProductSans'),
                  unselectedLabelStyle: TextStyle(fontFamily: 'ProductSans'),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentTab,
                  onTap: (index) {
                    setState(() {
                      currentTab = index;
                      currentPage = pages[index];
                    });
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      title: Text("Home"),
                      icon: Icon(Icons.home),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Explore"),
                      icon: Icon(Icons.explore),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Dashboard"),
                      icon: Icon(Icons.today),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Notifications"),
                      icon: Icon(Icons.notifications),
                    ),
                    BottomNavigationBarItem(
                      title: Text("More"),
                      icon: Icon(Icons.menu),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
