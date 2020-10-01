import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  // String token = "", id = "", email = "";
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? SafeArea(
            child: Scaffold(
                body: Align(
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
          )))
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          onTap: () {
                            if (expanded) {
                              setState(() {
                                expanded = false;
                              });
                            } else if (!expanded) {
                              setState(() {
                                expanded = true;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                expanded
                                    ? Text(
                                        'Collapse All',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color),
                                      )
                                    : Text(
                                        'Expand All',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color),
                                      ),

                                SizedBox(
                                  width: 10,
                                ),
                                expanded
                                    ? Icon(
                                        Icons.arrow_upward,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      )
                                    : Icon(
                                        Icons.arrow_downward,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),


                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    */
                    participants.isEmpty
                        ? Container()
                        : ListView.builder(
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
            ),
          );
  }
}
