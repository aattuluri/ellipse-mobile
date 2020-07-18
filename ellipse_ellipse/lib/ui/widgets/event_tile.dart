import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../../util/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../util/index.dart';

class EventTile1 extends StatefulWidget {
  final String name, image_url;
  final int index;
  EventTile1(this.name, this.image_url, this.index);
  @override
  State createState() => new EventTile1State();
}

class EventTile1State extends State<EventTile1> {
  String _base64;
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
    (() async {
      http.Response response = await http.get(
        "${Url.URL}/api/event/image/:${widget.image_url}",
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var jsonResponse = json.decode(response.body);

      setState(() {
        _base64 = jsonResponse['image'];
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 5.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 7.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            Routes.info_page,
            arguments: {'index': widget.index},
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      "https://d1dhn91mufybwl.cloudfront.net/collections/items/856aaec61aa77da73b05737i38712271/covers/page_1/medium",
                  //"http://cumminsblogdotorg.files.wordpress.com/2012/09/pentacle13-poster-comp.jpg",
                  filterQuality: FilterQuality.high,
                  fadeInDuration: Duration(milliseconds: 1000),
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Icon(
                      Icons.image,
                      size: 80,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Icon(
                      Icons.error,
                      size: 80,
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.black38])),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "VIT University,Vellore",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "fuyg",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          Text("19 July,2020", style: TextStyle())
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventTile2 extends StatefulWidget {
  final String name, image_url;
  final int index;
  EventTile2(this.name, this.image_url, this.index);
  @override
  State createState() => new EventTile2State();
}

class EventTile2State extends State<EventTile2> {
  String _base64;
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
    (() async {
      http.Response response = await http.get(
        "${Url.URL}/api/event/image/:${widget.image_url}",
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var jsonResponse = json.decode(response.body);

      setState(() {
        _base64 = jsonResponse['image'];
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 5.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 7.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            Routes.my_events_info_page,
            arguments: {'index': widget.index},
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      "https://d1dhn91mufybwl.cloudfront.net/collections/items/856aaec61aa77da73b05737i38712271/covers/page_1/medium",
                  //"http://cumminsblogdotorg.files.wordpress.com/2012/09/pentacle13-poster-comp.jpg",
                  filterQuality: FilterQuality.high,
                  fadeInDuration: Duration(milliseconds: 1000),
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Icon(
                      Icons.image,
                      size: 80,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Icon(
                      Icons.error,
                      size: 80,
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.black38])),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "VIT University,Vellore",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "fuyg",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          Text("19 July,2020", style: TextStyle())
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventTile3 extends StatelessWidget {
  final String image_url;
  final int index;

  const EventTile3(this.image_url, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 5.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            Routes.my_events_info_page,
            arguments: {'index': index},
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Image.memory(base64Decode(image_url.toString()),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
