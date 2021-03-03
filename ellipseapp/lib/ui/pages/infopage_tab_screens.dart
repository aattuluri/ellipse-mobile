import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class Timeline extends StatefulWidget {
  final String id;
  const Timeline(this.id);
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with TickerProviderStateMixin {
  List<TimeLineListTile> timeLineTiles = [];
  @override
  void initState() {
    final Events _event = context.read<EventsRepository>().event(widget.id);
    loadPref();
    setState(() {
      timeLineTiles.add(TimeLineListTile(
          title: 'Event Registration Last Date',
          date: _event.regLastDate.toString().toDate(context)));
      timeLineTiles.add(TimeLineListTile(
          title: 'Event Start Date',
          date: _event.startTime.toString().toDate(context)));
      if (_event.rounds.isNotEmpty) {
        for (var i = 0; i < _event.rounds.length; i++) {

          timeLineTiles.add(TimeLineListTile(
              title: _event.rounds[i].title + ' Start Date',
              date: _event.rounds[i].startDate.toString().toDate(context)));
          timeLineTiles.add(TimeLineListTile(
              title: _event.rounds[i].title + ' End Date',
              date: _event.rounds[i].endDate.toString().toDate(context)));
        }
      } else {}

      timeLineTiles.add(TimeLineListTile(
          title: 'Event End Date',
          date: _event.finishTime.toString().toDate(context)));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event = context.watch<EventsRepository>().event(widget.id);
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: <Widget>[
        for (var i = 0; i < timeLineTiles.length; i++) ...[
          TimeLineTile(
              index: i,
              title: timeLineTiles[i].title,
              date: timeLineTiles[i].date,
              isFirst: i == 0,
              isLast: i == timeLineTiles.length - 1)
        ],
      ],
    );
  }
}

class Announcements extends StatefulWidget {
  final String id, type;
  const Announcements(this.id, this.type);
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
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_announcements?id=$event_id");
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
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/delete_announcement?id=$id&event_id=$eventId',
      jsonEncode(<String, dynamic>{}),
    );
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event = context.watch<EventsRepository>().event(widget.id);
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
            return data.isEmpty
                ? EmptyData(
                    'No Announcements',
                    " no announcements for ${_event.name}",
                    LineIcons.certificate)
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final _time = DateTime.parse(data[index].time);
                      return data[index].visible == false &&
                              _event.registered == false &&
                              !_event.admin
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
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
                                    width: 15.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data[index].title,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
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
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: InkWell(
                                              onTap: () {
                                                generalSheet(
                                                  context,
                                                  title: data[index].title,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      _item(
                                                        Icons.delete_outline,
                                                        "Delete",
                                                        () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          deleteAnnouncement(
                                                              data[index]
                                                                  .announcementId,
                                                              widget.id);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Icon(Icons.more_vert,
                                                  size: 25)),
                                        )
                                      : SizedBox.shrink()
                                ],
                              ),
                            );
                    });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return LoaderCircular("Loading");
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
  final String id;
  const AddAnnouncement(this.id);
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement>
    with TickerProviderStateMixin {
  String title = "", description = "";
  bool visible = false;

  add_announcements(String event_id, title, description, visible) async {
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/add_announcement',
      jsonEncode(<String, dynamic>{
        'event_id': '$event_id',
        'title': '$title',
        'description': '$description',
        'visible_all': visible
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
      messageDialog(context, "Announcement Added Successfully");
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event = context.watch<EventsRepository>().event(widget.id);
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
              RButton('Add', 13, () {
                add_announcements(widget.id, title, description, visible);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
