import 'package:EllipseApp/providers/searchProvider.dart';
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

class _NotificationsTabState extends State<NotificationsTab>
    with SingleTickerProviderStateMixin {
  bool isSearching = false;
  @override
  void initState() {
    updateSeenNotifications(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationsRepository, SearchProvider>(
        builder: (context, notification, search, child) {
      return Scaffold(
        appBar: isSearching
            ? AppBar(
                automaticallyImplyLeading: false,
                title: SearchAppBar(
                  hintText: 'Search',
                  onChanged: (value) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .changeSearchText(value);
                  },
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .reset();
                        setState(() {
                          isSearching = false;
                        });
                      },
                      child: Text('Cancel'))
                ],
              )
            : AppBar(
                iconTheme: Theme.of(context).iconTheme,
                elevation: 5,
                title: Text(
                  "Notifications",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: [
                  IconButton(
                      icon: Icon(
                        LineIcons.refresh,
                      ),
                      onPressed: () {
                        context.read<NotificationsRepository>().refreshData();
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
                ],
                automaticallyImplyLeading: false,
                centerTitle: true,
              ),
        body: notification.isLoading || notification.loadingFailed
            ? LoaderCircular("Loading Notifications")
            : notification.allNotifications.isEmpty
                ? EmptyData('No notifications', "You don't have notifications",
                    Icons.notifications_none)
                : ListView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (var i = 0;
                          i < notification.allNotifications.length;
                          i++) ...[
                        if (!isSearching ||
                            notification.allNotifications[i].title
                                .toLowerCase()
                                .contains(search.searchText
                                    .toLowerCase()
                                    .trim())) ...[
                          NotificationItem(
                            num: notification.allNotifications.length - i,
                            status: notification.allNotifications[i].status,
                            onTap: () {
                              final Events _event = context
                                  .read<EventsRepository>()
                                  .event(
                                      notification.allNotifications[i].eventId);
                              Navigator.pushNamed(context, Routes.info_page,
                                  arguments: {
                                    'type': 'user',
                                    'event_': _event
                                  });
                            },
                            time: notification.allNotifications[i].time
                                .toString()
                                .toDate(context),
                            title: notification.allNotifications[i].title,
                            description:
                                notification.allNotifications[i].description,
                          )
                        ]
                      ]
                    ],
                  ),
      );
    });
  }
}
