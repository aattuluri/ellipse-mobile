import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../tabs/index.dart';
import '../tabs/more.dart';
import '../tabs/notifications.dart';

class StartScreen extends StatefulWidget {
  final int current_tab;
  StartScreen(this.current_tab);
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool('loggedIn') ?? false);
    if (loggedin) {
      loadPref();
    } else {
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  //HomeeeeTab homeTab;
  HomeTab homeTab;
  CalendarTab calendarTab;
  NotificationsTab notificationsTab;
  MoreTab moreTab;
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
    //homeTab = HomeeeeTab();
    homeTab = HomeTab();
    calendarTab = CalendarTab();
    notificationsTab = NotificationsTab();
    moreTab = MoreTab();
    pages = [homeTab, calendarTab, notificationsTab, moreTab];
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
      child: Consumer<EventsRepository>(
        builder: (context, model1, child) => Consumer<UserDetailsRepository>(
          builder: (context, model2, child) =>
              Consumer<NotificationsRepository>(
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

                                  /*BottomNavigationBarItem(
                                    title: SizedBox.shrink(),
                                    //title: Text("Explore"),
                                    icon: Icon(Icons.explore),
                                  ),
                                  */
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
      ),
    );
  }
}
