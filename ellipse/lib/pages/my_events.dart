import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_event.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String id = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    getPref();
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
          "My Events",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(child: SizedBox()),
    );
  }
}

class Eve {
  final String eid;
  final String eurl;

  Eve(this.eid, this.eurl);
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final _key = new GlobalKey<FormState>();

  void _deleteEvent() async {
    print("");
    var response = await http.post("", body: {
      "imageid": "",
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
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void _editEvent() async {}

  void _downloadEvent() async {}

  void _shareEvent() async {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '',
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.file_download),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Download'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Share'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 1:
                  {
                    _editEvent();
                    break;
                  }
                case 2:
                  {
                    _deleteEvent();
                    break;
                  }
                case 3:
                  {
                    _downloadEvent();
                    break;
                  }
                case 4:
                  {
                    _shareEvent();
                    break;
                  }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: new Center(
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    child: new Text(
                      '',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  Padding(
                    //`widget` is the current configuration. A State object's configuration
                    //is the corresponding StatefulWidget instance.
                    child: Image.network(''),
                    padding: EdgeInsets.all(5.0),
                  ),
                  Padding(
                    child: new Text(
                      'Name : ',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    padding: EdgeInsets.all(20.0),
                  ),
                  Padding(
                    child: new Text(
                      'Description : ',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    padding: EdgeInsets.all(20.0),
                  ),
                  Padding(
                    child: new Text(
                      'Fdate : ',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    padding: EdgeInsets.all(20.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
