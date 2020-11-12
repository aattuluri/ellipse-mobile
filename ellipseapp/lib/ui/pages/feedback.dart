import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../util/index.dart';
import '../widgets/index.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({Key key}) : super(key: key);

  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport>
    with TickerProviderStateMixin {
  var _feedbackController = new TextEditingController();
  senFeedback(String feedback) async {
    http.Response response = await http.post(
      '${Url.URL}/api/event/send_feedback',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
      },
      body: jsonEncode(<String, dynamic>{'description': feedback.toString()}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        _feedbackController.clear();
      });
      Navigator.of(context).pop();
      messageDialog(context, "Feedback Submitted Successfully");
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "Report",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _feedbackController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 200,
                      height: 50,
                      margin: EdgeInsets.only(top: 10.0),
                      child: RaisedButton(
                        color: Theme.of(context)
                            .textTheme
                            .caption
                            .color
                            .withOpacity(0.3),
                        onPressed: () {
                          senFeedback(_feedbackController.text);
                        },
                        child: Text(
                          'Send',
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}
