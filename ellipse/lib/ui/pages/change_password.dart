import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../screens/index.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  bool isloading = false;
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

  forgot_password() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response =
        await http.post("${Url.URL}/api/users/logout", headers: headers);
    setState(() {
      sharedPreferences.setString("token", "");
      sharedPreferences.setString("id", "");
      sharedPreferences.setString("email", "");
      sharedPreferences.setBool(Constants.LOGGED_IN, false);
    });
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => ResetPassword("enter_email"));
    Navigator.of(context).push(route);
  }

  change_password1(String opassword, npassword) async {
    setState(() {
      isloading = true;
    });
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
      setState(() {
        isloading = false;
      });
      Navigator.pushNamed(context, Routes.signin);
    }
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
                            opassword = value;
                          },
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
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
                            color: Theme.of(context).textTheme.caption.color,
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
                        SizedBox(height: 20),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              forgot_password();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Text('Forgot Password ?',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
  }
}
