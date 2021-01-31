import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../providers/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  bool isloading = false;
  String opassword = "", npassword = "";

  forgot_password() async {
    var response = await httpPostWithHeaders("${Url.URL}/api/users/logout", '');
    resetPref();
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => ResetPassword("enter_email"));
    Navigator.of(context).push(route);
  }

  change_password1(String opassword, npassword) async {
    setState(() {
      isloading = true;
    });
    var response1 = await httpPostWithHeaders(
      '${Url.URL}/api/users/updatepassword',
      jsonEncode(<dynamic, dynamic>{
        'email': prefEmail,
        'cPassword': '$opassword',
        'nPassword': '$npassword'
      }),
    );
    if (response1.statusCode == 200) {
      setState(() {
        isloading = false;
      });
      messageDialog(context, 'Password updated successfully');
    } else if (response1.statusCode == 401) {
      setState(() {
        isloading = false;
      });
      messageDialog(context, 'Invalid Password');
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
    return isloading
        ? LoaderCircular('Updating')
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
                              labelText: "Current Password"),
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
                        RButton('Save', 13, () {
                          setState(() {
                            isloading = true;
                          });
                          change_password1(opassword, npassword);
                          setState(() {
                            isloading = false;
                          });
                        }),
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
