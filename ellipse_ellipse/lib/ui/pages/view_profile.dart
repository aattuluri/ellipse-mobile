import 'package:cached_network_image/cached_network_image.dart';
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
import '../../repositories/index.dart';
import '../../models/index.dart';

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
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
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
                    SizedBox(width: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Theme.of(context).textTheme.caption.color),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(540),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.view_profile);
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${Url.URL}/api/image?id=${_userdetails.profile_pic}",
                              placeholder: (context, url) => Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.9,
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _userdetails.name,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(_userdetails.email),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.edit_profile);
                          },
                          child: Container(
                            height: 40.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  elevation: 7.0,
                  color: Theme.of(context)
                      .textTheme
                      .caption
                      .color
                      .withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.person_pin_circle_outlined,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                            _userdetails.username,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.person_outline,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                            _userdetails.name,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.wc,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Gender",
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
                            _userdetails.gender,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.email,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                            _userdetails.email,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.phone,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.account_balance,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                            _userdetails.college_name,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.accessibility,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
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
                            _userdetails.bio,
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
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.work,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Designation",
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
                            _userdetails.designation,
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
                      ],
                    ),
                  ),
                ),
              ),
              /*
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
              */
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
