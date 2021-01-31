import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/index.dart';
import '../pages/index.dart';
import '../tabs/index.dart';
import '../tabs/notifications.dart';
import '../widgets/index.dart';

final int tabCount = 5;

class StartScreen extends StatefulWidget {
  final int currentTab;
  StartScreen(this.currentTab);
  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  TabBar tabBar;
  TabController controller;
  int notificationsCount = 0;
  HomeTab homeTab;
  CalendarTab calendarTab;
  ChatTab chatTab;
  NotificationsTab notificationsTab;
  ProfileTab profileTab;
  List<Widget> pages;
  Widget currentPage;
  int currentTab;
  loadNotificationsCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsCount = prefs.getInt("notificationsCount");
    });
  }

  @override
  void initState() {
    loadNotificationsCount();
    controller = new TabController(length: tabCount, vsync: this);
    currentTab = widget.currentTab;
    homeTab = HomeTab();
    calendarTab = CalendarTab();
    chatTab = ChatTab();
    notificationsTab = NotificationsTab();
    profileTab = ProfileTab();
    pages = [homeTab, calendarTab, chatTab, notificationsTab, profileTab];
    switch (currentTab) {
      case 0:
        currentPage = homeTab;
        break;
      case 1:
        currentPage = calendarTab;
        break;
      case 2:
        currentPage = chatTab;
        break;
      case 3:
        currentPage = notificationsTab;
        break;
      case 4:
        currentPage = profileTab;
        break;
    }
    context.read<UserDetailsRepository>().refreshData();
    context.read<DataRepository>().refreshData();
    context.read<EventsRepository>().init();
    context.read<NotificationsRepository>().refreshData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer<DataRepository>(
        builder: (context, data, child) => data.isLoading || data.loadingFailed
            ? LoaderCircular("Loading")
            : Scaffold(
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
                  child: TabBar(
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context).iconTheme.color,
                    onTap: (index) async {
                      setState(() {
                        currentTab = index;
                        currentPage = pages[index];
                      });
                      if (index == 2) {
                        setState(() {
                          notificationsCount = 0;
                        });
                      }
                    },
                    indicatorColor: Colors.transparent,
                    controller: controller,
                    isScrollable: false,
                    physics: NeverScrollableScrollPhysics(),
                    tabs: <Widget>[
                      Tab(icon: Icon(LineIcons.home)),
                      // Tab(icon: Icon(Icons.home_rounded)),
                      Tab(icon: Icon(LineIcons.calendar_o)),
                      //Tab(icon: Icon(Icons.calendar_today_outlined)),
                      Tab(icon: Icon(Icons.chat_outlined)),
                      Tab(
                        icon: IconBadge(
                          icon: Icon(LineIcons.bell),
                          // icon: Icon(Icons.notifications),
                          // itemCount: 4,
                          itemCount: notificationsCount,
                          badgeColor: Colors.blueGrey.withOpacity(0.9),
                          itemColor: Colors.white,
                          hideZero: true,
                          maxCount: 500,
                        ),
                      ),
                      Tab(icon: Icon(Icons.person_outline)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
