import 'dart:math';
import 'dart:convert';
import '../../util/routes.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../widgets/index.dart';
import '../screens/index.dart';

class ResetPassword extends StatefulWidget {
  final String type;
  ResetPassword(this.type);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _key = new GlobalKey<FormState>();
  String email = "", password = "", cpassword = "", verification_email = "";
  bool isLoading = false;
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

  reset_password() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      verification_email = preferences.getString("verification_email");
    });
    http.Response response = await http.post(
      '${Url.URL}/api/users/reset_password',
      body: {'email': '$verification_email', 'password': '$password'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, Routes.signin);
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.signin,
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
                              Text('Back to Login',
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
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Ell',
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffe46b10),
                              ),
                              children: [
                                TextSpan(
                                  text: 'i',
                                  style: TextStyle(
                                      color: Color.fromRGBO(128, 0, 0, 1),
                                      fontSize: 50),
                                ),
                                TextSpan(
                                  text: 'pse',
                                  style: TextStyle(
                                      color: Color(0xffe46b10), fontSize: 50),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(height: 30),
                      widget.type == "enter_email"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                        child: TextField(
                                          onChanged: (value) {
                                            email = value;
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
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
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
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
                                                    "GET OTP",
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
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.setString(
                                                "verification_email", email);
                                            var route = new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OtpPageEmailVerify(
                                                      email.trim(),
                                                      "reset_password"),
                                            );
                                            Navigator.of(context).push(route);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          : widget.type == "enter_password"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
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
                                                          : Icons
                                                              .visibility_off,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                                border: InputBorder.none,
                                                hintText: 'Enter your password',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
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
                                                          : Icons
                                                              .visibility_off,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                                border: InputBorder.none,
                                                hintText: 'Enter your password',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
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
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: Text(
                                                        "RESET PASSWORD",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
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
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: Icon(
                                                          Icons.arrow_forward,
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (password != cpassword) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Both password should be same",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.TOP,
                                                      textColor: Colors.white,
                                                      timeInSecForIosWeb: 2,
                                                      backgroundColor:
                                                          Colors.black);
                                                } else {
                                                  reset_password();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
