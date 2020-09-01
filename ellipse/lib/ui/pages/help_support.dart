import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';
import 'package:http/http.dart' as http;
import '../screens/index.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({Key key}) : super(key: key);

  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport>
    with TickerProviderStateMixin {
  String token = "", id = "", email = "";
  String title = "", description = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }


  @override
  void initState() {
    getPref();
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
                          onChanged: (value) {
                            title = value;
                          },
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Feedback/Issue"),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            description = value;
                          },
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Description"),
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
                                FlutterWebBrowser.openWebPage(
                                  url: 'mailto:gunasekhar158@gmail.com?subject=$title&body=$description',
                                  androidToolbarColor: Theme.of(context).primaryColor,
                                );
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Send',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
