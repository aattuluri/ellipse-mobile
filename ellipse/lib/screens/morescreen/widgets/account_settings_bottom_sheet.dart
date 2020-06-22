import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/colors.dart';
import '../../../components/neumorphic_components/widgets.dart';
import '../../../components/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';
import '../../../components/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import '../../auth_screen.dart';

class AccountSettingsBottomSheet extends StatefulWidget {
  @override
  _AccountSettingsBottomSheetState createState() =>
      _AccountSettingsBottomSheetState();
}

class _AccountSettingsBottomSheetState
    extends State<AccountSettingsBottomSheet> {
  String token, id;
  SharedPreferences prefs;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
    });
  }

  logoutAll() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "$token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get("http://192.168.43.215:4000/logoutall",
        headers: headers);
  }

  void _showDialoglogoutall() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure to logout of all devices"),
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
                logoutAll();
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
    return Consumer<ThemeViewModel>(builder: (context, viewModel, _) {
      return Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          color: CustomColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 7),
            FlatButton(
              child: Icon(
                Icons.expand_more,
                color: CustomColors.icon,
                size: 60,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 5),
            Center(
              child: NeumorphicButton(
                onTap: () {},
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
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
                      SizedBox(width: 20),
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
            ),
            Center(
              child: NeumorphicButton(
                onTap: () {},
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
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
                        Icons.security,
                        color: CustomColors.icon,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Update Password",
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
            Center(
              child: NeumorphicButton(
                onTap: () {},
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
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
                        Icons.delete,
                        color: CustomColors.icon,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Delete Account",
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
            Center(
              child: NeumorphicButton(
                onTap: () {
                  _showDialoglogoutall();
                },
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
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
                        Icons.lock,
                        color: CustomColors.icon,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Logout of all devices",
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
      );
    });
  }
}
