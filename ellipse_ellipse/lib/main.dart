import 'package:flutter/services.dart';

import 'ui/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/constants.dart' as Constants;
import 'util/routes.dart';
import 'ui/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'repositories/index.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App());
}

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
        ChangeNotifierProvider(create: (_) => UserDetailsRepository()),
        ChangeNotifierProvider(create: (_) => NotificationsRepository()),
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
