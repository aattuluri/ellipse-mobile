import 'package:flutter/material.dart';

import '../ui/pages/index.dart';
import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const generalRoute = '/';
  static const splash_screen = '/splash_screeen';
  static const initialization = '/initialization';
  static const connection_error = '/connection_error';
  static const start = '/start';
  static const settings = '/settings';
  static const calendar_view = '/calendar_view';
  static const info_page = '/info_page';
  static const post_event = '/post_event';
  static const signin = '/signin';
  static const my_events = '/my_events';
  static const certificates = '/certificates';
  static const registered_events = '/registered_events';
  static const edit_event = '/edit_event';
  static const edit_profile = '/edit_profile';
  static const view_profile = '/view_profile';
  static const pdfView = '/pdfView';
  static const change_password = '/change_password';
  static const about_us = '/about_us';
  static const help_support = '/help_support';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    Animation<double> animation;
    try {
      final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {
        case generalRoute:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Initialization(),
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
          final current_tab = args['current_tab'] as int;
          final load = args['load'] as bool;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => StartScreen(current_tab, load),
          );
        case settings:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Settings(),
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
        case certificates:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Certificates(),
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
        case pdfView:
          final title = args['title'] as String;
          final link = args['link'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PdfView(title, link),
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
