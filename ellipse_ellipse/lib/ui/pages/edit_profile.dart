import 'package:ellipseellipse/util/routes.dart';
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
class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _key = new GlobalKey<FormState>();
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
            "Edit Profile",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardPage1.body(
                  body: RowLayout(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Container(
                          width: 100.0,
                          height: 100.0,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                  radius: 45.0,
                                  backgroundImage:
                                      AssetImage("assets/g.png")))),
                      SizedBox(width: 30.0),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.edit_profile);
                        },
                        child: OutlineButton(
                          onPressed: () {},
                          borderSide: BorderSide(
                              color: Theme.of(context).textTheme.caption.color,
                              width: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Change Profile Pic',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Userame"),
                  maxLines: 1,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Name"),
                  maxLines: 1,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  maxLines: 1,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Mobile Number"),
                  maxLines: 1,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Bio"),
                  maxLines: 6,
                ),
              ])),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
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
                        'Save',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
