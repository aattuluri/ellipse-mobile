import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
import '../tabs/notifications.dart';
import '../widgets/index.dart';

final int tabCount = 4;

class StartScreen extends StatefulWidget {
  final int current_tab;
  StartScreen(this.current_tab);
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int notifCount = 0;
  bool ischecking = false;
  HomeTab homeTab;
  CalendarTab calendarTab;
  NotificationsTab notificationsTab;
  ProfileTab profileTab;
  List<Widget> pages;
  Widget currentPage;
  int currentTab;
  noCheck() {}
  check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    getFirebaseToken(context);
    setState(() {
      ischecking = true;
    });

    final responsen = await http.get(
      "${Url.URL}/api/get_unseen_notifications_count",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $prefToken",
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    final responseJson = json.decode(responsen.body);
    print("Notifications Count");
    setState(() {
      notifCount = responseJson;
    });
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
      context.read<UserDetailsRepository>().refreshData();
      context.read<EventsRepository>().refreshData();
      context.read<NotificationsRepository>().refreshData();
      context.read<DataRepository>().refreshData();
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
    controller = new TabController(length: tabCount, vsync: this);
    check();
    // widget.load == true ? check() : noCheck();
    //getNotificationsCount();
    //loadNotificationsCount();

    currentTab = widget.current_tab;
    homeTab = HomeTab();
    calendarTab = CalendarTab();
    notificationsTab = NotificationsTab();
    profileTab = ProfileTab();
    //moreTab = MoreTab();
    pages = [homeTab, calendarTab, notificationsTab, profileTab];
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
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final tabPadding = (width / tabCount) * 0.15;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer<UserDetailsRepository>(
        builder: (context, model1, child) => Consumer<EventsRepository>(
          builder: (context, model2, child) => Consumer<DataRepository>(
            builder: (context, model3, child) =>
                Consumer<NotificationsRepository>(
              builder: (context, model4, child) => model1.isLoading ||
                      model1.loadingFailed ||
                      model2.isLoading ||
                      model2.loadingFailed ||
                      model3.isLoading ||
                      model3.loadingFailed ||
                      model4.isLoading ||
                      model4.loadingFailed ||
                      ischecking
                  ? LoaderCircular(0.25, "Loading")
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: height * 0.06,
                              minHeight: height * 0.06),
                          child: TabBar(
                            dragStartBehavior: DragStartBehavior.start,
                            labelColor: Theme.of(context).accentColor,
                            unselectedLabelColor:
                                Theme.of(context).iconTheme.color,
                            onTap: (index) async {
                              setState(() {
                                currentTab = index;
                                currentPage = pages[index];
                              });
                              if (index == 2) {
                                setState(() {
                                  notifCount = 0;
                                });
                              }
                            },
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                              ),
                              insets: EdgeInsets.fromLTRB(
                                  tabPadding, 0.0, tabPadding, height * 0.06),
                            ),

                            controller: controller,
                            isScrollable: false,
                            physics: NeverScrollableScrollPhysics(),
                            // indicatorColor: Theme.of(context).accentColor,
                            tabs: <Widget>[
                              Tab(icon: Icon(LineIcons.home)),
                              Tab(icon: Icon(LineIcons.calendar_o)),
                              Tab(
                                icon: Icon(Icons.notifications),
                              ),
                              Tab(icon: Icon(LineIcons.user)),
                            ],
                          ),
                        ),
                      ),
                      /*Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                        child: BottomNavigationBar(
                          //iconSize: 30,
                          elevation: 5,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: currentTab,
                          onTap: (index) async {
                            setState(() {
                              currentTab = index;
                              currentPage = pages[index];
                            });
                            if (index == 2) {
                              setState(() {
                                notifCount = 0;
                              });
                            }
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
                                itemCount: notifCount,
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
                          ],
                        ),
                      ),
                    */
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
