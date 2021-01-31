import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class Report extends StatefulWidget {
  final String type, id;
  const Report(this.type, this.id);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> with TickerProviderStateMixin {
  String title = "", description = "";
  bool visible = false;

  sendReport(String event_id, title, description) async {
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/report',
      jsonEncode(<String, dynamic>{
        'event_id': "${widget.id}",
        'title': '$title',
        'description': '$description'
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      flutterToast(context, 'Report Submitted', 1, ToastGravity.CENTER);
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
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
              //width: 200,
              // height: 50,
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
                  sendReport(widget.id, title, description);
                },
                color: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
