import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import '../../util/index.dart';
import '../widgets/index.dart';

class Participants extends StatefulWidget {
  final String event_id;
  Participants(this.event_id);
  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants>
    with TickerProviderStateMixin {
  bool expanded = false;
  bool isloading = false;
  List<dynamic> participants = [];
  loadRegisteredEvents() async {
    setState(() {
      isloading = true;
    });
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    String event_id = widget.event_id.trim().toString();
    var response = await http.get(
        "${Url.URL}/api/event/registeredEvents?id=$event_id",
        headers: headers);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        participants = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    loadPref();
    loadRegisteredEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  Text(
                    "Fetching Details....",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : participants.isEmpty
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: EmptyData('No Participants',
                    "No participants registered", LineIcons.users),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: participants.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data =
                                participants[index]['data'];
                            List<String> keys = data.keys.toList();
                            List<dynamic> values = data.values.toList();
                            return ExpansionTile(
                              initiallyExpanded: expanded ? true : false,
                              title: Text(
                                data["Name"],
                              ),
                              subtitle: Text(
                                data["Email"],
                              ),
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    for (var i = 0; i < keys.length; i++) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: RowText(
                                          keys[i].toString(),
                                          values[i].toString(),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
  }
}
