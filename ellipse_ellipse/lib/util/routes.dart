import 'package:ellipseellipse/ui/pages/post_event.dart';
import 'package:ellipseellipse/ui/screens/auth_screen.dart';

import '../ui/tabs/index.dart';
import 'package:flutter/material.dart';
import '../ui/pages/index.dart';
import '../ui/screens/index.dart';
import '../main.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const isloggedin = '/';
  static const start = '/start';
  static const calendar_view = '/calendar_view';
  static const info_page = '/info_page';
  static const post_event = '/post_event';
  static const signin = '/signin';
  static const my_events = '/my_events';
  static const my_events_info_page = '/my_events_info_page';
  static const edit_event = '/edit_event';
  static const edit_profile = '/edit_profile';
  static const view_profile = '/view_profile';
  static const change_password = '/change_password';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {
        case isloggedin:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Isloggedin(),
          );
        case start:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => StartScreen(),
          );
        case calendar_view:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CalendarView(),
          );
        case info_page:
          final index = args['index'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => InfoPage(index),
          );
        case my_events_info_page:
          final index = args['index'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MyEventsInfoPage(index),
          );
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
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
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
