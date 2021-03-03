import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  bool isLoading = false;
  String name, username, email, college, designation, password, cpassword;
  var designationController = new TextEditingController();
  var collegeController = new TextEditingController();
  String pass, collegeId;
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

  signUp(String name, String username, String email, String college,
      String designation, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var response1 = await httpPostWithoutHeaders(
      "${Url.URL}/api/check_email_exists",
      {'email': email},
    );
    var response2 = await httpPostWithoutHeaders(
      "${Url.URL}/api/check_username",
      {'username': username},
    );
    if (response1.statusCode == 201 && response2.statusCode == 401) {
      Map data3 = {
        'name': name,
        'username': username,
        'email': email,
        'designation': designation,
        'college_id': collegeId,
        'password': pass,
        'type': "app",
        'device_os': "Android",
        'device_name': '${androidInfo.model}'
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
          Navigator.pushNamed(context, Routes.initialization);
        }
        flutterToast(
            context, 'Registration successful', 2, ToastGravity.CENTER);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else if (response1.statusCode == 200 && response2.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      messageDialog(context, 'Email already registered');
    } else if (response1.statusCode == 201 && response2.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      messageDialog(context, 'Username already exists');
    } else if (response1.statusCode == 200 && response2.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      messageDialog(context, 'Email & Username already exists');
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
        child: Consumer<DataRepository>(
          builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.signin,
                    );
                  }),
              elevation: 4,
              title: Text(
                "Signup",
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
                ? LoaderCircular("Registering")
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                          this.setState(() => errors.add(
                                              "Name field cannot be empty"));
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "College",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                      Icons.account_balance,
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
                                        onSaved: (value) => college = value,
                                        controller: collegeController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            this.setState(() => errors.add(
                                                "College field cannot be empty"));
                                            //return "Username field cannot be empty";
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        obscureText: false,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            border: InputBorder.none,
                                            hintText: 'Select College'),
                                        onTap: () {
                                          showDropdownSearchDialog(
                                              context: context,
                                              items: model.collegesData,
                                              addEnabled: false,
                                              onChanged:
                                                  (String key, String value) {
                                                setState(() {
                                                  collegeController =
                                                      new TextEditingController(
                                                          text: value);
                                                  collegeId = key;
                                                });
                                              });
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Designation",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                      Icons.accessibility_new,
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
                                        onSaved: (value) => designation = value,
                                        controller: designationController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            this.setState(() => errors.add(
                                                "Designation field cannot be empty"));
                                            //return "Username field cannot be empty";
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        obscureText: false,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                        cursorColor: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            border: InputBorder.none,
                                            hintText: 'Select Designation'),
                                        onTap: () {
                                          showDropdownSearchDialog(
                                              context: context,
                                              items: model.designationsData,
                                              addEnabled: false,
                                              onChanged:
                                                  (String key, String value) {
                                                setState(() {
                                                  designationController =
                                                      new TextEditingController(
                                                          text: value);
                                                });
                                              });
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                      onChanged: (value) {
                                        setState(() {
                                          pass = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          this.setState(() => errors.add(
                                              "Password field cannot be empty"));
                                          //return "Password field cannot be empty";
                                        } else if (value.toString().length <
                                            6) {
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                                        } else if (value.toString().length <
                                            6) {
                                          this.setState(() => errors.add(
                                              "Password length should be \natleast 6 characters"));
                                          //return "Password length should be \natleast 6 characters";
                                        } else if (value != pass ||
                                            pass != value) {
                                          this.setState(() => errors.add(
                                              "password and confirm password should be same"));
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Acceptance('By signing up,I accept the ', true),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                            print(collegeId);
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
                                                  collegeId.trim(),
                                                  designation.trim(),
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
      ),
    );
  }
}
