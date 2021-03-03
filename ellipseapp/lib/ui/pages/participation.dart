import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:row_collection/row_collection.dart';

//import 'package:web_socket_channel/io.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class Participation extends StatefulWidget {
  final Events event_;
  Participation(this.event_);
  @override
  _ParticipationState createState() => _ParticipationState();
}

class _ParticipationState extends State<Participation>
    with TickerProviderStateMixin {
  TabController tabController;
  final List tabs = [
    IconTab(name: "Team", icon: Icons.people_outline),
    IconTab(name: "Chat", icon: Icons.message_outlined),
  ];
  bool isLoading = false;
  bool inTeam = false;
  bool isAdmin = false;
  Registrations reg;
  Teams team;
  List<Teams> availableTeams = [];
  Map<String, dynamic> teamMember = {};
  List<Teams> myRequests = [];
  List<Member> requestedMembers = [];
  List<Member> teamMembers = [];
  bool scrollVisible = true;
  teamForm(String type, String name, String description) async {
    var _nameController = new TextEditingController();
    var _descriptionController = new TextEditingController();
    _nameController.text = name;
    _descriptionController.text = description;
    generalSheet(
      context,
      title: "Create Team",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: RowLayout(
          children: <Widget>[
            TextFormField(
              enabled: !(type == 'edit'),
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
              ),
              controller: _nameController,
              cursorColor: Theme.of(context).textTheme.caption.color,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Name"),
              maxLines: 1,
            ),
            TextFormField(
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
              ),
              controller: _descriptionController,
              cursorColor: Theme.of(context).textTheme.caption.color,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Description"),
              maxLines: 5,
            ),
            type == 'create'
                ? RButton('Create', 10, () async {
                    var response = await httpPostWithHeaders(
                      '${Url.URL}/api/event/create_team',
                      jsonEncode(<String, dynamic>{
                        'event_id': widget.event_.eventId,
                        'team_name': _nameController.text,
                        'desc': _descriptionController.text
                      }),
                    );

                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      loadTeams();
                      setState(() {});
                    } else {}
                  })
                : RButton('Edit', 10, () async {
                    var response = await httpPostWithHeaders(
                      '${Url.URL}/api/event/edit_team',
                      jsonEncode(<String, dynamic>{
                        'team_id': team.teamId,
                        'desc': _descriptionController.text
                      }),
                    );
                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      loadTeams();
                      setState(() {});
                    } else {}
                  }),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  loadTeams() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      myRequests = [];
      teamMembers = [];
      availableTeams = [];
      requestedMembers = [];
      teamMember = {};
    });
    String eventId = widget.event_.eventId.trim().toString();
    //////Load Registration/////
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_user_registration?id=$eventId");
    if (response.statusCode == 200) {
      setState(() {
        List<Registrations> registration = (json.decode(response.body) as List)
            .map((data1) => Registrations.fromJson(data1))
            .toList();
        reg = registration[0];
        print('reg.toString()');
        print(reg.toString());
      });
      //////Load My Requests/////
      if (reg.sentRequests.isNotEmpty) {
        for (var i = 0; i < reg.sentRequests.length; i++) {
          String teamId = reg.sentRequests[i];
          var response1 = await httpGetWithHeaders(
              "${Url.URL}/api/event/get_team_details?id=$teamId");
          if (response1.statusCode == 200) {
            setState(() {
              List<Teams> teamDetails = (json.decode(response1.body) as List)
                  .map((data1) => Teams.fromJson(data1))
                  .toList();
              team = teamDetails[0];
            });
          }
          setState(() {
            myRequests.add(team);
          });
        }
      } else {}
      if (reg.teamedUp && !reg.teamId.isNullOrEmpty()) {
        String teamId = reg.teamId.toString();
        //////Load Team Details/////
        var response1 = await httpGetWithHeaders(
            "${Url.URL}/api/event/get_team_details?id=$teamId");
        if (response1.statusCode == 200) {
          setState(() {
            List<Teams> teamDetails = (json.decode(response1.body) as List)
                .map((data1) => Teams.fromJson(data1))
                .toList();
            team = teamDetails[0];
            if (team.userId == prefId) {
              setState(() {
                isAdmin = true;
              });
            } else {}
            if (team.members.contains(prefId)) {
              setState(() {
                inTeam = true;
              });
            } else {}
            print('team.toString()');
            print(team.toString());
          });
          if (team.members.isNotEmpty) {
            //////Load Team Members Details/////
            for (var i = 0; i < team.members.length; i++) {
              String memberId = team.members[i].toString();
              var response2 = await httpGetWithHeaders(
                  "${Url.URL}/api/event/get_team_member_details?id=$memberId");
              if (response2.statusCode == 200) {
                Map<String, dynamic> mem = json.decode(response2.body);
                setState(() {
                  teamMembers.add(
                    Member(
                      id: memberId.trim(),
                      name: mem['name'],
                      college: mem['college'],
                      username: mem['username'],
                      userPic: mem['user_pic'],
                    ),
                  );
                });
              }
            }
            print('teamMembers.toString()');
            print(teamMembers.toString());
          } else {}
          if (team.receivedRequests.isNotEmpty) {
            //////Load Received Team Requests/////
            print('team.receivedRequests.toString()');
            print(team.receivedRequests.toString());
            for (var i = 0; i < team.receivedRequests.length; i++) {
              String memberId = team.receivedRequests[i].toString();
              var response5 = await httpGetWithHeaders(
                  "${Url.URL}/api/event/get_team_member_details?id=$memberId");
              if (response5.statusCode == 200) {
                Map<String, dynamic> mem = json.decode(response5.body);
                setState(() {
                  requestedMembers.add(
                    Member(
                      id: memberId.trim(),
                      name: mem['name'],
                      college: mem['college'],
                      username: mem['username'],
                      userPic: mem['user_pic'],
                    ),
                  );
                });
              }
            }
          } else {}
        }
      } else {
        setState(() {
          inTeam = false;
        });
        String eventId = '${widget.event_.eventId}';
        var response3 = await httpGetWithHeaders(
            "${Url.URL}/api/event/get_all_teams?id=$eventId");
        print(response3.toString());
        availableTeams = [
          for (final item in json.decode(response3.body)) Teams.fromJson(item)
        ];
      }
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isLoading = false;
    });
  }

  joinTeam(String title) async {
    if (availableTeams.isEmpty) {
      flutterToast(context, 'No Teams Available', 1, ToastGravity.CENTER);
    } else if (availableTeams.isNotEmpty) {
      generalSheet(
        context,
        title: title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                for (var i = 0; i < availableTeams.length; i++) ...[
                  ListTile(
                    title: Text(
                      availableTeams[i].name,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      maxLines: 5,
                    ),
                    subtitle: Center(
                      child: RButton('Request Join', 10, () async {
                        Navigator.pop(context);
                        if (reg.sentRequests
                            .contains(availableTeams[i].teamId)) {
                          flutterToast(
                              context,
                              'Already sent request to ' +
                                  '${availableTeams[i].name}',
                              1,
                              ToastGravity.CENTER);
                        } else if (availableTeams[i].members.length >=
                            (double.parse(widget.event_.parseTeamSize().maxSize)
                                .toInt())) {
                          flutterToast(context, 'Already team filled', 1,
                              ToastGravity.CENTER);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          var response4 = await httpPostWithHeaders(
                            '${Url.URL}/api/event/user_teamup_request',
                            jsonEncode(<String, dynamic>{
                              'team_id': availableTeams[i].teamId,
                              'event_id': widget.event_.eventId
                            }),
                          );
                          if (response4.statusCode == 200) {
                            String userId=prefId;
                            sockets.send(json.encode({
                              'action': "team_status_update_status",
                              'team_id': availableTeams[i].teamId,
                              'users': availableTeams[i].members,
                              'msg': {
                                'user_id': '$userId',
                              }
                            }));
                            String datetime =
                                DateTime.now().toIso8601String().toString();
                            sockets.send(json.encode({
                              'action': "team_status_update_message",
                              'team_id': availableTeams[i].teamId,
                              'msg': {
                                'id': datetime,
                                'user_id': prefId,
                                'user_name': '',
                                'user_pic': '',
                                'message_type': 'team_status_update_message',
                                'message': prefName +
                                    " has requested to join the team",
                                'date': datetime
                              }
                            }));
                            loadTeams();
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    onTap: () {},
                  ),
                ]
              ],
            ),
          ],
        ),
      );
    }
  }

  webSocketConnect() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String userId = prefId;
    sockets.send(json.encode({
      'action': "join_team_update_status",
      'msg': {
        'user_id': '$userId',
      }
    }));
  }

  onMessage(String data) async {
    var response = json.decode(data);
    print(data.toString());
    dynamic msg = response['msg'];
    String action = response['action'];
    if (action == "receive_team_update_message") {
      loadTeams();
    } else {}
  }

  load() async {
    setState(() {
      isLoading = true;
    });
    await loadTeams();
    await webSocketConnect();
    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    loadPref();
    tabController = new TabController(
      length: tabs.length,
      vsync: this,
    );
    load();
    sockets.addListener(onMessage);
    super.initState();
  }

  @override
  void dispose() {
    String userId = prefId;
    sockets.send(json.encode({
      'action': "close_team_update_status_socket",
      'msg': {
        'user_id': '$userId',
      }
    }));
    sockets.removeListener(onMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: tabController,
        isScrollable: false,
        tabs: tabs.map((tab) {
          return Center(
            child: Tab(
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      tab.name,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      body: isLoading
          ? LoaderCircular("Loading")
          : TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                  //////Tab1//////
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      child: inTeam
                          ? RowLayout(
                              space: 5,
                              children: [
                                ////////Team Details/////////
                                Text(
                                  'Team Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ListTile(
                                  enabled: false,
                                  title: Text(
                                    team.name,
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
                                    team.description,
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        team.name.substring(0, 1).toUpperCase(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          fontSize: 20,
                                          fontFamily: 'ProductSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  onTap: () {},
                                ),
                                if (isAdmin) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ChipButton('Edit', Icons.edit, () {
                                        teamForm('edit', team.name,
                                            team.description);
                                      }),
                                      ChipButton('Delete', Icons.delete,
                                          () async {
                                        var response =
                                            await httpPostWithHeaders(
                                          '${Url.URL}/api/event/delete_team',
                                          jsonEncode(<String, dynamic>{
                                            'team_id': team.teamId
                                          }),
                                        );
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            inTeam = false;
                                          });
                                          String userId=prefId;
                                          sockets.send(json.encode({
                                            'action': "team_status_update_status",
                                            'team_id': team.teamId,
                                            'users': team.members,
                                            'msg': {
                                              'user_id': '$userId',
                                            }
                                          }));
                                          //loadTeams();
                                          setState(() {});
                                        } else {}
                                      }),
                                    ],
                                  ),
                                ],
                                ////////Received Requests/////////
                                if (requestedMembers.isNotEmpty && isAdmin) ...[
                                  Text('Team Up Requests'),
                                  ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (var i = 0;
                                          i < requestedMembers.length;
                                          i++) ...[
                                        ListTile(
                                          enabled: false,
                                          title: Text(
                                            requestedMembers[i].name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                            ),
                                            maxLines: 100,
                                          ),
                                          trailing: ChipButton(
                                              'Accept', Icons.verified_user,
                                              () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            var response4 =
                                                await httpPostWithHeaders(
                                              '${Url.URL}/api/event/accept_user_teamup_request',
                                              jsonEncode(<String, dynamic>{
                                                'team_id': team.teamId,
                                                'event_id':
                                                    widget.event_.eventId,
                                                'user_id':
                                                    '${requestedMembers[i].id}'
                                              }),
                                            );
                                            if (response4.statusCode == 200) {
                                              String userId=prefId;
                                              List<dynamic> members=team.members;
                                              setState(() {
                                                members.add('${requestedMembers[i].id}');
                                              });
                                              sockets.send(json.encode({
                                                'action': "team_status_update_status",
                                                'team_id': team.teamId,
                                                'users': members,
                                                'msg': {
                                                  'user_id': '$userId',
                                                }
                                              }));
                                              setState(() {
                                                isLoading = false;
                                              });
                                             // loadTeams();
                                            }
                                          }),
                                          subtitle: Text(
                                            requestedMembers[i].college,
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
                                              borderRadius:
                                                  BorderRadius.circular(540),
                                              child: requestedMembers[i]
                                                      .userPic
                                                      .isNullOrEmpty()
                                                  ? NoProfilePic()
                                                  : FadeInImage(
                                                      image: NetworkImage(
                                                          "${Url.URL}/api/image?id=${requestedMembers[i].userPic}"),
                                                      placeholder: AssetImage(
                                                          'assets/icons/loading.gif'),
                                                    ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          onTap: () {},
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                                ////////Team Members/////////
                                Text(
                                  'Team Members',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    for (var i = 0;
                                        i < teamMembers.length;
                                        i++) ...[
                                      ListTile(
                                        enabled: false,
                                        title: Text(
                                          teamMembers[i].name,
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
                                          teamMembers[i].college,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color,
                                          ),
                                          maxLines: 100,
                                        ),
                                        trailing: teamMembers[i].id == prefId &&
                                                !isAdmin
                                            ? ChipButton(
                                                'Leave', CupertinoIcons.minus,
                                                () async {
                                                setState(() {
                                                  //isLoading = true;
                                                });
                                                var response6 =
                                                    await httpPostWithHeaders(
                                                  '${Url.URL}/api/event/leave_team',
                                                  jsonEncode(<String, dynamic>{
                                                    'team_id': team.teamId,
                                                    'event_id':
                                                        widget.event_.eventId
                                                  }),
                                                );
                                                if (response6.statusCode ==
                                                    200) {
                                                  String userId=prefId;
                                                  sockets.send(json.encode({
                                                    'action': "team_status_update_status",
                                                    'team_id': team.teamId,
                                                    'users': team.members,
                                                    'msg': {
                                                      'user_id': '$userId',
                                                    }
                                                  }));
                                                  String datetime =
                                                      DateTime.now()
                                                          .toIso8601String()
                                                          .toString();
                                                  sockets.send(json.encode({
                                                    'action':
                                                        "team_status_update_message",
                                                    'team_id': team.teamId,
                                                    'users': team.members,
                                                    'msg': {
                                                      'id': datetime,
                                                      'user_id': prefId,
                                                      'user_name': '',
                                                      'user_pic': '',
                                                      'message_type':
                                                          'team_status_update_message',
                                                      'message': prefName +
                                                          " has left the team",
                                                      'date': datetime
                                                    }
                                                  }));
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  //loadTeams();
                                                }
                                              })
                                            : teamMembers[i].id != prefId &&
                                                    isAdmin
                                                ? ChipButton('Remove',
                                                    CupertinoIcons.minus,
                                                    () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    var response6 =
                                                        await httpPostWithHeaders(
                                                      '${Url.URL}/api/event/remove_user_from_team',
                                                      jsonEncode(<String,
                                                          dynamic>{
                                                        'team_id': team.teamId,
                                                        'event_id': widget
                                                            .event_.eventId,
                                                        'user_id':
                                                            '${teamMembers[i].id}'
                                                      }),
                                                    );
                                                    if (response6.statusCode ==
                                                        200) {
                                                      String userId=prefId;
                                                      sockets.send(json.encode({
                                                        'action': "team_status_update_status",
                                                        'team_id': team.teamId,
                                                        'users': team.members,
                                                        'msg': {
                                                          'user_id': '$userId',
                                                        }
                                                      }));
                                                      String datetime =
                                                          DateTime.now()
                                                              .toIso8601String()
                                                              .toString();
                                                      sockets.send(json.encode({
                                                        'action':
                                                            "team_status_update_message",
                                                        'team_id': team.teamId,
                                                        'users': team.members,
                                                        'msg': {
                                                          'id': datetime,
                                                          'user_id': prefId,
                                                          'user_name': '',
                                                          'user_pic': '',
                                                          'message_type':
                                                              'team_status_update_message',
                                                          'message': teamMembers[
                                                                      i]
                                                                  .name +
                                                              " was removed from team",
                                                          'date': datetime
                                                        }
                                                      }));
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      //loadTeams();
                                                    }
                                                  })
                                                : SizedBox.shrink(),
                                        leading: Container(
                                          height: 40,
                                          width: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(540),
                                            child: teamMembers[i]
                                                    .userPic
                                                    .isNullOrEmpty()
                                                ? NoProfilePic()
                                                : FadeInImage(
                                                    image: NetworkImage(
                                                        "${Url.URL}/api/image?id=${teamMembers[i].userPic}"),
                                                    placeholder: AssetImage(
                                                        'assets/icons/loading.gif'),
                                                  ),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        onTap: () {},
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            )
                          ////////Not in Team/////////
                          : RowLayout(
                              children: [
                                ////////My Requests/////////
                                if (myRequests.isNotEmpty) ...[
                                  Text('My Requests'),
                                  ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (var i = 0;
                                          i < myRequests.length;
                                          i++) ...[
                                        ListTile(
                                          enabled: false,
                                          title: Text(
                                            myRequests[i].name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                            ),
                                            maxLines: 100,
                                          ),
                                          trailing: ChipButton(
                                              'Withdraw', CupertinoIcons.minus,
                                              () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            var response6 =
                                                await httpPostWithHeaders(
                                              '${Url.URL}/api/event/user_teamwithdraw_request',
                                              jsonEncode(<String, dynamic>{
                                                'team_id': myRequests[i].teamId,
                                                'event_id':
                                                    widget.event_.eventId
                                              }),
                                            );
                                            if (response6.statusCode == 200) {
                                              String userId=prefId;
                                              sockets.send(json.encode(<String,dynamic>{
                                                'action': "team_status_update_status",
                                                'team_id': myRequests[i].teamId,
                                                'users': myRequests[i].members,
                                                'msg': {
                                                  'user_id': '$userId',
                                                }
                                              }));
                                              setState(() {
                                                //isLoading = false;
                                              });
                                              loadTeams();
                                              setState(() {

                                              });
                                            }
                                          }),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          onTap: () {},
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                                Text(
                                    'You have neither created nor joined in team'),
                                RButton('Create Team', 10, () {
                                  teamForm('create', '', '');
                                }),
                                Text('or'),
                                RButton('Join Team', 10, () {
                                  joinTeam(widget.event_.name);
                                }),
                              ],
                            ),
                    ),
                  ),
                  inTeam && !isLoading
                      ? ChatScreen(type: 'teamChat', id: team.teamId)
                      : EmptyData(
                      'Not a member of team',
                      "",
                      Icons.chat)
                ]),
    );
  }
}
