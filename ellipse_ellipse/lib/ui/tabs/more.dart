import 'package:ellipseellipse/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';
import 'package:http/http.dart' as http;
import '../pages/index.dart';

/// Here lays all available options for the user to configurate.
class MoreTab extends StatefulWidget {
  const MoreTab({Key key}) : super(key: key);

  @override
  _MoreTabState createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  String token = "", id = "", email = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  // Settings indexes
  ImageQuality _imageQualityIndex;
  Themes _themeIndex;
  logout() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response =
        await http.post("${Url.URL}/api/users/logout", headers: headers);
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
                  sharedPreferences.setString("email", "");
                  sharedPreferences.setBool(Constants.LOGGED_IN, false);
                });
                Navigator.pushNamed(context, Routes.signin);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getPref();
    // Get the app theme & image quality from the 'AppModel' model.
    _themeIndex = context.read<ThemeProvider>().theme;
    _imageQualityIndex = context.read<ImageQualityProvider>().imageQuality;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SimplePage2(
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 15, bottom: 0),
              child: Center(
                child: Text(
                  'More',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
            ),
            Separator.divider(indent: 16),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.view_profile);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 5),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20.0),
                    Container(
                        width: 80.0,
                        height: 80.0,
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                                radius: 35.0,
                                backgroundImage: AssetImage("assets/g.png")))),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Gunasekhar",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Text(email),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_balance,
                              size: 20.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              "VIT University,Vellore",
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            HeaderText("General"),
            ListCell.icon(
              icon: Icons.palette,
              title: "Theme",
              subtitle: "choose between light and dark",
              trailing: Icon(Icons.chevron_right),
              onTap: () => showDialog(
                context: context,
                builder: (context) => RoundDialog(
                  title: "Theme",
                  children: <Widget>[
                    RadioCell<Themes>(
                      title: "Dark theme",
                      groupValue: _themeIndex,
                      value: Themes.dark,
                      onChanged: (value) => _changeTheme(value),
                    ),
                    RadioCell<Themes>(
                      title: "Black theme",
                      groupValue: _themeIndex,
                      value: Themes.black,
                      onChanged: (value) => _changeTheme(value),
                    ),
                    RadioCell<Themes>(
                      title: "Light theme",
                      groupValue: _themeIndex,
                      value: Themes.light,
                      onChanged: (value) => _changeTheme(value),
                    ),
                    RadioCell<Themes>(
                      title: "System theme",
                      groupValue: _themeIndex,
                      value: Themes.system,
                      onChanged: (value) => _changeTheme(value),
                    ),
                  ],
                ),
              ),
            ),
            Separator.divider(indent: 72),
            ListCell.icon(
              icon: Icons.photo_filter,
              title: "Image Quality",
              subtitle: "Adjust image quality",
              trailing: Icon(Icons.chevron_right),
              onTap: () => showDialog(
                context: context,
                builder: (_) => RoundDialog(
                  title: "Image Quality",
                  children: <Widget>[
                    RadioCell<ImageQuality>(
                      title: 'Low',
                      groupValue: _imageQualityIndex,
                      value: ImageQuality.low,
                      onChanged: (value) => _changeImageQuality(value),
                    ),
                    RadioCell<ImageQuality>(
                      title: "Medium",
                      groupValue: _imageQualityIndex,
                      value: ImageQuality.medium,
                      onChanged: (value) => _changeImageQuality(value),
                    ),
                    RadioCell<ImageQuality>(
                      title: "High",
                      groupValue: _imageQualityIndex,
                      value: ImageQuality.high,
                      onChanged: (value) => _changeImageQuality(value),
                    ),
                  ],
                ),
              ),
            ),
            Separator.divider(indent: 72),
            ListCell.icon(
              icon: Icons.account_balance,
              title: "Your College",
              subtitle: "VIT University,Vellore",
              trailing: Icon(Icons.chevron_right),
              onTap: () => showDialog(
                context: context,
                builder: (_) => RoundDialog(
                  title: "Your College",
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.account_balance,
                              size: 21.0,
                            ),
                            SizedBox(width: 6.0),
                            Text(
                              "VIT University,Vellore",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 40.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Text(
                                "Change College",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            HeaderText("Services"),
            ListCell.icon(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "On/Off",
              trailing: Icon(Icons.chevron_right),
              onTap: () => SystemSetting.goto(SettingTarget.NOTIFICATION),
            ),
            Separator.divider(indent: 72),
            HeaderText("Account & Settings"),
            ListCell.icon(
              icon: Icons.account_circle,
              title: "View Profile",
              subtitle: "Gunasekhar",
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, Routes.view_profile),
            ),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.security,
                title: "Change Password",
                subtitle: "*********",
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.change_password);
                }),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.power_settings_new,
                title: "Logout",
                subtitle: "Logout from your account",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {
                  _showDialoglogout();
                }),
            HeaderText("Other"),
            ListCell.icon(
                icon: Icons.web,
                title: "Terms and conditions",
                subtitle: "terms and conditions",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {}),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.help,
                title: "Help & Support",
                subtitle: "get help",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {}),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.account_circle,
                title: "About Us",
                subtitle: "about us",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {}),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.share,
                title: "Share Ellipse",
                subtitle: "get help",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {}),
            Separator.divider(indent: 72),
          ],
        ),
      ),
    );
  }

  // Updates app's theme
  Future<void> _changeTheme(Themes theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<ThemeProvider>().theme = theme;
    prefs.setInt('theme', theme.index);

    // Updates UI
    setState(() => _themeIndex = theme);

    // Hides dialog
    Navigator.of(context).pop();
  }

  // Updates image quality setting
  Future<void> _changeImageQuality(ImageQuality quality) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<ImageQualityProvider>().imageQuality = quality;
    prefs.setInt('quality', quality.index);

    // Updates UI
    setState(() => _imageQualityIndex = quality);

    // Hides dialog
    Navigator.of(context).pop();
  }
}
