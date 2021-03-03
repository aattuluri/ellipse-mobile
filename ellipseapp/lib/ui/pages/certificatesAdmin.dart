import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

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
  List<List<String>> pendingKeys = [];
  List<List<dynamic>> pendingValues = [];
  List<List<String>> publishedKeys = [];
  List<List<dynamic>> publishedValues = [];
  List<List<FilledData>> pendingFilledData = [];
  List<List<FilledData>> publishedFilledData = [];
  publish() async {
    String event_id = widget.event_id.trim().toString();

    print("Eventid");
    print("$event_id");
    setState(() {
      isloading = true;
    });
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/generate_certificates',
      jsonEncode(<String, dynamic>{
        'eventId': '$event_id',
        'participants': selectedParticipants,
      }),
    );
    if (response.statusCode == 200) {
      loadRegisteredEvents();
      Navigator.of(context).pop(true);
      messageDialog(context, "Certificates published Successfully");
    }
  }

  loadRegisteredEvents() async {
    final Events _event =
        context.read<EventsRepository>().event(widget.event_id);
    setState(() {
      isloading = true;
    });
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    String event_id = widget.event_id.trim().toString();
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/registeredEvents?id=$event_id");
    if (response.statusCode == 200) {
      setState(() {
        participants = json.decode(response.body);
      });
      List<Registrations> registrations = (json.decode(response.body) as List)
          .map((data) => Registrations.fromJson(data))
          .toList();
      for (var i = 0; i < registrations.length; i++) {
        if (registrations[i].certificateStatus == "not_generated") {
          this.setState(() => pendingFilledData
              .add(registrations[i].parseFilledData(_event.parseRegFields())));
        } else if (registrations[i].certificateStatus == "generated") {
          this.setState(() => publishedFilledData
              .add(registrations[i].parseFilledData(_event.parseRegFields())));
        } else {}
      }
      for (var i = 0; i < participants.length; i++) {
        if (participants[i]['certificate_status'] == "not_generated") {
          this.setState(() => pending.add(participants[i]));
        } else if (participants[i]['certificate_status'] == "generated") {
          this.setState(() => published.add(participants[i]));
        } else {}
      }
      for (var i = 0; i < pending.length; i++) {
        Map<String, dynamic> data = pending[i]['data'];
        setState(() {
          pendingKeys.add(data.keys.toList());
          pendingValues.add(data.values.toList());
        });
      }
      for (var i = 0; i < published.length; i++) {
        Map<String, dynamic> data = published[i]['data'];
        setState(() {
          publishedKeys.add(data.keys.toList());
          publishedValues.add(data.values.toList());
        });
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
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/update_certificate_title',
      jsonEncode(<dynamic, dynamic>{
        'eventId': id,
        'title': title,
      }),
    );
    if (response.statusCode == 200) {
      context.read<EventsRepository>().init();
      setState(() {
        isloading = false;
      });
      Navigator.of(context).pop(true);
      messageDialog(context, "Certificate details updated Successfully");
    }
  }

  @override
  void initState() {
    loadPref();
    tab_controller = new TabController(
      length: tabs.length,
      vsync: this,
    );
    loadRegisteredEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().event(widget.event_id);

    Map<String, dynamic> certificateDetails = _event.certificate;
    return isloading
        ? LoaderCircular("Loading")
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
                                    RButton(
                                      "Publish",
                                      10,
                                      selectedParticipants.isEmpty
                                          ? () {
                                              messageDialog(context,
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              /////////////////////////////////////////////////////////////////////////

                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 20.0,
                                    horizontalMargin: 15.0,
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Select',
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      for (var i = 0;
                                          i < pendingFilledData[0].length;
                                          i++) ...[
                                        DataColumn(
                                          label: Text(
                                            pendingFilledData[0][i]
                                                .key
                                                .toString(),
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                    rows: <DataRow>[
                                      for (var i = 0;
                                          i < pendingFilledData.length;
                                          i++) ...[
                                        DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  Map<String, dynamic> data =
                                                      pending[i]['data'];
                                                  String email = data["Email"]
                                                      .toString()
                                                      .trim();
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
                                                child: selectedParticipants
                                                        .contains(pending[i]
                                                                    ["data"]
                                                                ["Email"]
                                                            .toString())
                                                    ? Icon(
                                                        Icons.check_box,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color,
                                                      ),
                                              ),
                                            ),
                                            for (var j = 0;
                                                j < pendingFilledData[i].length;
                                                j++) ...[
                                              if (pendingFilledData[i][j]
                                                          .field ==
                                                      'file' &&
                                                  !pendingFilledData[i][j]
                                                      .value
                                                      .toString()
                                                      .isNullOrEmpty()) ...[
                                                DataCell(
                                                  RButton("open file", 10, () {
                                                    print(pendingFilledData[i]
                                                            [j]
                                                        .value
                                                        .toString());
                                                    "${Url.URL}/api/event/registration/get_file?id=${pendingFilledData[i][j].value.toString()}"
                                                        .launchUrl;
                                                  }),
                                                ),
                                              ] else ...[
                                                DataCell(
                                                  Text(
                                                    pendingFilledData[i][j].key=='Email'?"****************@gmail.com":pendingFilledData[i][j]
                                                            .value
                                                            .toString() ??
                                                        " ",
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),

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
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 20.0,
                                horizontalMargin: 15.0,
                                columns: <DataColumn>[
                                  for (var i = 0;
                                      i < publishedFilledData[0].length;
                                      i++) ...[
                                    DataColumn(
                                      label: Text(
                                        publishedFilledData[0][i]
                                            .key
                                            .toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  DataColumn(
                                    label: Text(
                                      'View\nCertificate',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: <DataRow>[
                                  for (var i = 0;
                                      i < publishedFilledData.length;
                                      i++) ...[
                                    DataRow(
                                      cells: <DataCell>[
                                        for (var j = 0;
                                            j < publishedFilledData[i].length;
                                            j++) ...[
                                          if (publishedFilledData[i][j].field ==
                                              'file' &&
                                              !publishedFilledData[i][j]
                                                  .value
                                                  .toString()
                                                  .isNullOrEmpty()) ...[
                                            DataCell(
                                              RButton("open file", 10, () {
                                                print(publishedFilledData[i][j]
                                                    .value
                                                    .toString());
                                                "${Url.URL}/api/event/registration/get_file?id=${publishedFilledData[i][j].value.toString()}"
                                                    .launchUrl;
                                              }),
                                            ),
                                          ] else ...[
                                            DataCell(
                                              Text(
                                                publishedFilledData[i][j].key=='Email'?"****************@gmail.com":publishedFilledData[i][j]
                                                        .value
                                                        .toString() ??
                                                    " ",
                                                maxLines: 2,
                                              ),
                                            ),
                                          ]
                                        ],
                                        DataCell(
                                          RaisedButton.icon(
                                            onPressed: () {
                                              String certUrl = published[i]
                                                      ['certificate_url']
                                                  .toString();
                                              Navigator.pushNamed(
                                                  context, Routes.pdfView,
                                                  arguments: {
                                                    'title': _event.name,
                                                    'link':
                                                        "${Url.URL}/api/user/certificate?id=$certUrl"
                                                  });
                                            },
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color,
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            label: Text(
                                              "View",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

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
                                      "https://gunasekhar0027.github.io/AppDocs/EllipseApp/certificate.png"
                                      //"https://staging.ellipseapp.com/static/media/certificate_sample.987b5a91.png"
                                      ),
                                  placeholder:
                                      AssetImage('assets/icons/loading.gif')),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RButton(
                            "Update",
                            13,
                            () {
                              updateCertDetails(_event.eventId,
                                  certTitle == "" ? _event.name : certTitle);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}
