import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';

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

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String token = "", id = "", email = "", college = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("eveid", "");
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college = preferences.getString("college");
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 4,
            title: Text(
              "My Events",
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
                  onPressed: () => _onRefresh(context, model)),
            ],
            centerTitle: true,
          ),
          body: model.isLoading || model.loadingFailed
              ? _loadingIndicator
              :
              /* GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: model.allEvents?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final Events event = model.allEvents[index];
                    final sdate = DateTime.parse(event.start_time);
                    print(sdate);
                    return event.user_id.toString().trim() ==
                            id.toString().trim()
                        ? EventTile2(event.name, event.imageUrl, index)
                        : Container();
                  }),*/

              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  itemCount: model.allEvents?.length,
                  //shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final Events event = model.allEvents[index];
                    final sdate = DateTime.parse(event.start_time);
                    print(sdate);
                    return event.user_id.toString().trim() ==
                            id.toString().trim()
                        ? EventTile1(index, "myevents_info_page")
                        : Container();
                  }),
        ),
      ),
    );
  }
}
