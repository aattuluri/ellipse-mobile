import 'ui/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/constants.dart' as Constants;
import 'util/routes.dart';
import 'ui/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'repositories/index.dart';

void main() => runApp(App());

/// Builds the neccesary providers, as well as the home page.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ImageQualityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => EventsRepository()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) => MaterialApp(
          title: 'Ellipse',
          theme: theme.requestTheme(Themes.light),
          darkTheme: theme.requestTheme(Themes.dark),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.generateRoute,
          onUnknownRoute: Routes.errorRoute,
        ),
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
      Navigator.pushNamed(context, Routes.start);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new AuthScreen(),
      );
      Navigator.of(context).push(route);
    }
  }

  @override
  void initState() {
    loggedin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
