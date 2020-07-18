import 'package:ellipseellipse/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';
import 'package:http/http.dart' as http;

/// Here lays all available options for the user to configurate.
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String token = "", id = "", email = "";
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ),
          elevation: 4,
          title: Text(
            "Change Password",
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Old Password"),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "New Password"),
                    maxLines: 1,
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
                        onPressed: () {},
                        child: Text(
                          'Change',
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
