import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../providers/index.dart';

class EventSubmissions extends StatefulWidget {
  final String id;
  const EventSubmissions(this.id);

  @override
  _EventSubmissionsState createState() => _EventSubmissionsState();
}

class _EventSubmissionsState extends State<EventSubmissions>
    with TickerProviderStateMixin {
  loadSubmissions() async {}

  @override
  void initState() {
    loadPref();
    loadSubmissions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
