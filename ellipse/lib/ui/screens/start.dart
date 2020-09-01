import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../menu_drawer/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../tabs/notifications.dart';
import '../tabs/settings.dart';
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
import '../pages/index.dart';

class StartScreen extends StatefulWidget {
  final int current_tab;
  StartScreen(this.current_tab);
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String token = "", id = "", email = "", college_id = "";
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
  }

  HomeTab homeTab;
  ExploreTab exploreTab;
  CalendarTab calendarTab;
  NotificationsTab notificationsTab;
  SettingsTab settingsTab;
  List<Widget> pages;
  Widget currentPage;
  int currentTab;
  @override
  void initState() {
    context.read<EventsRepository>().refreshData();
    context.read<UserDetailsRepository>().refreshData();
    context.read<NotificationsRepository>().refreshData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    currentTab = widget.current_tab;
    homeTab = HomeTab();
    exploreTab = ExploreTab();
    calendarTab = CalendarTab();
    notificationsTab = NotificationsTab();
    settingsTab = SettingsTab();
    pages = [homeTab, exploreTab, calendarTab, notificationsTab, settingsTab];
    switch (currentTab) {
      case 0:
        currentPage = homeTab;
        break;
      case 1:
        currentPage = exploreTab;
        break;
      case 2:
        currentPage = notificationsTab;
        break;
      case 3:
        currentPage = settingsTab;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model1, child) => Consumer<UserDetailsRepository>(
        builder: (context, model2, child) => Consumer<NotificationsRepository>(
          builder: (context, model3, child) => SafeArea(
            child:
                //////////////////////////////////
                model1.isLoading ||
                        model1.loadingFailed ||
                        model2.isLoading ||
                        model2.loadingFailed ||
                        model3.isLoading ||
                        model3.loadingFailed
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Please Wait....",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                          /*
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1.0,
                              color: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .color
                                  .withOpacity(0.1),
                            ),
                          ),
                        ),
                        */
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                            child: BottomNavigationBar(
                              iconSize: 30,
                              elevation: 5,
                              selectedLabelStyle:
                                  TextStyle(fontFamily: 'ProductSans'),
                              unselectedLabelStyle:
                                  TextStyle(fontFamily: 'ProductSans'),
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
                                  icon: Icon(Icons.home),
                                ),
                                BottomNavigationBarItem(
                                  title: SizedBox.shrink(),
                                  //title: Text("Explore"),
                                  icon: Icon(Icons.explore),
                                ),
                                BottomNavigationBarItem(
                                  title: SizedBox.shrink(),
                                  //title: Text("Calendar"),
                                  icon: Icon(Icons.event),
                                ),
                                BottomNavigationBarItem(
                                  title: SizedBox.shrink(),
                                  //title: Text("Notifications"),
                                  icon: Icon(Icons.notifications),
                                ),
                                BottomNavigationBarItem(
                                  title: SizedBox.shrink(),
                                  //title: Text("Settings"),
                                  //icon: Icon(Icons.settings),
                                  icon: Icon(Icons.menu),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
