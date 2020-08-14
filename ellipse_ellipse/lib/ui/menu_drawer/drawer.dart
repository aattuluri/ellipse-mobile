import 'dart:async';
import 'dart:io';
import '../pages/edit_profile.dart';
import '../pages/post_event.dart';
import '../screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_list_item.dart';
import 'package:http/http.dart' as http;

class MenuDrawer extends StatefulWidget {
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  AnimationController _acountsettingsController;
  Animation<Offset> _accountsettingsOffsetFloat;
  bool _accountsettingsOpen;
  bool _contactsOpen;
  bool notNull(Object o) => o != null;

  String token = "", id = "", email = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  logout() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "$token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response =
        await http.get("http://192.168.43.215:4000/logout", headers: headers);
  }

  void _showDialoglogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure to logout"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {},
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () async {},
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getPref();
    super.initState();
    _accountsettingsOpen = false;
    // Setup animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    // For security menu
    _acountsettingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(1.1, 0), end: Offset(0, 0))
        .animate(_controller);
    _accountsettingsOffsetFloat =
        Tween<Offset>(begin: Offset(1.1, 0), end: Offset(0, 0))
            .animate(_acountsettingsController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _acountsettingsController.dispose();
    super.dispose();
  }

  Future<bool> _onBackButtonPressed() async {
    if (_contactsOpen) {
      setState(() {
        _contactsOpen = false;
      });
      _controller.reverse();
      return false;
    } else if (_accountsettingsOpen) {
      setState(() {
        _accountsettingsOpen = false;
      });
      _acountsettingsController.reverse();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Drawer in flutter doesn't have a built-in way to push/pop elements
    // on top of it like our Android counterpart. So we can override back button
    // presses and replace the main settings widget with contacts based on a bool
    return new WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: ClipRect(
        child: Stack(
          children: <Widget>[
            // Container(
            // color: CustomColors.primaryColor,
            // constraints: BoxConstraints.expand(),
            //),
            buildMainSettings(context),
            /*
            SlideTransition(
                position: _offsetFloat,
                child: ContactsList(_controller, _contactsOpen)),*/
            SlideTransition(
                position: _accountsettingsOffsetFloat,
                child: buildSecurityMenu(context)),
          ],
        ),
      ),
    );
  }

  Widget buildMainSettings(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: CustomColors.primaryColor,
          ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 15,
        ),
        child: Column(
          children: <Widget>[
            // A container for accounts area
            Container(
              margin:
                  EdgeInsetsDirectional.only(start: 26.0, end: 20, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Main Account
                      Container(
                        margin: EdgeInsetsDirectional.only(start: 4.0),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(

                                      /// color: CustomColors.container,
                                      width: 1.5),
                                ),
                                alignment: AlignmentDirectional(-1, 0),
                                // natricon
                                child: Container(
                                  child: Image.asset(
                                    "assets/g.png",
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  //highlightColor: CustomColors.primaryColor
                                  //.withOpacity(0.75),
                                  //splashColor:
                                  //CustomColors.container.withOpacity(0.75),
                                  padding: EdgeInsets.all(0.0),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // A row for other accounts and account switcher
                      Row(
                        children: <Widget>[
                          // Second Account
                          SizedBox(),
                          Container(
                            height: 36,
                            width: 36,
                            margin: EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder(),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                ////color: CustomColors.icon
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: FlatButton(
                      padding: EdgeInsets.all(4.0),
                      // highlightColor:
                      //CustomColors.primaryColor.withOpacity(0.75),
                      //splashColor: CustomColors.container.withOpacity(0.75),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Main account name
                          Container(
                            child: Text(
                              "Gunasekhar",
                              style: TextStyle(
                                fontFamily: "NunitoSans",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                //color: CustomColors.primaryTextColor,
                              ),
                            ),
                          ),
                          // Main account address
                          Container(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontFamily: "OverpassMono",
                                fontWeight: FontWeight.w100,
                                fontSize: 14.0,
                                //color: CustomColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Settings items
            Expanded(
                child: Stack(
              children: <Widget>[
                ListView(
                  padding: EdgeInsets.only(top: 15.0),
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsetsDirectional.only(start: 30.0, bottom: 10),
                      child: Text("Events",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            // color: CustomColors.primaryTextColor
                          )),
                    ),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(
                        context, "My Events", "10 Events", Icons.view_module,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(context,
                        "Registered Events", "20 Registered", Icons.assignment,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Post Event", Icons.add_a_photo,
                        onPressed: () {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => PostEvent(),
                      );
                      Navigator.of(context).push(route);
                    }),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Announcements", Icons.access_time,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: 30.0, top: 20.0, bottom: 10.0),
                      child: Text("Preferences",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            //color: CustomColors.primaryTextColor
                          )),
                    ),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(
                        context,
                        "Your College",
                        "VIT University,Vellore",
                        Icons.account_balance,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(
                        context, "Notifications", "yes", Icons.notifications,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(
                        context, "Theme", "Dark Theme", Icons.format_paint,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: 30.0, top: 20.0, bottom: 10.0),
                      child: Text("Other",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            //color: CustomColors.primaryTextColor
                          )),
                    ),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Account & Settings", Icons.settings,
                        onPressed: () {
                      setState(() {
                        _accountsettingsOpen = true;
                      });
                      _acountsettingsController.forward();
                    }),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "About Us", Icons.account_circle,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Help & Support", Icons.help,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Share Ellipse", Icons.share,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Logout", Icons.power_settings_new,
                        onPressed: () {
                      _showDialoglogout();
                    }),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("1.0.0", style: TextStyle()),
                          Text(" | ", style: TextStyle()),
                          GestureDetector(
                              onTap: () {},
                              child:
                                  Text("Privacy Policy", style: TextStyle())),
                          Text(" | ", style: TextStyle()),
                          GestureDetector(
                              onTap: () {},
                              child: Text("Terms and Conditions",
                                  style: TextStyle())),
                        ],
                      ),
                    ),
                  ].where(notNull).toList(),
                ),
                //List Top Gradient End
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 20.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          //CustomColors.primaryColor,
                          //CustomColors.primaryColor.withOpacity(0.1)
                        ],
                        begin: AlignmentDirectional(0.5, -1.0),
                        end: AlignmentDirectional(0.5, 1.0),
                      ),
                    ),
                  ),
                ), //List Top Gradient End
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget buildSecurityMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: CustomColors.primaryColor,
        boxShadow: [
          BoxShadow(
              //color: CustomColors.container,
              offset: Offset(-5, 0),
              blurRadius: 20),
        ],
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          top: 15,
        ),
        child: Column(
          children: <Widget>[
            // Back button and Security Text
            Container(
              margin: EdgeInsets.only(bottom: 10.0, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //Back button
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 10, left: 10),
                        child: FlatButton(
                            // highlightColor:
                            //CustomColors.primaryColor.withOpacity(0.75),
                            //splashColor:
                            //CustomColors.container.withOpacity(0.75),
                            onPressed: () {
                              setState(() {
                                _accountsettingsOpen = false;
                              });
                              _acountsettingsController.reverse();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios,
                                //color: CustomColors.icon,
                                size: 25)),
                      ),
                      //Security Header Text
                      Text(
                        "Account & Settings",
                        //style: AppStyles.textStyleSettingsHeader(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: <Widget>[
                ListView(
                  padding: EdgeInsets.only(top: 15.0),
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsetsDirectional.only(start: 30.0, bottom: 10),
                      child: Text("Preferences",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            //color: CustomColors.primaryTextColor
                          )),
                    ),
                    // Authentication Method
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "View Profile", Icons.visibility,
                        onPressed: () {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Edit Profile", Icons.edit, onPressed: () {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => EditProfile(),
                      );
                      Navigator.of(context).push(route);
                    }),

                    Divider(
                      height: 2,

                      ///color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Change Password", Icons.security,
                        onPressed: () async {}),
                    Divider(
                      height: 2,
                      //color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemSingleLine(
                        context, "Delete Account", Icons.delete,
                        onPressed: () async {}),
                    Divider(
                      height: 2,

                      /// color: CustomColors.icon.withOpacity(0.2),
                    ),
                    AppSettings.buildSettingsListItemDoubleLine(context,
                        "Logout of all devices", "3 Devices", Icons.lock,
                        onPressed: () {}),
                  ].where(notNull).toList(),
                ),
                //List Top Gradient End
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 20.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          //CustomColors.primaryColor,
                          //CustomColors.primaryColor.withOpacity(0.1)
                        ],
                        begin: AlignmentDirectional(0.5, -1.0),
                        end: AlignmentDirectional(0.5, 1.0),
                      ),
                    ),
                  ),
                ), //List Top Gradient End
              ],
            )),
          ],
        ),
      ),
    );
  }
}
