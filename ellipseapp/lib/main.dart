import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/index.dart';
import 'repositories/index.dart';
import 'util/index.dart';

void main() async {
  await sockets.connect();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/icons/loading.gif"), context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EventsRepository()),
        ChangeNotifierProvider(create: (_) => UserDetailsRepository()),
        ChangeNotifierProvider(create: (_) => NotificationsRepository()),
        ChangeNotifierProvider(create: (_) => DataRepository()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => LocalNotificationsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) => FeatureDiscovery(
          child: MaterialApp(
            title: 'Ellipse',
            theme: theme.requestTheme(Themes.light),
            darkTheme: theme.requestTheme(Themes.dark),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes.generateRoute,
            onUnknownRoute: Routes.errorRoute,
          ),
        ),
      ),
    );
  }
}
