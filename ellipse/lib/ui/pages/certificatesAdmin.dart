import 'dart:convert';
import 'dart:io';

import 'package:Ellipse/ui/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
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
    IconTab(name: "Dashboard", icon: Icons.dashboard),
  ];
  String certTitle = "";
  TabController tab_controller;
  bool expanded = false;
  bool selectAll = false;
  bool isloading = false;
  List<dynamic> participants = [];
  List<dynamic> pending = [];
  List<dynamic> published = [];
  List<String> selectedParticipants = [];

  publish() async {
    String event_id = widget.event_id.trim().toString();

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
      //this.setState(() => participants.clear());
      //this.setState(() => pending.clear());
      //this.setState(() => published.clear());
      loadRegisteredEvents();
      Navigator.of(context).pop(true);
      alertDialog(
          context, "Certificates", "Certificates published Successfully");
    }
  }

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
          this.setState(() => pending.add(participants[i]));
        } else if (participants[i]['certificate_status'] == "generated") {
          this.setState(() => published.add(participants[i]));
        } else {}
      }
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
  }

  updateCertDetails(String id, String title) async {
    setState(() {
      isloading = true;
    });
    http.Response response = await http.post(
      '${Url.URL}/api/event/update_certificate_title',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
      },
      body: jsonEncode(<dynamic, dynamic>{
        'eventId': id,
        'title': title,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      context.read<EventsRepository>().refreshData();
      setState(() {
        isloading = false;
      });
      //tab_controller.animateTo(0);
      Navigator.of(context).pop(true);
      alertDialog(
          context, "Certificates", "Certificate details updated Successfully");
    }
  }

  @override
  void initState() {
    loadPref();
    tab_controller = new TabController(
      length: 3,
      vsync: this,
    );
    loadRegisteredEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventIndex =
        context.watch<EventsRepository>().getEventIndex(widget.event_id);
    final Events _event =
        context.watch<EventsRepository>().getEvent(eventIndex);

    Map<String, dynamic> certificateDetails = _event.certificate;
    return isloading
        ? LoaderCircular(0.25, "Loading")
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
                    isScrollable: true,
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
                                      onPressed: selectedParticipants.isEmpty
                                          ? () {
                                              alertDialog(context, "Publish",
                                                  "Participants not selected");
                                            }
                                          : () {
                                              setState(() {
                                                selectAll = false;
                                                participants = [];
                                                pending = [];
                                                published = [];
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
                              String certUrl = published[index]
                                      ['certificate_url']
                                  .toString();
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
                                      ],
                                      RaisedButton.icon(
                                        onPressed: () {
                                          "${Url.URL}/api/user/certificate?id=$certUrl"
                                              .launchUrl;
/*
                      Navigator.pushNamed(context, Routes.pdfView,
                          arguments: {
                            'title': "heh",
                            'link':
                                "${Url.URL}/api/image?id=${model.allRegistrations[index].certificateUrl.toString()}"
                          });*/
                                        },
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                        icon: Icon(
                                          LineIcons.download,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        label: Text(
                                          "Download",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            }),
                    ////////////////////////////////Tab 3//////////////////////////////////////

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Title",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                certTitle = value;
                              });
                            },
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
                            decoration: InputDecoration(
                                hintText: certificateDetails['title'],
                                border: OutlineInputBorder(),
                                labelText: certificateDetails['title']),
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FadeInImage(
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration(milliseconds: 1000),
                                  image: NetworkImage(
                                      "https://staging.ellipseapp.com/static/media/certificate_sample.987b5a91.png"),
                                  placeholder:
                                      AssetImage('assets/icons/loading.gif')),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: OutlineButton(
                              onPressed: () {
                                updateCertDetails(_event.id,
                                    certTitle == "" ? _event.name : certTitle);
                              },
                              child: Text(
                                "Update",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}
