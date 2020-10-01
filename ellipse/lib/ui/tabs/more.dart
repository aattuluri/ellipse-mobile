import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../widgets/index.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({Key key}) : super(key: key);

  @override
  _MoreTabState createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> with TickerProviderStateMixin {
  Widget view;

  // Settings indexes
  ImageQuality _imageQualityIndex;
  Themes _themeIndex;
  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response =
        await http.post("${Url.URL}/api/users/logout", headers: headers);
    setState(() {
      preferences.setBool(Constants.CHECKED, false);
    });
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

  _onRefresh(BuildContext context, BaseRepository repository) {
    final Completer<void> completer = Completer<void>();

    repository.refreshData().then((_) {
      if (repository.loadingFailed) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Error"),
            action: SnackBarAction(
              label: "Error",
              onPressed: () => _onRefresh(context, repository),
            ),
          ),
        );
      }
      completer.complete();
    });

    return completer.future;
  }

  @override
  void initState() {
    loadPref();
    _themeIndex = context.read<ThemeProvider>().theme;
    _imageQualityIndex = context.read<ImageQualityProvider>().imageQuality;
    setState(() {
      view = buildMainView(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsRepository>(builder: (context, model, child) {
      return RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: SimplePage2(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: Particles(3)),
              SafeArea(
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                      /*
                      child: Center(
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                      */
                    ),
                    //Separator.divider(indent: 16),

                    view,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildMainView(BuildContext context) {
    return Consumer<UserDetailsRepository>(builder: (context, model, child) {
      final UserDetails _userdetails =
          context.watch<UserDetailsRepository>().getUserDetails(0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.view_profile);
              },
              child: Card(
                color: Theme.of(context).cardColor.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: Theme.of(context).textTheme.caption.color),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(540),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.view_profile);
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              child: FadeInImage(
                                image: NetworkImage(
                                    "${Url.URL}/api/image?id=${_userdetails.profile_pic}"),
                                placeholder:
                                    AssetImage('assets/icons/loading.gif'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            _userdetails.name,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          AutoSizeText(
                            _userdetails.email,
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                size: 20.0,
                              ),
                              SizedBox(width: 4.0),
                              AutoSizeText(
                                _userdetails.college_name,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 15,
            color: Colors.transparent,
          ),
          SettingsMainViewItem(Icons.calendar_today, 'Events', true, () {
            setState(() {
              view = buildEventView(context);
            });
          }),
          SettingsMainViewItem(Icons.person, 'Profile', true, () {
            Navigator.pushNamed(context, Routes.view_profile);
          }),
          SettingsMainViewItem(Icons.build, 'Preferences', true, () {
            setState(() {
              view = buildPreferencesView(context);
            });
          }),
          SettingsMainViewItem(Icons.settings, 'Account settings', true, () {
            setState(() {
              view = buildAccountSettingsView(context);
            });
          }),
          SettingsMainViewItem(Icons.apps, 'Other', true, () {
            setState(() {
              view = buildOtherView(context);
            });
          }),
          SettingsMainViewItem(Icons.power_settings_new, 'Logout', false, () {
            setState(() {
              _showDialoglogout();
            });
          }),
          SettingsMainViewItem(Icons.share, 'Share Ellipse', false, () {
            if (Platform.isAndroid) {
              Share.share(
                  "https://play.google.com/store/apps/details?id=com.guna0027.ellipse");
            } else if (Platform.isIOS) {}
          }),
          /*
          SettingsMainViewItem(Icons.info_outline, 'About Us', false, () {
            Navigator.pushNamed(context, Routes.about_us);
          }),
          */
        ],
      );
    });
  }

  Widget buildEventView(eventView) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BackButtonMore("Back", () {
          setState(() {
            view = buildMainView(context);
          });
        }),
        HeaderText("Events"),
        ListCell.icon(
          icon: Icons.add_a_photo,
          title: "Post Your Event",
          subtitle: "Post your posted events",
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, Routes.post_event);
          },
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.event_note,
          title: "Posted Events",
          subtitle: "View your posted events",
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, Routes.my_events);
          },
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.event_available,
          title: "Registered Events",
          subtitle: "View events you registered",
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, Routes.registered_events);
          },
        ),
      ],
    );
  }

  Widget buildPreferencesView(preferencesView) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButtonMore("Back", () {
            setState(() {
              view = buildMainView(context);
            });
          }),
          HeaderText("Preferences"),
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
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "On/Off",
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
            //=> SystemSetting.goto(SettingTarget.NOTIFICATION),
          ),
          /*
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
          */
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
                      /*
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
                      */
                    ],
                  )
                ],
              ),
            ),
          ),
        ]);
  }

  Widget buildAccountSettingsView(accountSettingsView) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButtonMore("Back", () {
            setState(() {
              view = buildMainView(context);
            });
          }),
          HeaderText("Account & Settings"),
          ListCell.icon(
              icon: Icons.security,
              title: "Change Password",
              subtitle: "*********",
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.change_password);
              }),
        ]);
  }

  Widget buildOtherView(otherView) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButtonMore("Back", () {
            setState(() {
              view = buildMainView(context);
            });
          }),
          HeaderText("Ellipse"),
          ListCell.icon(
              icon: Icons.public,
              title: "Our Website",
              subtitle: 'https://ellipseapp.com/',
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url: 'https://ellipseapp.com/',
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              }),
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.android,
              title: "Ellipse App",
              subtitle: 'Open in Playstore',
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url:
                      'https://play.google.com/store/apps/details?id=com.guna0027.ellipse',
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              }),
          /*
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.group,
              title: "Our Team",
              subtitle: 'ellipse team',
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.about_us);
              }),
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.code,
              title: "Built with Flutter",
              subtitle: 'https://flutter.dev',
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url: 'https://flutter.dev',
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              }),
          */
          HeaderText("Other"),
          ListCell.icon(
              icon: Icons.info_outline,
              title: "Privacy Policy",
              subtitle: "app privacy policy",
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url: 'https://ellipseapp.com/Privacy_Policy.pdf',
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              }),
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.web,
              title: "Terms and conditions",
              subtitle: "terms and conditions",
              //trailing: Icon(Icons.chevron_right),
              onTap: () {}),
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "get help & support",
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.help_support);
                // HelpSupport
                /*FlutterWebBrowser.openWebPage(
                url: 'mailto:gunasekhar158@gmail.com?subject=Feedback/Issue',
                androidToolbarColor: Theme.of(context).primaryColor,
              );*/
              }),
          Separator.divider(indent: 72),
          ListCell.icon(
              icon: Icons.star,
              title: "Rate Us",
              subtitle: "rate our app",
              //trailing: Icon(Icons.chevron_right),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url:
                      'https://play.google.com/store/apps/details?id=com.guna0027.ellipse',
                  androidToolbarColor: Theme.of(context).primaryColor,
                );
              }),
        ]);
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

class SettingsMainViewItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final Function onTap;
  const SettingsMainViewItem(
      this.icon, this.text, this.hasNavigation, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).cardColor.withOpacity(0.9),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                this.icon,
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Spacer(),
              if (this.hasNavigation)
                Icon(
                  Icons.chevron_right,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
