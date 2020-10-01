import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());

class RegisteredEvents extends StatefulWidget {
  @override
  _RegisteredEventsState createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents> {
  bool isloading = false;
  List<dynamic> registered = [];
  loadRegEvents() async {
    context.read<EventsRepository>().refreshData();
    setState(() {
      isloading = true;
    });
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get(
        "${Url.URL}/api/user/registeredEvents?id=$prefId",
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
    loadPref();
    loadRegEvents();

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
                    //getPref();
                  }),
            ],
            centerTitle: true,
          ),
          body: model.isLoading || model.loadingFailed
              ? _loadingIndicator
              : /*ListView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (var i = 0; i < model.allEvents.length; i++) ...[
                      if (model.allEvents[i].registered == true) ...[
                        EventTile1(true, i, "info_page")
                      ]
                    ]
                  ],
                ),
          */
              ListView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (var i = 0; i < model.allEvents.length; i++) ...[
                      for (var j = 0; j < registered.length; j++) ...[
                        if (registered[j]['user_id'] == prefId &&
                            registered[j]['event_id'] ==
                                model.allEvents[i].id) ...[
                          EventTileGeneral(true, i, "info_page")
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
