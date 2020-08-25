import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../../util/index.dart';
import 'package:http/http.dart' as http;

Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Error"),
          action: SnackBarAction(
            label: "Error",
            onPressed: () => _onRefresh(context, repository),
          ),
        ),
      );
    }
    completer.complete();
  });

  return completer.future;
}

class RegisteredEvents extends StatefulWidget {
  @override
  _RegisteredEventsState createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents> {
  String token = "", id = "", email = "", college_id = "";
  bool isloading = false;
  List<dynamic> registered = [];
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("eveid", "");
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
    setState(() {
      isloading = true;
    });
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get("${Url.URL}/api/user/registeredEvents?id=$id",
        headers: headers);
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        registered = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
    print(registered);
  }

  @override
  void initState() {
    getPref();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(builder: (context, model, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 4,
            title: Text(
              "Registered Events",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).textTheme.caption.color,
                    size: 27,
                  ),
                  onPressed: () {
                    getPref();
                  }),
            ],
            centerTitle: true,
          ),
          body: model.isLoading || model.loadingFailed
              ? _loadingIndicator
              : ListView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (var i = 0; i < model.allEvents.length; i++) ...[
                      for (var j = 0; j < registered.length; j++) ...[
                        if (registered[j]['user_id'] == id &&
                            registered[j]['event_id'] ==
                                model.allEvents[i].id) ...[
                          EventTile1(true, i, "info_page")
                        ]
                      ]
                    ]
                  ],
                ),
        ),
      );
    });
  }
}
