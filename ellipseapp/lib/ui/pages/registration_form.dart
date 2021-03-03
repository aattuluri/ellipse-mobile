import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class RegistrationForm extends StatefulWidget {
  final String eventId;
  final List data;
  RegistrationForm(this.eventId, this.data);
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool formFilled = false;
  String title = "", field = "", option = "";
  ScrollController scrollController;
  List<DynamicFormWidget> listDynamic = [];
  Map<String, dynamic> data = {};
  List<FormFile> formFiles = [];
  register(UserDetails userdetails, Events event) async {
    setState(() {
      isLoading = true;
    });
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
            setState(() {
              data[formFiles[i].title.toString()] =
                  jsonResponse['file_name'].toString();
            });
          }
        }
      }}
    print(data);
    List<dynamic> values = data.values.toList();
    for (var i = 0; i <= values.length - 1; i++) {
      String v = values[i].toString();
      bool req = listDynamic[i].req;
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
        '${Url.URL}/api/event/register?id=${event.eventId}',
        jsonEncode(<String, Object>{'data': data}),
      );
      if (response.statusCode == 200) {
        context.read<EventsRepository>().init();
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(true);
        messageDialog(context, "Registered Successfully");
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
    final Events _event =
        context.read<EventsRepository>().event(widget.eventId);
    loadPref();
    _event.parseRegFields().forEach((i) {
      try {
        setState(() {
          data.addAll(<String, dynamic>{i.title.toString(): ''});
          listDynamic.add(DynamicFormWidget(
            req: i.required,
            data: i.title == 'Name'
                ? prefName
                : i.title == 'Email'
                    ? prefEmail
                    : i.title == 'College'
                        ? prefCollegeName
                        : null,
            title: i.title,
            field: i.field,
            options: i.options,
            readOnly:
                i.title == 'Name' || i.title == 'Email' || i.title == 'College',
            callBack: (dynamic value) {
              if (i.field != 'file') {
                setState(() {
                  data[i.title.toString()] = value;
                });
              } else if (i.field == 'file') {
                if (value != null) {
                  File _file = value;
                  setState(() {
                    formFiles.add(FormFile(title: i.title, file: _file));
                  });
                  print('files');
                  print(formFiles);
                }
              }
            },
          ));
        });
      } catch (_) {
        print("Error");
      }
    });
    setState(() {
      data["Name"] = prefName;
      data["Email"] = prefEmail;
      if (data.containsKey('College')) {
        data["College"] = prefCollegeName;
      } else {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().event(widget.eventId);
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return isLoading
        ? LoaderCircular('Registering')
        : Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CardPage.body(
                      title: "Fill Form",
                      body: RowLayout(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: listDynamic.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    listDynamic[index],
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                          Acceptance(
                              'By registering for the event,I accept the ',
                              false),
                          RButton('Register', 13, () async {
                            register(_userdetails, _event);
                          }),
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
