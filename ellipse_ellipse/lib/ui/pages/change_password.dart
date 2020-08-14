import 'dart:convert';

import 'package:ellipseellipse/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  bool isloading = false;
  TabController _nestedTabController;
  String token = "", id = "", email = "";
  String opassword = "", npassword = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  change_password1(String opassword, npassword) async {
    http.Response response1 = await http.post(
      '${Url.URL}/api/users/updatepassword',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<dynamic, dynamic>{
        'email': email,
        'cPassword': '$opassword',
        'nPassword': '$npassword'
      }),
    );
    print('Response status: ${response1.statusCode}');
    print('Response body: ${response1.body}');
    if (response1.statusCode == 200) {
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  @override
  void initState() {
    _nestedTabController = new TabController(length: 2, vsync: this);
    getPref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? SafeArea(
            child: Scaffold(
                body: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                Text(
                  "Updating password....",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )))
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                iconTheme: Theme.of(context).iconTheme,
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
                bottom: TabBar(
                  controller: _nestedTabController,
                  //indicatorColor: Theme.of(context).textTheme.caption.color,
                  //isScrollable: true,
                  onTap: (index) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "with old password",
                          //style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "with otp",
                          //style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              body: TabBarView(
                controller: _nestedTabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              onChanged: (value) {
                                opassword = value;
                              },
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Old Password"),
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                npassword = value;
                              },
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
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
                                  onPressed: () {
                                    setState(() {
                                      isloading = true;
                                    });
                                    change_password1(opassword, npassword);
                                    setState(() {
                                      isloading = false;
                                    });
                                  },
                                  child: Text(
                                    'Change',
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
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Comming soon',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
