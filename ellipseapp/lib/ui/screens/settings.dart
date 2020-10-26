import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _MoreTabState createState() => _MoreTabState();
}

class _MoreTabState extends State<Settings> with TickerProviderStateMixin {
  Widget view;

  // Settings indexes
  Themes _themeIndex;
  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response =
        await http.post("${Url.URL}/api/users/logout", headers: headers);
  }

  void _showDialoglogout() {
    generalDialog(
      context,
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
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

            resetPref();
            //Navigator.pushNamed(context, Routes.intro);
            Navigator.pushNamed(context, Routes.signin);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    loadPref();
    _themeIndex = context.read<ThemeProvider>().theme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsRepository>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 5,
          title: Text(
            "Settings",
            style: TextStyle(color: Theme.of(context).textTheme.caption.color),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            HeaderText("Preferences"),

            /* ListCell.icon(
                icon: Icons.autorenew,
                title: "Refresh",
                subtitle: "refresh data",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {
                  context.read<UserDetailsRepository>().refreshData();
                  context.read<EventsRepository>().refreshData();
                  context.read<NotificationsRepository>().refreshData();
                  context.read<DataRepository>().refreshData();

                  //alertDialog(context, "Refresh", "Data Refreshed");
                }),
            Separator.divider(indent: 72),*/
            ListCell.icon(
              icon: Icons.palette,
              title: "Theme",
              subtitle: "choose app theme",
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
            HeaderText("My Account"),
            ListCell.icon(
                icon: Icons.edit,
                title: "Edit Profile",
                subtitle: "edit your profile",
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.edit_profile);
                }),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.security,
                title: "Change Password",
                subtitle: "*********",
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.change_password);
                }),
            HeaderText("Other"),
            ListCell.icon(
                icon: Icons.message,
                title: "Feedback",
                subtitle: "send feedback",
                onTap: () {
                  generalSheet(
                    context,
                    title: "Feedback",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _feedbackItem(Icons.message, "Give Feedback", () {
                          Navigator.pushNamed(context, Routes.help_support);
                        }),
                        Divider(height: 1),
                        _feedbackItem(LineIcons.whatsapp, "Join Whatsapp", () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'https://chat.whatsapp.com/FO8wG0wtNJCCHCdjDIrwIf',
                          );
                        }),
                        Divider(height: 1),
                        _feedbackItem(Icons.mail_outline, "Mail Us", () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'mailto:support@ellipseapp.com?subject=Feedback',
                          );
                        }),
                        Divider(height: 1),
                        _feedbackItem(LineIcons.star_o, "Rate on Play Store",
                            () {
                          FlutterWebBrowser.openWebPage(
                            url:
                                'https://play.google.com/store/apps/details?id=com.guna0027.ellipse',
                          );
                        }),
                        Divider(height: 1),
                      ],
                    ),
                  );
                }),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.account_circle,
                title: "About",
                subtitle: "Ellipse",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.about_us);
                }),
            Separator.divider(indent: 72),
            ListCell.icon(
                icon: Icons.share,
                title: "Share",
                subtitle: "share our app",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Share.share(
                      "https://play.google.com/store/apps/details?id=com.guna0027.ellipse");
                }),
            ListCell.icon(
                icon: Icons.integration_instructions_rounded,
                title: "App Intro",
                subtitle: "app introduction",
                //trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, Routes.intro);
                }),
            Center(
              child: OutlineButton(
                onPressed: () {
                  setState(() {
                    _showDialoglogout();
                  });
                },
                child: Text(
                  "Logout",
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            /*ListCell.icon(
                icon: Icons.share,
                title: "Test",
                subtitle: "Test",
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TestScreen()));
                }),
            */
          ],
        ),
      );
    });
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

  Widget _feedbackItem(IconData icon, String name, Function onTap) => ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        leading: Icon(
          icon,
        ),
        title: Text(
          name,
          maxLines: 1,
        ),
      );
}
