import 'dart:convert';

import 'package:Ellipse/ui/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    Map data1 = {'email': email};
    http.Response response1 =
        await http.post("${Url.URL}/api/check_email_exists", body: data1);
    if (response1.statusCode == 200) {
      Map data2 = {'email': email, 'password': pass};
      http.Response response2 =
          await http.post("${Url.URL}/api/users/login", body: data2);
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
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        alertDialog(context, "Login", "Invalid Password");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      alertDialog(context, "Login", "Email does not exist");
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
          body: isLoading
              ? LoaderCircular(0.25, "Signing")
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.intro,
                              );
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
                                  Text('Intro',
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
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
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
    Map data1 = {'email': email};
    Map data2 = {'username': username};
    http.Response response1 =
        await http.post("${Url.URL}/api/check_email_exists", body: data1);
    http.Response response2 =
        await http.post("${Url.URL}/api/check_username", body: data2);
    if (response1.statusCode == 201 && response2.statusCode == 401) {
      Map data3 = {
        'name': name,
        'username': username,
        'email': email,
        'password': pass
      };
      http.Response response3 =
          await http.post("${Url.URL}/api/users/signup", body: data3);
      print(response3.statusCode);
      print(response3.body);
      if (response3.statusCode == 200) {
        var jsonResponse = json.decode(response3.body);
        if (jsonResponse != null) {
          setState(() {
            sharedPreferences.setString("email", jsonResponse['useremail']);
            sharedPreferences.setString("token", jsonResponse['token']);
            sharedPreferences.setString("id", jsonResponse['userid']);
            sharedPreferences.setBool('loggedIn', true);
          });
          setState(() {
            isLoading = false;
          });

          Navigator.pushNamed(context, Routes.initialization);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else if (response1.statusCode == 200 && response2.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      alertDialog(context, "Sign Up", "Email already exists");
    } else if (response1.statusCode == 201 && response2.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      alertDialog(context, "Sign Up", "Username already exists");
    } else if (response1.statusCode == 200 && response2.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      alertDialog(context, "Sign Up",
          "-Eamil already exists\n-Username already exixts");
    } else {}
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
          body: isLoading
              ? LoaderCircular(0.25, "Registering")
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
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
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Name",
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
                                  child: TextFormField(
                                    onSaved: (value) => name = value,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        this.setState(() => errors
                                            .add("Name field cannot be empty"));
                                        //return "Name field cannot be empty";
                                      } else if (!value.validAlpha()) {
                                        this.setState(() => errors.add(
                                            "Name should only contain alphabets"));
                                        //return "Name should only contain alphabets";
                                      }
                                      return null;
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
                                  child: TextFormField(
                                    onSaved: (value) => username = value,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        this.setState(() => errors.add(
                                            "Username field cannot be empty"));
                                        //return "Username field cannot be empty";
                                      } else if (!value.validAlphaNumeric()) {
                                        this.setState(() => errors.add(
                                            "Username should only contain alphabets and numbers"));
                                        //return "Username should only contain alphabets and numbers";
                                      }
                                      return null;
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
                                        //return "Email field cannot be empty";
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
                                    onSaved: (value) => cpassword = value,
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
                                      hintText: 'Retype your password',
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
                                                new BorderRadius.circular(
                                                    30.0)),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (errors.isEmpty) {
                                              _formKey.currentState.save();
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                              setState(() {
                                                isLoading = true;
                                              });
                                              signUp(
                                                name.trim(),
                                                username.trim(),
                                                email.trim(),
                                                password.trim(),
                                              );
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
                                              alertDialog(
                                                  context, "Sign Up", error);

                                              this.setState(
                                                  () => errors.clear());
                                            }
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
                                      builder: (context) => SignIn()));
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
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
                ),
        ),
      ),
    );
  }
}
