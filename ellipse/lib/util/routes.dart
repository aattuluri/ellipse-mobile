import 'package:flutter/material.dart';

import '../ui/pages/index.dart';
import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const generalRoute = '/';
  static const splash_screen = '/splash_screeen';
  static const main_screen = '/main_screen';
  static const initialization = '/initialization';
  static const connection_error = '/connection_error';
  static const start = '/start';
  static const calendar_view = '/calendar_view';
  static const info_page = '/info_page';
  static const post_event = '/post_event';
  static const signin = '/signin';
  static const my_events = '/my_events';
  static const registered_events = '/registered_events';
  //static const my_events_info_page = '/my_events_info_page';
  static const edit_event = '/edit_event';
  static const edit_profile = '/edit_profile';
  static const view_profile = '/view_profile';
  static const change_password = '/change_password';
  static const about_us = '/about_us';
  static const help_support = '/help_support';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {
        case generalRoute:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Initialization(),
          );
        case main_screen:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MainScreen(),
          );
        case splash_screen:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SplashScreen(),
          );
        case initialization:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Initialization(),
          );
        case start:
          final current_tab = args['currebt_tab'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => StartScreen(current_tab),
          );
        case calendar_view:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CalendarTab(),
          );
        case info_page:
          final index = args['index'] as int;
          final type = args['type'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => InfoPage(index, type),
          );

        /* case my_events_info_page:
          final index = args['index'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MyEventsInfoPage(index),
          );
          */
        case post_event:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PostEvent(),
          );
        case signin:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Signin(),
          );
        case registered_events:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => RegisteredEvents(),
          );
        case my_events:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MyEvents(),
          );
        case edit_event:
          final index = args['index'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => EditEvent(index),
          );
        case edit_profile:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => EditProfile(),
          );
        case view_profile:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ViewProfile(),
          );
        case change_password:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ChangePassword(),
          );
        case about_us:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AboutUs(),
          );
        case help_support:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => HelpSupport(),
          );
        case connection_error:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ConnectionErrorScreen(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      //return errorRoute(routeSettings);
    }
  }

  /// Method that calles the error screen when neccesary
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ErrorScreen(),
    );
  }
}
