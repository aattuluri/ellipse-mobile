import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
              "Registered Events",
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
          body: model.isLoading || model.loadingFailed
              ? _loadingIndicator
              : model.allRegistrations.isEmpty
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: EmptyData(
                          'No Registered Events',
                          "You have not registered to any event",
                          Icons.event_busy_outlined),
                    )
                  : ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < model.allEvents.length; i++) ...[
                          for (var j = 0;
                              j < model.allRegistrations.length;
                              j++) ...[
                            if (model.allRegistrations[j].user_id == prefId &&
                                model.allRegistrations[j].event_id ==
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
