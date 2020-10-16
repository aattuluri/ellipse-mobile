import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class Timeline extends StatefulWidget {
  final int index;
  final String id;
  const Timeline(this.index, this.id);
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with TickerProviderStateMixin {
  @override
  void initState() {
    loadPref();
    print(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvent(widget.index);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TimelineTile(
              axis: TimelineAxis.vertical,
              alignment: TimelineAlign.center,
              isFirst: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                padding: EdgeInsets.all(8),
              ),
              startChild: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Event Registration\nLast Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _event.reg_last_date.toString().toDate(context),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.center,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                padding: EdgeInsets.all(8),
              ),
              endChild: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Event Start Date",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _event.start_time.toString().toDate(context),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                padding: EdgeInsets.all(8),
              ),
              startChild: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Event End Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _event.finish_time.toString().toDate(context),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Announcements extends StatefulWidget {
  final int index;
  final String id, type;
  const Announcements(this.index, this.id, this.type);
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements>
    with TickerProviderStateMixin {
  Future<List<AnnouncementsModel>> _fetch_announcements() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
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

  deleteAnnouncement(String id, String eventId) async {
    http.Response response = await http.post(
      '${Url.URL}/api/event/delete_announcement?id=$id&event_id=$eventId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        _fetch_announcements();
      });
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    loadPref();
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder<List<AnnouncementsModel>>(
        future: _fetch_announcements(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AnnouncementsModel> announcements = snapshot.data;
            List<AnnouncementsModel> data = announcements;
            return ListView.builder(
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
                          child: Icon(Icons.speaker_notes, size: 23),
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
                                _time.toString().toDate(context),
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
                        widget.type == "admin"
                            ? Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: InkWell(
                                    onTap: () {
                                      generalSheet(
                                        context,
                                        title: data[index].title,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _item(
                                              Icons.delete_outline,
                                              "Delete",
                                              () {
                                                Navigator.of(context).pop(true);
                                                deleteAnnouncement(
                                                    data[index].id, widget.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.more_vert, size: 25)),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return LoaderCircular(0.4);
        },
      ),
    );
  }

  Widget _item(IconData icon, String name, Function onTap) => ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        leading: Icon(
          icon,
        ),
        title: Text(
          name,
          maxLines: 1,
        ),
      );
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

  add_announcements(String event_id, title, description, visible) async {
    http.Response response = await http.post(
      '${Url.URL}/api/event/add_announcement',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
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
      Navigator.pushReplacementNamed(context, Routes.info_page,
          arguments: {'index': widget.index, 'type': 'admin'});
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    loadPref();
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
        context.watch<EventsRepository>().getEvent(widget.index);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
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
  @override
  void initState() {
    loadPref();
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
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
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
