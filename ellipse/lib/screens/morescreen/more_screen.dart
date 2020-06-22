import 'dart:convert';
import 'dart:io';

import '../auth_screen.dart';
import 'widgets/account_settings_bottom_sheet.dart';
import '../../walkthrough.dart';
import '../../components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/preferences_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/colors.dart';
import 'package:http/http.dart' as http;
import '../../components/constants.dart' as Constants;
import '../../components/neumorphic_components/widgets.dart';
import '../../components/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String token = "", id = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () async {
                logout();
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                setState(() {
                  sharedPreferences.setString("token", "");
                  sharedPreferences.setString("id", "");
                  sharedPreferences.setBool(Constants.LOGGED_IN, false);
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new Signin(),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Container(
        color: CustomColors.primaryColor,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: SafeArea(
              child: SizedBox(height: 20),
            ),
          ),
          backgroundColor: CustomColors.primaryColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                offset: Offset(0, 4.0),
                                color: Colors.black38),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/g.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Gunasekhar",
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 23.0,
                                color: CustomColors.primaryTextColor),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            id,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: TextStyle(
                                color: CustomColors.primaryTextColor,
                                fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          NeumorphicButton(
                            onTap: () {},
                            width: 170,
                            height: 50,
                            margin: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              right: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: CustomColors.icon,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: CustomColors.primaryTextColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: NeumorphicButton(
                    onTap: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AccountSettingsBottomSheet();
                          });
                    },
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: CustomColors.icon,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Account & Settings",
                            style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: CustomColors.icon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: NeumorphicButton(
                    onTap: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return PreferencesBottomSheet();
                          });
                    },
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.settings,
                            color: CustomColors.icon,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Preferences",
                            style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: CustomColors.icon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: NeumorphicButton(
                    onTap: () {},
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.help,
                            color: CustomColors.icon,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Help & Support",
                            style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: CustomColors.icon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: NeumorphicButton(
                    onTap: () {
                      _showDialoglogout();
                    },
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.power_settings_new,
                            color: CustomColors.icon,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
