import 'dart:convert';
import 'dart:io';

import 'package:Ellipse/ui/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import '../../util/index.dart';
import '../widgets/index.dart';

class IconTab {
  IconTab({
    this.name,
    this.icon,
  });

  final String name;
  final IconData icon;
}

class CertificatesAdmin extends StatefulWidget {
  final String event_id;
  CertificatesAdmin(this.event_id);
  @override
  _CertificatesAdminState createState() => _CertificatesAdminState();
}

class _CertificatesAdminState extends State<CertificatesAdmin>
    with TickerProviderStateMixin {
  final List tabs = [
    IconTab(name: "Pending", icon: Icons.pending),
    IconTab(name: "Published", icon: Icons.publish),
  ];
  TabController tab_controller;
  bool expanded = false;
  bool selectAll = false;
  bool isloading = false;
  List<dynamic> participants = [];
  List<dynamic> pending = [];
  List<dynamic> published = [];
  List<String> selectedParticipants = [];
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
      for (var i = 0; i < participants.length; i++) {
        Map<String, dynamic> data = participants[i]['data'];
        if (participants[i]['certificate_status'] == "not_generated") {
          pending.add(participants[i]);
        } else if (participants[i]['certificate_status'] == "generated") {
          published.add(participants[i]);
        } else {}
      }
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
  }

  publish() async {
    String event_id = widget.event_id.trim().toString();
    if (selectedParticipants.isEmpty) {
      alertDialog(context, "Publish", "Participants not selected");
    } else {
      print("Eventid");
      print("$event_id");
      setState(() {
        isloading = true;
      });
      http.Response response = await http.post(
        '${Url.URL}/api/event/generate_certificates',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefToken'
        },
        body: jsonEncode(<String, dynamic>{
          'eventId': '$event_id',
          'participants': selectedParticipants,
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        this.setState(() => participants.clear());
        this.setState(() => pending.clear());
        this.setState(() => published.clear());
        loadRegisteredEvents();
      }
    }
  }

  @override
  void initState() {
    loadPref();
    tab_controller = new TabController(
      length: 2,
      vsync: this,
    );
    loadRegisteredEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? LoaderCircular(0.4)
        : participants.isEmpty
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: EmptyData(
                    'No Participants\nRegistered', "", LineIcons.users),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: false,
                  flexibleSpace: TabBar(
                    onTap: (tab) {},
                    controller: tab_controller,
                    //isScrollable: true,
                    tabs: tabs.map((tab) {
                      return Tab(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tab.icon,
                              size: 18,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                tab.name,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tab_controller,
                  children: <Widget>[
                    ////////////////////////////////////////////Tab 1//////////////////////////////////////////
                    pending.isEmpty
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: EmptyData(
                                'No Pending',
                                "No pending certificates",
                                LineIcons.certificate),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (selectAll) {
                                          this.setState(() =>
                                              selectedParticipants.clear());
                                          setState(() {
                                            selectAll = false;
                                          });
                                        } else {
                                          for (var i = 0;
                                              i < pending.length;
                                              i++) {
                                            Map<String, dynamic> data =
                                                pending[i]['data'];
                                            String email =
                                                data["Email"].toString().trim();
                                            String id = pending[i]['user_id'];
                                            this.setState(() =>
                                                selectedParticipants
                                                    .add(email));
                                          }
                                          setState(() {
                                            selectAll = true;
                                          });
                                        }
                                        print(selectedParticipants);
                                      },
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          selectAll
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .color,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .color,
                                                ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Select All",
                                          ),
                                        ],
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text("Publish"),
                                      onPressed: () {
                                        setState(() {
                                          selectAll = false;
                                        });
                                        publish();
                                      },
                                      textColor: Colors.black,
                                      color: Theme.of(context).accentColor,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: pending.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map<String, dynamic> data =
                                        pending[index]['data'];
                                    List<String> keys = data.keys.toList();
                                    List<dynamic> values = data.values.toList();
                                    return ExpansionTile(
                                      initiallyExpanded:
                                          expanded ? true : false,
                                      leading: InkWell(
                                        onTap: () {
                                          String id = pending[index]['user_id'];
                                          String email =
                                              data["Email"].toString().trim();
                                          if (selectedParticipants
                                              .contains(email)) {
                                            this.setState(() =>
                                                selectedParticipants
                                                    .remove(email));
                                          } else {
                                            this.setState(() =>
                                                selectedParticipants
                                                    .add(email));
                                          }
                                          print(selectedParticipants);
                                        },
                                        child: selectedParticipants.contains(
                                                data["Email"].toString())
                                            ? Icon(
                                                Icons.check_box,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color,
                                              ),
                                      ),
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
                                            for (var i = 0;
                                                i < keys.length;
                                                i++) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                    ////////////////////////////////Tab 2//////////////////////////////////////
                    published.isEmpty
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: EmptyData(
                                'No Published',
                                "No published certificates",
                                LineIcons.certificate),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: published.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> data =
                                  published[index]['data'];
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
                  ],
                ),
              );
  }
}
