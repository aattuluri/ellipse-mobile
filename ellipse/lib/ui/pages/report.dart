import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../util/index.dart';

class Report extends StatefulWidget {
  final String type, id;
  const Report(this.type, this.id);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> with TickerProviderStateMixin {
  String title = "", description = "";
  bool visible = false;

  add_report(String event_id, title, description) async {
    http.Response response = await http.post(
      '${Url.URL}/api/event/report',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
      },
      body: jsonEncode(<String, dynamic>{
        'event_id': "${widget.id}",
        'title': '$title',
        'description': '$description'
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    loadPref();
    print(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (value) {
                    title = value;
                  },
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Description"),
                  maxLines: 7,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 50,
                  margin: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: Text(
                      'Report',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      add_report(widget.id, title, description);
                    },
                    color: Theme.of(context).cardColor,
                    textColor: Theme.of(context).textTheme.caption.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
