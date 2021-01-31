import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key key}) : super(key: key);

  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport>
    with TickerProviderStateMixin {
  var _nameController = new TextEditingController();
//  var _emailController = new TextEditingController();
  var _issueController = new TextEditingController();
  send(String feedback) async {
    String name = _nameController.text;
    // String email = _emailController.text;
    String issue = _issueController.text;
    'mailto:support@ellipseapp.com?subject=$name&body=$issue'.launchUrl;
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "Help & Support",
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
                    controller: _nameController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                        labelText: "Name"),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _issueController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Describe your issue",
                        labelText: "Describe your issue"),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RButton('Send', 13, () {
                    send(_issueController.text);
                  }),
                ]),
          ),
        ),
      ),
    );
  }
}
