import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  void initState() {
    loadPref();
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
              "Posted Events",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    LineIcons.refresh,
                    color: Theme.of(context).textTheme.caption.color,
                    size: 27,
                  ),
                  onPressed: () {
                    context.read<EventsRepository>().refreshData();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Events Refreshed"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }),
            ],
            centerTitle: true,
          ),
          body: ListView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              for (var i = 0; i < model.allEvents.length; i++)
                if (model.allEvents[i].user_id.toString().trim() ==
                    prefId.toString().trim()) ...[
                  EventTileAdmin(true, i, "myevents_info_page")
                ],
            ],
          ),
        ),
      );
    });
  }
}
