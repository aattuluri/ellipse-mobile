import 'dart:convert';

import 'package:EllipseApp/ui/pages/help_and_support.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email, password;
  bool isLoading = false;
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var response1 = await httpPostWithoutHeaders(
      "${Url.URL}/api/check_email_exists",
      {'email': email},
    );
    if (response1.statusCode == 200) {
      Map data2 = {
        'email': email,
        'password': pass,
        'type': "app",
        'device_os': "Android",
        'device_name': '${androidInfo.model}'
      };
      http.Response response2 =
          await http.post("${Url.URL}/api/users/login", body: data2).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          Navigator.pushNamed(context, Routes.signin);
          messageDialog(context, 'Something went wrong please try again');
          return null;
        },
      );
      if (response2.statusCode == 200) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        var jsonResponse = json.decode(response2.body);
        print('Response status: ${response2.statusCode}');
        print('Response body: ${response2.body}');
        if (jsonResponse != null) {
          setState(() {
            sharedPreferences.setString("email", jsonResponse['useremail']);
            sharedPreferences.setString("token", jsonResponse['token']);
            sharedPreferences.setString("id", jsonResponse['userid']);
          });
          Navigator.pushNamed(context, Routes.initialization);
          setState(() {
            sharedPreferences.setBool('loggedIn', true);
          });
        }
        flutterToast(context, 'Login successful', 2, ToastGravity.BOTTOM);
      } else {
        setState(() {
          isLoading = false;
        });
        messageDialog(context, 'Invalid Password');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      messageDialog(context, 'Email does not exist');
    }
  }

  @override
  void initState() {
    this.setState(() => errors.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    resetPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.intro,
                  );
                }),
            elevation: 4,
            title: Text(
              "Login",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [],
            centerTitle: true,
          ),
          body: isLoading
              ? LoaderCircular("Signing In")
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Ellipse",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 45,
                                  fontFamily: 'Gugi',
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            child: Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  height: 30.0,
                                  width: 1.0,
                                  color: Colors.grey.withOpacity(0.5),
                                  margin: const EdgeInsets.only(
                                      left: 00.0, right: 10.0),
                                ),
                                new Expanded(
                                  child: TextFormField(
                                    onSaved: (value) => email = value,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        this.setState(() => errors.add(
                                            "Email field cannot be empty"));
                                        // return "Email field cannot be empty";
                                      } else if (!value.validEmail()) {
                                        this.setState(() =>
                                            errors.add("Enter valid email"));
                                        //return "Enter valid email";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Password",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            child: Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  height: 30.0,
                                  width: 1.0,
                                  color: Colors.grey.withOpacity(0.5),
                                  margin: const EdgeInsets.only(
                                      left: 00.0, right: 10.0),
                                ),
                                new Expanded(
                                  child: TextFormField(
                                    onSaved: (value) => password = value,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        this.setState(() => errors.add(
                                            "Password field cannot be empty"));
                                        //return "Password field cannot be empty";
                                      } else if (value.toString().length < 6) {
                                        this.setState(() => errors.add(
                                            "Password length should be \natleast 6 characters"));
                                        //return "Password length should be \natleast 6 characters";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    obscureText: _secureText,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: showHide,
                                        icon: Icon(
                                            _secureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Enter your password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    splashColor: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.6),
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: new Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                            ),
                                          ),
                                          new Expanded(
                                            child: Container(),
                                          ),
                                          new Transform.translate(
                                            offset: Offset(15.0, 0.0),
                                            child: new Container(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (errors.isEmpty) {
                                          _formKey.currentState.save();
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          setState(() {
                                            isLoading = true;
                                          });
                                          signIn(email.trim(), password.trim());
                                        } else if (errors.isNotEmpty) {
                                          String error = "";
                                          for (var i = 0;
                                              i < errors.length;
                                              i++) {
                                            error = error +
                                                (i != 0 ? "\n" : "") +
                                                "-" +
                                                errors[i].toString();
                                          }
                                          alertDialog(context, "Login", error);

                                          this.setState(() => errors.clear());
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          FlatButton(
                            onPressed: () async {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ResetPassword("enter_email"));
                              Navigator.of(context).push(route);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Text('Forgot Password ?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              //padding: EdgeInsets.symmetric(horizontal: ),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Don\'t have an account ?',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HelpAndSupport()));
                            },
                            child: Text(
                              'Help & Support',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).accentColor),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
