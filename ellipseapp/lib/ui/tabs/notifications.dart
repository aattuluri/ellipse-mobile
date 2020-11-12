import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class NotificationsTab extends StatefulWidget {
  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  void initState() {
    context.read<NotificationsRepository>().refreshData();
    updateSeenNotifications(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsRepository>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 5,
          title: Text(
            "Notifications",
            style: TextStyle(color: Theme.of(context).textTheme.caption.color),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
                icon: Icon(
                  LineIcons.refresh,
                  color: Theme.of(context).textTheme.caption.color,
                  size: 27,
                ),
                onPressed: () {
                  context.read<NotificationsRepository>().refreshData();
                }),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: model.allNotifications.isEmpty
            ? EmptyData('No notifications', "You don't have notifications",
                Icons.notifications_none)
            : ListView(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  for (var i = 0; i < model.allNotifications.length; i++) ...[
                    NotificationItem(
                      num: model.allNotifications.length - i,
                      status: model.allNotifications[i].status,
                      onTap: () {
                        final _event = context
                            .read<EventsRepository>()
                            .getEventIndex(model.allNotifications[i].event_id);
                        final Events event_ =
                            context.read<EventsRepository>().getEvent(_event);
                        if (_event.toString().validNumeric()) {
                          Navigator.pushNamed(context, Routes.info_page,
                              arguments: {
                                'index': _event,
                                'type': 'user',
                                'event_': event_
                              });
                        }
                      },
                      time: model.allNotifications[i].time
                          .toString()
                          .toDate(context),
                      title: model.allNotifications[i].title,
                      description: model.allNotifications[i].description,
                    )
                  ]
                ],
              ),
      );
    });
  }
}
