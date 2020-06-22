import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _key = new GlobalKey<FormState>();

  String id = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  var _opasswordController = new TextEditingController();
  var _npasswordController = new TextEditingController();

  void _updatePassword() async {
    var url = "users/update_password.php";

    var response = await http.post(url, body: {
      "iduser": id,
      "opassword": _opasswordController.text,
      "npassword": _npasswordController.text,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      UToast(message);
    } else if (value == 0) {
      UToast(message);
    } else {
      UToast("Failed to connect to database");
    }
  }

  UToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  Timer timer;
  @override
  void initState() {
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getPref());
    getPref();
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _updatePassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Update Password",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please enter old password";
                  }
                },
                onSaved: (e) => e,
                controller: _opasswordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Old Password"),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please enter new password";
                  }
                },
                onSaved: (e) => e,
                controller: _npasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "New Password",
                ),
                maxLines: 1,
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {});
                check();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                "Update",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
