import 'package:flutter/material.dart';

import '../models/index.dart';
import '../ui/pages/index.dart';
import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const generalRoute = '/';
  static const intro = '/intro';
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
  static const mdDecode = '/mdDecode';
  static const widgetScreen = '/widgetScreen';

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
        case intro:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Intro(),
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
          final currentTab = args['currentTab'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => StartScreen(currentTab),
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
          final event_ = args['event_'] as Events;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => InfoPage(event_),
          );
        case post_event:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PostEvent(),
          );
        case signin:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SignIn(),
          );
        case registered_events:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => RegisteredEvents(),
          );
        case my_events:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PostedEvents(),
          );
        case certificates:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Certificates(),
          );
        case edit_event:
          final id = args['id'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => EditEvent(id),
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
            builder: (_) => About(),
          );
        case help_support:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => FeedbackApp(),
          );
        case connection_error:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ConnectionErrorScreen(),
          );
        case mdDecode:
          final title = args['title'] as String;
          final url = args['url'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MdDecode(title, url),
          );
        case widgetScreen:
          final title = args['title'] as String;
          final widget = args['widget'] as Widget;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => WidgetScreen(title, widget),
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
