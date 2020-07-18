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
class ViewProfile extends StatefulWidget {
  const ViewProfile({Key key}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
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
            "Profile",
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
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 30.0),
                    Container(
                        width: 100.0,
                        height: 100.0,
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                                radius: 45.0,
                                backgroundImage: AssetImage("assets/g.png")))),
                    SizedBox(width: 30.0),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.edit_profile);
                      },
                      child: Container(
                        height: 40.0,
                        width: 170.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.edit, size: 25),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 19.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Your Profile",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_pin_circle, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "guna0027",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person_outline, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "Gunasekhar",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.email, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "gunasekhar2357@gmail.com",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.phone, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "+91 7995057295",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_balance, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Your College",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "VIT University,Vellore",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.accessibility, size: 33),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Separator.spacer(space: 4),
                  ],
                ),
                subtitle: Text(
                  "Over 8+ years of experience and web development and 5+ years of experience in mobile applications development ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ProductSans',
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                // trailing: trailing,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                onTap: () {},
              ),
              SizedBox(height: 20.0),
              _buildTitle("Skills"),
              SizedBox(height: 10.0),
              _buildSkillRow("Wordpress", 0.75),
              SizedBox(height: 5.0),
              _buildSkillRow("Laravel", 0.6),
              SizedBox(height: 5.0),
              _buildSkillRow("React JS", 0.65),
              SizedBox(height: 5.0),
              _buildSkillRow("Flutter", 0.9),
              SizedBox(height: 20.0),
              _buildTitle("Education"),
              SizedBox(height: 5.0),
              _buildExperienceRow(
                  company: "Tribhuvan University, Nepal",
                  position: "B.Sc. Computer Science and Information Technology",
                  duration: "2011 - 2015"),
              _buildExperienceRow(
                  company: "Cambridge University, UK",
                  position: "A Level",
                  duration: "2008 - 2010"),
              _buildExperienceRow(
                  company: "Nepal Board", position: "SLC", duration: "2008"),
              SizedBox(height: 20.0),
              _buildTitle("Contact"),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 30.0),
                  Icon(
                    Icons.mail,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "dlohani48@gmail.com",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 30.0),
                  Icon(
                    Icons.phone,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "+977-9818523107",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              _buildSocialsRow(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSocialsRow() {
    return Row(
      children: <Widget>[
        SizedBox(width: 20.0),
        IconButton(
          color: Colors.indigo,
          icon: Icon(Icons.face),
          onPressed: () {},
        ),
        SizedBox(width: 5.0),
        IconButton(
          color: Colors.indigo,
          icon: Icon(Icons.face),
          onPressed: () {},
        ),
        SizedBox(width: 5.0),
        IconButton(
          color: Colors.red,
          icon: Icon(Icons.face),
          onPressed: () {},
        ),
        SizedBox(width: 10.0),
      ],
    );
  }

  ListTile _buildExperienceRow(
      {String company, String position, String duration}) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0),
        child: Icon(
          Icons.face,
          size: 12.0,
          color: Colors.black54,
        ),
      ),
      title: Text(
        company,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$position ($duration)"),
    );
  }

  Row _buildSkillRow(String skill, double level) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(
            flex: 2,
            child: Text(
              skill.toUpperCase(),
              textAlign: TextAlign.right,
            )),
        SizedBox(width: 10.0),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: level,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
