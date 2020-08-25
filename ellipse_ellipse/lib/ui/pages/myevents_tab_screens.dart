import 'dart:io';
import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../util/index.dart';

class Announcements extends StatefulWidget {
  final int index;
  final String id;
  const Announcements(this.index, this.id);
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements>
    with TickerProviderStateMixin {
  String token = "", id = "", email = "", college = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  Future<List<AnnouncementsModel>> _fetch_announcements() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    String event_id = widget.id.trim().toString();
    var response = await http.get(
        "${Url.URL}/api/event/get_announcements?id=$event_id",
        headers: headers);
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse
          .map((announcement) => new AnnouncementsModel.fromJson(announcement))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    getPref();
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnnouncementsModel>>(
        future: _fetch_announcements(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AnnouncementsModel> data = snapshot.data;
            return ListView.builder(
                reverse: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final _time = DateTime.parse(data[index].time);
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          child: Icon(Icons.speaker_phone, size: 23),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                data[index].description,
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                    .format(_time),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'ProductSans',
                                  //color: Tools.multiColors[Random().nextInt(5)]
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                              onTap: () {},
                              child: Icon(Icons.more_vert, size: 25)),
                        )
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: CircularProgressIndicator()));
        },
      ),
    );
  }
}

class AddAnnouncement extends StatefulWidget {
  final int index;
  final String id;
  const AddAnnouncement(this.index, this.id);
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement>
    with TickerProviderStateMixin {
  String title = "", description = "";
  bool visible = false;
  String token = "", id = "", email = "", college = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  add_announcements(String event_id, title, description, visible) async {
    http.Response response = await http.post(
      '${Url.URL}/api/event/add_announcement',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'event_id': '$event_id',
        'title': '$title',
        'description': '$description',
        'visible_all': visible
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        Routes.my_events_info_page,
        arguments: {'index': widget.index},
      );
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    getPref();
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEventIndex(widget.index);
    return Scaffold(
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
              Row(children: <Widget>[
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    hoverColor: Theme.of(context).primaryColor,
                    focusColor: Theme.of(context).primaryColor,
                    value: visible,
                    onChanged: (value) {
                      setState(() {
                        visible = value;
                      });
                    },
                    activeColor: Theme.of(context)
                        .textTheme
                        .caption
                        .color
                        .withOpacity(0.2),
                    checkColor: Theme.of(context).textTheme.caption.color,
                    tristate: false,
                  ),
                ),
                Text(
                  'Visible to all(for non-registered users also)',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.9)),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    add_announcements(widget.id, title, description, visible);
                  },
                  color: Theme.of(context).cardColor,
                  textColor: Theme.of(context).textTheme.caption.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisteredParticipants extends StatefulWidget {
  final int index;

  const RegisteredParticipants(this.index);
  @override
  _RegisteredParticipantsState createState() => _RegisteredParticipantsState();
}

class _RegisteredParticipantsState extends State<RegisteredParticipants>
    with TickerProviderStateMixin {
  String token = "", id = "", email = "", college = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    getPref();
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          //height: 120.0,
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.caption.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Container(
                child: Icon(Icons.speaker_phone, size: 23),
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Event Start Time",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "July 20,2020 ggggggg grdddddddddddd edd essssssssssssssss esrrrrrrrrrrr ershhhhhhhhhhhhh",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: 50,
    );
  }
}
