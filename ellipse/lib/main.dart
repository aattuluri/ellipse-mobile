import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/constants.dart' as Constants;
import 'components/view_models/main_view_model.dart';
import 'utils/service_locator.dart';
import 'components/view_models/settings_view_model.dart';
import 'components/view_models/theme_view_model.dart';
import 'screens/homescreen/home_screen.dart';
import 'components/colors.dart';
import 'screens/auth_screen.dart';

void main() {
  ServiceLocator.init();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  void preloadAssets(BuildContext context) {
    precacheImage(AssetImage('assets/g.png'), context);
    precacheImage(AssetImage('assets/1.jpeg'), context);
    precacheImage(AssetImage('assets/2.jpeg'), context);
  }

  @override
  Widget build(BuildContext context) {
    preloadAssets(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ServiceLocator.get<ThemeViewModel>()),
        ChangeNotifierProvider(
            create: (_) => ServiceLocator.get<SettingsViewModel>()),
        ChangeNotifierProvider(
            create: (_) => ServiceLocator.get<MainViewModel>()),
      ],
      child: MaterialApp(
        title: 'Ellipse',
        theme: ThemeData(
          dialogBackgroundColor: CustomColors.primaryColor,
          primaryColor: CustomColors.primaryColor,
          accentColor: CustomColors.primaryColor,
          //brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: Isloggedin(),
      ),
    );
  }
}

class Isloggedin extends StatefulWidget {
  @override
  State createState() {
    return IsloggedinState();
  }
}

class IsloggedinState extends State<Isloggedin> {
  Future loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool(Constants.LOGGED_IN) ?? false);
    if (loggedin) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new HomeScreen(),
      );
      Navigator.of(context).push(route);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new AuthScreen(),
      );
      Navigator.of(context).push(route);
    }
  }

  @override
  void initState() {
    super.initState();
    loggedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
