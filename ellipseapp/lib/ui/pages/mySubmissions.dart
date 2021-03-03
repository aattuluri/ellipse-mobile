import 'dart:convert';
import 'dart:core';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class MySubmissions extends StatefulWidget {
  final String id;
  const MySubmissions(this.id);

  @override
  _MySubmissionsState createState() => _MySubmissionsState();
}

class _MySubmissionsState extends State<MySubmissions>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool formFilled = false;
  Registrations reg;
  Teams team;
  List<List<DynamicFormWidget>> listDynamic = [];
  List<Map<String, dynamic>> filledData = [];
  List<SubmissionModel> submissionsDetails = [];
  List<FormFile> formFiles = [];
  //List<String> accessBool=[];
  loadRounds() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      listDynamic = [];
      filledData = [];
      submissionsDetails = [];
      formFiles = [];
      //accessBool=[];
    });
    final Events _event = context.read<EventsRepository>().event(widget.id);
    String eventId = _event.eventId.trim().toString();
    //////Load Registration/////
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_user_registration?id=$eventId");
    if (response.statusCode == 200) {
      setState(() {
        List<Registrations> registration = (json.decode(response.body) as List)
            .map((data1) => Registrations.fromJson(data1))
            .toList();
        reg = registration[0];
      });
      if (reg.teamedUp) {
        String teamId = reg.teamId;
        var response1 = await httpGetWithHeaders(
            "${Url.URL}/api/event/get_team_details?id=$teamId");
        if (response1.statusCode == 200) {
          setState(() {
            List<Teams> teamDetails = (json.decode(response1.body) as List)
                .map((data1) => Teams.fromJson(data1))
                .toList();
            team = teamDetails[0];
          });
          print('team.submissions');
          setState(() {
            submissionsDetails = team.submissions;
          });
          print(submissionsDetails);
        } else {}
      } else {
        print('reg.submissions');
        setState(() {
          submissionsDetails = reg.submissions;
        });
        print(submissionsDetails);
      }
    }
    ///////////load form and data //////////
    for (var i = 0; i < _event.rounds.length; i++) {
      List<DynamicFormWidget> ld = [];
      Map<String, dynamic> fd = {};
      setState(() {
        for (var j = 0; j < _event.rounds[i].fields.length; j++) {
          FormFieldModel fF = _event.rounds[i].fields[j];
          fd.addAll(<String, dynamic>{fF.title.toString(): ''});
          String t = fF.title;
          String data;
          for (var k = 0; k < submissionsDetails.length; k++) {
            if (submissionsDetails[k].title == _event.rounds[i].title) {
              // setState(() {
              //  accessBool.add(submissionsDetails[k].submissionAccess.toString());
              //});
              Map<String, dynamic> sub = submissionsDetails[k].submissionForm;
              if (submissionsDetails[k].submissionForm == null) {
                data = null;
              } else {
                data = sub['$t'];
              }
              print(sub);
            } else {}
          }
          fd['$t'] = data;
          ld.add(
            DynamicFormWidget(
              req: fF.required,
              data: data,
              title: fF.title,
              field: fF.field,
              options: fF.options,
              callBack: (dynamic value) {
                if (fF.field != 'file') {
                  setState(() {
                    fd[fF.title.toString()] = value;
                    filledData[i][fF.title.toString()] = value;
                  });
                } else if (fF.field == 'file') {
                  if (value != null) {
                    File _file = value;
                    setState(() {
                      formFiles.add(FormFile(title: fF.title, file: _file));
                    });
                    print('files');
                    print(formFiles);
                  }
                }
              },
            ),
          );
        }
        listDynamic.add(ld);
        filledData.add(fd);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  addSubmission(String title, int index) async {
    final Events event = context.read<EventsRepository>().event(widget.id);
    setState(() {
      isLoading = true;
    });
    final Events _event = context.read<EventsRepository>().event(widget.id);
    for (var i = 0; i < formFiles.length; i++) {
      if (formFiles[i].file != null && formFiles[i].title != null) {
        File _file = formFiles[i].file;
        if (_file != null) {
          print('uploading file');
          var response = await httpPostFile(
              _file,
              '${Url.URL}/api/event/register/upload_file?id=${event.eventId}',
              'uploaded_file');
          if (response.statusCode == 200) {
            var jsonResponse = json.decode(response.body);
            print("jsonResponse['file_name'].toString()");
            print(jsonResponse['file_name'].toString());
            setState(() {
              filledData[i][formFiles[i].title.toString()] =
                  jsonResponse['file_name'].toString();
            });
          }
        }
      }
    }
    print('filledData[index]');
    print(filledData[index]);
    List<dynamic> values = filledData[index].values.toList();
    for (var k = 0; k <= values.length - 1; k++) {
      String v = values[k].toString();
      bool req = listDynamic[index][k].req;
      if (v.isNullOrEmpty() && req) {
        setState(() {
          formFilled = false;
        });
        break;
      } else {
        setState(() {
          formFilled = true;
        });
      }
    }
    print(formFilled);
    if (formFilled) {
      var response = await httpPostWithHeaders(
        '${Url.URL}/api/event/team/add_submission',
        jsonEncode(<String, dynamic>{
          'event_id': '${_event.eventId}',
          'user_id': prefId,
          'reg_id': '${reg.registrationId}',
          'team_id': '${reg.teamId}',
          'is_teamed': reg.teamedUp,
          'event_round': '$title',
          'submission': filledData[index]
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(true);
        messageDialog(context, "Submission Submitted Successfully");
      } else {
        print(response.body);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      messageDialog(context, 'All fields should be filled');
    }
  }

  @override
  void initState() {
    loadPref();
    setState(() {
      listDynamic = [];
      filledData = [];
    });
    loadRounds();
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
        key: _scaffoldKey,
        body: isLoading
            ? LoaderCircular("Loading")
            : submissionsDetails.length > 0
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView(
                      children: [
                        for (var i = 0; i < _event.rounds.length; i++) ...[
                          ExpansionTile(
                            initiallyExpanded: false,
                            title: Text(
                              _event.rounds[i].title,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              _event.rounds[i].description,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                              maxLines: 3,
                            ),
                            children: <Widget>[
                              if (listDynamic.isNotEmpty) ...[
                                CardPage.body(
                                  title: "Form",
                                  body: RowLayout(children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                    ),
                                    for (var j = 0;
                                        j < listDynamic[i].length;
                                        j++) ...[
                                      listDynamic[i][j],
                                    ],
                                    _event.rounds[i].startDate
                                                .isBefore(DateTime.now()) &&
                                            _event.rounds[i].endDate
                                                .isAfter(DateTime.now()) &&
                                            submissionsDetails[i]
                                                .submissionAccess
                                        ? RButton(
                                            submissionsDetails[i]
                                                        .submissionForm ==
                                                    null
                                                ? "Submit"
                                                : "Update",
                                            10, () {
                                            int min_size = double.parse(_event
                                                    .parseTeamSize()
                                                    .minSize)
                                                .toInt();
                                            print(min_size);
                                            if (_event.isTeamed
                                                ? team.members.length < min_size
                                                : 1 == 2) {
                                              messageDialog(
                                                  context,
                                                  "Team Size should be atleast " +
                                                      _event
                                                          .parseTeamSize()
                                                          .minSize +
                                                      " to enable submissions");
                                            } else {
                                              addSubmission(
                                                  _event.rounds[i].title
                                                      .toString(),
                                                  i);
                                            }
                                          })
                                        : Text('Submission Disabled'),
                                  ]),
                                ),
                              ],
                              if (!_event.rounds[i].link.isNullOrEmpty()) ...[
                                CardPage.body(
                                  title: "Submission Link",
                                  body: RowLayout(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _event.rounds[i].link.launchUrl;
                                        },
                                        child: Text(_event.rounds[i].link),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ],
                    ),
                  )
                : EmptyData('No Submissions', "", Icons.collections_bookmark),
      ),
    );
  }
}
