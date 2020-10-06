import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../screens/index.dart';
import '../tabs/index.dart';
import '../tabs/more.dart';
import '../tabs/notifications.dart';
import '../widgets/index.dart';

class StartScreen extends StatefulWidget {
  final int current_tab;
  StartScreen(this.current_tab);
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool ischecking = false;
  //HomeeeeTab homeTab;
  HomeTab homeTab;
  CalendarTab calendarTab;
  NotificationsTab notificationsTab;
  ProfileTab profileTab;
  MoreTab moreTab;
  List<Widget> pages;
  Widget currentPage;
  int currentTab;
  check() async {
    getFirebaseToken();
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
      getNotificationsCount();
      //////////////////////////////////
      await http.post(
        '${Url.URL}/api/add_firebase_notification_token_to_user',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefToken'
        },
        body:
            jsonEncode(<dynamic, dynamic>{'token': prefFirebaseMessagingToken}),
      );
      //////////////////////////////////

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
    check();
    //getNotificationsCount();
    //loadNotificationsCount();
    //context.read<EventsRepository>().refreshData();
    context.read<UserDetailsRepository>().refreshData();
    //context.read<NotificationsRepository>().refreshData();

    currentTab = widget.current_tab;
    //homeTab = HomeeeeTab();
    homeTab = HomeTab();
    calendarTab = CalendarTab();
    notificationsTab = NotificationsTab();
    profileTab = ProfileTab();
    moreTab = MoreTab();
    pages = [homeTab, calendarTab, notificationsTab, profileTab, moreTab];
    switch (currentTab) {
      case 0:
        currentPage = homeTab;
        break;
      case 1:
        currentPage = calendarTab;
        break;
      case 2:
        currentPage = notificationsTab;
        break;
      case 3:
        currentPage = profileTab;
        break;
      case 4:
        currentPage = moreTab;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer<UserDetailsRepository>(
        builder: (context, model1, child) => Consumer<EventsRepository>(
          builder: (context, model2, child) =>
              Consumer<NotificationsRepository>(
            builder: (context, model3, child) => model1.isLoading ||
                    model1.loadingFailed ||
                    model2.isLoading ||
                    model2.loadingFailed ||
                    model3.isLoading ||
                    model3.loadingFailed ||
                    ischecking
                ? Scaffold(
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please Wait....",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                :
                ////////////////////////////
                Scaffold(
                    key: scaffoldKey,
                    body: currentPage,
                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                      child: BottomNavigationBar(
                        iconSize: 27,
                        elevation: 5,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: currentTab,
                        onTap: (index) async {
                          setState(() {
                            currentTab = index;
                            currentPage = pages[index];
                          });
                        },
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            title: SizedBox.shrink(),
                            //title: Text("Home"),
                            icon: Icon(LineIcons.home),
                          ),
                          BottomNavigationBarItem(
                            title: SizedBox.shrink(),
                            //title: Text("Calendar"),
                            icon: Icon(LineIcons.calendar_o),
                          ),
                          BottomNavigationBarItem(
                            title: SizedBox.shrink(),
                            //title: Text("Notifications"),
                            //icon: Icon(Icons.notifications),
                            icon: IconBadge(
                              icon: Icon(LineIcons.bell),
                              itemCount: 5,
                              badgeColor: Colors.blueGrey.withOpacity(0.9),
                              itemColor: Colors.white,
                              hideZero: true,
                              maxCount: 100,
                            ),
                          ),
                          BottomNavigationBarItem(
                            title: SizedBox.shrink(),
                            //title: Text("Profile"),
                            icon: Icon(LineIcons.user),
                          ),
                          BottomNavigationBarItem(
                            title: SizedBox.shrink(),
                            //title: Text("Settings"),
                            //icon: Icon(Icons.settings),
                            icon: Icon(LineIcons.cog),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
