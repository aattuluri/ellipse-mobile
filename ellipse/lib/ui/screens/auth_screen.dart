import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../util/routes.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signin()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signup()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      children: <Widget>[
        Text(
          "ELL",
          style: TextStyle(
              color: Colors.white, fontSize: 45, fontWeight: FontWeight.w800),
        ),
        Text(
          "IPSE",
          style: TextStyle(
              color: Color(0xffFFA700),
              fontSize: 45,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }

  reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", "");
      preferences.setString("id", "");
      preferences.setString("email", "");
      preferences.setBool(Constants.LOGGED_IN, false);
    });
  }

  @override
  void initState() {
    reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Positioned.fill(child: AnimatedBackground()),
          Positioned.fill(child: Particles(30)),
          Positioned.fill(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Kill time for what matters',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: 80,
                ),
                _submitButton(),
                SizedBox(
                  height: 20,
                ),
                _signUpButton(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),

          //_label()
        ],
      ),
    );
  }
}

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _key = new GlobalKey<FormState>();
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
    Map data = {'email': email, 'password': pass};
    http.Response response =
        await http.post("${Url.URL}/api/users/login", body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          sharedPreferences.setString("email", jsonResponse['useremail']);
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setString("id", jsonResponse['userid']);
        });
        setState(() {
          sharedPreferences.setBool(Constants.LOGGED_IN, true);
          isLoading = false;
        });
        Navigator.pushNamed(context, Routes.initialization);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print("fdxgchvjbk");
    }
  }

  reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", "");
      preferences.setString("id", "");
      preferences.setString("email", "");
      preferences.setBool(Constants.LOGGED_IN, false);
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    reset();
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
          body: Form(
            key: _key,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: 10,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: Container()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        /*
                        InkWell(
                          onTap: () {
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new AuthScreen(),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, bottom: 10),
                                  child: Icon(Icons.keyboard_arrow_left,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                                Text('Back',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color))
                              ],
                            ),
                          ),
                        ),
                        */
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Ellipse",
                            style: TextStyle(
                                //color: Theme.of(context)
                                //     .textTheme
                                //  .caption
                                //  .color
                                //.withOpacity(0.8),
                                color: Theme.of(context).accentColor,
                                fontSize: 45,
                                fontFamily: 'Gugi',
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(height: 30),
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
                                child: TextField(
                                  onChanged: (value) {
                                    email = value;
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
                                child: TextField(
                                  onChanged: (value) {
                                    password = value;
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
                        SizedBox(height: 10),
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
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(email);
                                    if (!emailValid) {
                                      Fluttertoast.showToast(
                                          msg: "Enter Valid Email",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          textColor: Colors.white,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.black);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      signIn(email.trim(), password.trim());
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
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
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
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          ),
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;

  String name, username, email, password, cpassword;

  bool _secureText1 = true;
  bool _secureText2 = true;

  showHide1() {
    setState(() {
      _secureText1 = !_secureText1;
    });
  }

  showHide2() {
    setState(() {
      _secureText2 = !_secureText2;
    });
  }

  signUp(String name, username, email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'username': username,
      'email': email,
      'password': pass
    };
    http.Response response =
        await http.post("${Url.URL}/api/users/signup", body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
          sharedPreferences.setString("email", jsonResponse['useremail']);
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setString("id", jsonResponse['userid']);
        });
        setState(() {
          sharedPreferences.setBool(Constants.LOGGED_IN, true);
        });
        Navigator.pushNamed(context, Routes.initialization);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }

  reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", "");
      preferences.setString("id", "");
      preferences.setString("email", "");
      preferences.setBool(Constants.LOGGED_IN, false);
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    reset();
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
          body: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      /*
                      InkWell(
                        onTap: () {
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new AuthScreen(),
                          );
                          Navigator.of(context).push(route);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(left: 0, top: 10, bottom: 10),
                                child: Icon(Icons.keyboard_arrow_left,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                              ),
                              Text('Back',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color))
                            ],
                          ),
                        ),
                      ),
                      */
                      Center(
                        child: Text(
                          "Ellipse",
                          style: TextStyle(
                              //color: Theme.of(context)
                              //     .textTheme
                              //  .caption
                              //  .color
                              //.withOpacity(0.8),
                              color: Theme.of(context).accentColor,
                              fontSize: 45,
                              fontFamily: 'Gugi',
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Name",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                                Icons.person_outline,
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
                              child: TextField(
                                onChanged: (value) {
                                  name = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your name',
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
                          "Username",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                                Icons.person_outline,
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
                              child: TextField(
                                onChanged: (value) {
                                  username = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your username',
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
                          "Email",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                              child: TextField(
                                onChanged: (value) {
                                  email = value;
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
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                              child: TextField(
                                onChanged: (value) {
                                  password = value;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: _secureText1,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: showHide1,
                                    icon: Icon(
                                        _secureText1
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                              child: TextField(
                                onChanged: (value) {
                                  cpassword = value;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: _secureText2,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: showHide2,
                                    icon: Icon(
                                        _secureText2
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                              "REGISTER NOW",
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
                                      if (!email.validEmail()) {
                                        Fluttertoast.showToast(
                                            msg: "Enter Valid Email",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54);
                                      } else if (!username
                                          .validAlphaNumeric()) {
                                        Fluttertoast.showToast(
                                            msg: "Enter Valid Username",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54);
                                      } else if (!name.validAlpha()) {
                                        Fluttertoast.showToast(
                                            msg: "Enter Valid Nmae",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54);
                                      } else if (cpassword != password) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Both passwords should be same",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54);
                                      } else if (!password.validLength(5)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Password length must be atleast 6",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.black54);
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        signUp(
                                          name.trim(),
                                          username.trim(),
                                          email.trim(),
                                          password.trim(),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          //padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account ?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Login',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
