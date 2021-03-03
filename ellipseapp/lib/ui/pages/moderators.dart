import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class EventModerators extends StatefulWidget {
  final String id;
  const EventModerators(this.id);
  @override
  _EventModeratorsState createState() => _EventModeratorsState();
}

class _EventModeratorsState extends State<EventModerators>
    with TickerProviderStateMixin {
  var moderatorController = new TextEditingController();
  bool isLoading = false;
  String selectedModeratorId;
  List<Member> moderators = [];
  Map<String, dynamic> usersData = {};
  addModerator(String eventId) async {
    if (selectedModeratorId.isNullOrEmpty()) {
      flutterToast(context, 'Select Moderator', 2, ToastGravity.CENTER);
    } else {
      setState(() {
        isLoading = true;
      });
      var response4 = await httpPostWithHeaders(
        '${Url.URL}/api/event/add_moderator',
        jsonEncode(<String, dynamic>{
          'moderator_id': selectedModeratorId,
          'event_id': eventId
        }),
      );
      if (response4.statusCode == 200) {
        Provider.of<EventsRepository>(context, listen: false).init();
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  loadModerators() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      moderators = [];
    });
    final Events _event = context.read<EventsRepository>().event(widget.id);
    print(_event.moderators);
    if (_event.moderators.isNotEmpty) {
      for (var i = 0; i < _event.moderators.length; i++) {
        String memberId = _event.moderators[i].toString();
        var response2 = await httpGetWithHeaders(
            "${Url.URL}/api/event/get_team_member_details?id=$memberId");
        if (response2.statusCode == 200) {
          Map<String, dynamic> mem = json.decode(response2.body);
          setState(() {
            moderators.add(
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
      print(moderators);
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  loadUsers() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await httpGetWithHeaders("${Url.URL}/api/event/get_all_users");
    if (response.statusCode == 200) {
      List<Users> users = (json.decode(response.body) as List)
          .map((data) => Users.fromJson(data))
          .toList();
      for (var i = 0; i < users.length; i++) {
        setState(() {
          usersData[users[i].userId] = users[i].name + ' ,' + users[i].userName;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadPref();
    loadUsers();
    loadModerators();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event = context.watch<EventsRepository>().event(widget.id);
    return isLoading
        ? LoaderCircular("Loading")
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              child: RowLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                space: 5,
                children: [
                  TextFormField(
                      controller: moderatorController,
                      readOnly: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                          border: OutlineInputBorder(),
                          //labelText: "Select Moderator",
                          hintText: "Select Moderator"),
                      onTap: () {
                        showDropdownSearchDialog(
                            context: context,
                            items: usersData,
                            addEnabled: false,
                            onChanged: (String key, String value) {
                              setState(() {
                                selectedModeratorId = key;
                                moderatorController =
                                    TextEditingController(text: value);
                              });
                            });
                      }),
                  RButton('Add', 10, () async {
                    addModerator(_event.eventId);
                  }),
                  if (moderators.isNotEmpty) ...[
                    SizedBox(
                      height: 10,
                    ),
                    for (var i = 0; i < moderators.length; i++) ...[
                      ListTile(
                        enabled: false,
                        title: Text(
                          moderators[i].name,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                          maxLines: 100,
                        ),
                        trailing:
                            ChipButton('Remove', Icons.remove_circle, () async {
                          setState(() {
                            isLoading = true;
                          });
                          var response4 = await httpPostWithHeaders(
                            '${Url.URL}/api/event/remove_moderator',
                            jsonEncode(<String, dynamic>{
                              'moderator_id': moderators[i].id,
                              'event_id': _event.eventId
                            }),
                          );
                          if (response4.statusCode == 200) {
                            Provider.of<EventsRepository>(context,
                                    listen: false)
                                .init();
                            Navigator.pop(context);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }),
                        subtitle: Text(
                          moderators[i].college,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                          maxLines: 100,
                        ),
                        leading: Container(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(540),
                            child: moderators[i].userPic.isNullOrEmpty()
                                ? NoProfilePic()
                                : FadeInImage(
                                    image: NetworkImage(
                                        "${Url.URL}/api/image?id=${moderators[i].userPic}"),
                                    placeholder:
                                        AssetImage('assets/icons/loading.gif'),
                                  ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {},
                      ),
                    ]
                  ]
                ],
              ),
            ),
          );
  }
}
