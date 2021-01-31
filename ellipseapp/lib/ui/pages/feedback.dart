import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class FeedbackApp extends StatefulWidget {
  const FeedbackApp({Key key}) : super(key: key);

  @override
  _FeedbackAppState createState() => _FeedbackAppState();
}

class _FeedbackAppState extends State<FeedbackApp>
    with TickerProviderStateMixin {
  var _feedbackController = new TextEditingController();
  senFeedback(String feedback) async {
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/send_feedback',
      jsonEncode(<String, dynamic>{'description': feedback.toString()}),
    );
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
            "Feedback",
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
                        border: OutlineInputBorder(), labelText: "Feedback"),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RButton('Send', 13, () {
                    senFeedback(_feedbackController.text);
                  }),
                ]),
          ),
        ),
      ),
    );
  }
}
