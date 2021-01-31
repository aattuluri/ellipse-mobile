import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class EventTeams extends StatefulWidget {
  final String id;
  const EventTeams(this.id);

  @override
  _EventTeamsState createState() => _EventTeamsState();
}

class _EventTeamsState extends State<EventTeams> with TickerProviderStateMixin {
  List<Teams> teams = [];
  List<List<Member>> teamMembers = [];
  bool isLoading = false;
  loadTeams() async {
    setState(() {
      isLoading = true;
    });
    String eventId = '${widget.id}';
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_all_teams?id=$eventId");
    print(response.toString());
    setState(() {
      teams = [
        for (final item in json.decode(response.body)) Teams.fromJson(item)
      ];
    });
    for (var i = 0; i < teams.length; i++) {
      List<Member> m = [];
      if (teams[i].members.isNotEmpty) {
        for (var j = 0; j < teams[i].members.length; j++) {
          String memberId = teams[i].members[j].toString();
          var response2 = await httpGetWithHeaders(
              "${Url.URL}/api/event/get_team_member_details?id=$memberId");
          if (response2.statusCode == 200) {
            Map<String, dynamic> mem = json.decode(response2.body);
            m.add(
              Member(
                id: memberId.trim(),
                name: mem['name'],
                college: mem['college'],
                username: mem['username'],
                userPic: mem['user_pic'],
              ),
            );
          }
          setState(() {
            teamMembers.add(m);
          });
        }
      } else {}
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadPref();
    loadTeams();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? LoaderCircular("Loading")
          : Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: teams.isEmpty
                  ? EmptyData(
                      'No Teams', " no teams for your event", Icons.extension)
                  : ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        for (var i = 0; i < teams.length; i++) ...[
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              teams[i].name,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              teams[i].description,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                              maxLines: 3,
                            ),
                            children: <Widget>[
                              for (var j = 0;
                                  j < teamMembers[i].length;
                                  j++) ...[
                                ListTile(
                                  enabled: false,
                                  title: Text(
                                    teamMembers[i][j].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    maxLines: 100,
                                  ),
                                  subtitle: Text(
                                    teamMembers[i][j].username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    maxLines: 100,
                                  ),
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(540),
                                      child: teamMembers[i][j]
                                              .userPic
                                              .isNullOrEmpty()
                                          ? NoProfilePic()
                                          : FadeInImage(
                                              image: NetworkImage(
                                                  "${Url.URL}/api/image?id=${teamMembers[i][j].userPic}"),
                                              placeholder: AssetImage(
                                                  'assets/icons/loading.gif'),
                                            ),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  onTap: () {},
                                ),
                              ]
                            ],
                          ),
                        ]
                      ],
                    ),
            ),
    );
  }
}
