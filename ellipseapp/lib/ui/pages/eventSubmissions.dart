import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../providers/index.dart';
import '../../util/index.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../widgets/index.dart';

class EventSubmissions extends StatefulWidget {
  final String id;
  const EventSubmissions(this.id);

  @override
  _EventSubmissionsState createState() => _EventSubmissionsState();
}

class _EventSubmissionsState extends State<EventSubmissions>
    with TickerProviderStateMixin {
  bool isLoading = false;
  List<List<SubmissionModel>> submissionDetails = [];
  List<String> submissionsTitle = [];
  List<String> registrationOrTeamIds = [];
  List<String> userIds = [];
  List<Registrations> registrations = [];
  List<Teams> teams = [];
  loadSubmissions() async {
    setState(() {
      submissionDetails = [];
      submissionsTitle = [];
      registrations = [];
      teams = [];
      userIds = [];
      registrationOrTeamIds = [];
    });
    final Events _event = context.read<EventsRepository>().event(widget.id);
    String eventId = widget.id;
    setState(() {
      isLoading = true;
    });
    if (_event.isTeamed) {
      var response = await httpGetWithHeaders(
          "${Url.URL}/api/event/get_all_teams?id=$eventId");
      if (response.statusCode == 200) {
        setState(() {
          teams = (json.decode(response.body) as List)
              .map((data) => Teams.fromJson(data))
              .toList();
        });
        for (var i = 0; i < teams.length; i++) {
          setState(() {
            submissionDetails.add(teams[i].submissions);
            submissionsTitle.add(teams[i].name);
            registrationOrTeamIds.add(teams[i].teamId);
            userIds.add(teams[i].userId);
          });
          print(submissionDetails);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      var response = await httpGetWithHeaders(
          "${Url.URL}/api/event/registeredEvents?id=$eventId");
      if (response.statusCode == 200) {
        setState(() {
          registrations = (json.decode(response.body) as List)
              .map((data) => Registrations.fromJson(data))
              .toList();
        });

        for (var i = 0; i < registrations.length; i++) {
          var response2 = await httpGetWithHeaders(
              "${Url.URL}/api/event/get_team_member_details?id=${registrations[i].userId}");
          if (response2.statusCode == 200) {
            Map<String, dynamic> mem = json.decode(response2.body);
          setState(() {
            submissionDetails.add(registrations[i].submissions);
            submissionsTitle.add(mem['name']);
            registrationOrTeamIds.add(registrations[i].registrationId);
            userIds.add(registrations[i].userId);
          });}
          print(submissionDetails);
        }
      } else {
        throw Exception('Failed to load data');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadPref();
    loadSubmissions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event = context.watch<EventsRepository>().event(widget.id);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (var i = 0; i < submissionDetails.length; i++) ...[
                ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(Icons.collections_bookmark),
                    title: Text(
                      submissionsTitle[i],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      maxLines: 2,
                    ),
                    children: <Widget>[
                      for (var j = 0; j < submissionDetails[i].length; j++) ...[
                        ExpansionTile(
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            initiallyExpanded: false,
                            title: Text(
                              submissionDetails[i][j].title,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                              maxLines: 2,
                            ),
                            children: <Widget>[
                              if (!submissionDetails[i][j]
                                  .submissionAccess) ...[
                                Center(
                                  child: OutlinedIconButton(
                                    text: "Give Access",
                                    icon: Icons.accessibility,
                                    onTap: () async {
                                      var response = await httpPostWithHeaders(
                                        '${Url.URL}/api/event/give_access_round',
                                        jsonEncode(<String, dynamic>{
                                          'event_id': '${widget.id}',
                                          'user_id': '${userIds[i]}',
                                          'team_id': '${registrationOrTeamIds[i]}',
                                          'is_teamed': _event.isTeamed,
                                          'round_title':
                                              '${submissionDetails[i][j].title}'
                                        }),
                                      );
                                      if (response.statusCode == 200) {
                                        loadSubmissions();
                                      }
                                    },
                                  ),
                                ),
                              ] else if (submissionDetails[i][j]
                                  .submissionAccess)
                                ...[
                                  Center(
                                    child: OutlinedIconButton(
                                      text: "Remove Access",
                                      icon: Icons.accessibility,
                                      onTap: () async {
                                        var response = await httpPostWithHeaders(
                                          '${Url.URL}/api/event/remove_access_round',
                                          jsonEncode(<String, dynamic>{
                                            'event_id': '${widget.id}',
                                            'user_id': '${userIds[i]}',
                                            'team_id': '${registrationOrTeamIds[i]}',
                                            'is_teamed': _event.isTeamed,
                                            'round_title':
                                            '${submissionDetails[i][j].title}'
                                          }),
                                        );
                                        if (response.statusCode == 200) {
                                          loadSubmissions();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              if (submissionDetails[i][j]
                                  .submissionForm
                                  .toString()
                                  .isNullOrEmpty()) ...[
                                Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text("Not Submitted"),
                                )),
                              ] else ...[
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      columnSpacing: 20.0,
                                      horizontalMargin: 15.0,
                                      columns: <DataColumn>[
                                        for (var x = 0;
                                            x <
                                                submissionDetails[i][j]
                                                    .parseFilledData(
                                                        _event.parseRoundFields(
                                                            submissionDetails[i]
                                                                    [j]
                                                                .title))
                                                    .length;
                                            x++) ...[
                                          DataColumn(
                                            label: Text(
                                              submissionDetails[i][j]
                                                  .parseFilledData(
                                                      _event.parseRoundFields(
                                                          submissionDetails[i]
                                                                  [j]
                                                              .title))[x]
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
                                        DataRow(
                                          cells: <DataCell>[
                                            for (var y = 0;
                                                y <
                                                    submissionDetails[i][j]
                                                        .parseFilledData(_event
                                                            .parseRoundFields(
                                                                submissionDetails[
                                                                        i][j]
                                                                    .title))
                                                        .length;
                                                y++) ...[
                                              if (submissionDetails[i][j]
                                                      .parseFilledData(_event
                                                          .parseRoundFields(
                                                              submissionDetails[
                                                                      i][j]
                                                                  .title))[y]
                                                      .field ==
                                                  'file') ...[
                                                DataCell(
                                                  RButton("open file", 10, () {
                                                    print(submissionDetails[i]
                                                            [j]
                                                        .parseFilledData(_event
                                                            .parseRoundFields(
                                                                submissionDetails[
                                                                        i][j]
                                                                    .title))[y]
                                                        .value
                                                        .toString());
                                                    "${Url.URL}/api/event/registration/get_file?id=${submissionDetails[i][j].parseFilledData(_event.parseRoundFields(submissionDetails[i][j].title))[y].value.toString()}"
                                                        .launchUrl;
                                                  }),
                                                ),
                                              ] else ...[
                                                DataCell(
                                                  Text(
                                                    submissionDetails[i][j]
                                                            .parseFilledData(_event
                                                                .parseRoundFields(
                                                                    submissionDetails[i]
                                                                            [j]
                                                                        .title))[
                                                                y]
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
                                    ),
                                  ),
                                ),
                              ]
                            ]),
                      ],
                    ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
