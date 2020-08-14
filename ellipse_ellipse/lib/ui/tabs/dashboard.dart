import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../ui/pages/post_event.dart';
import '../../util/index.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';
import '../widgets/index.dart';
import '../screens/index.dart';

class DashboardTab extends StatefulWidget {
  DashboardTab({Key key}) : super(key: key);

  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          //padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 15, bottom: 0),
                              child: Center(
                                child: Text(
                                  'Dashboard',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Separator.divider(indent: 16),
                            SizedBox(height: 8),
                          ],
                        ),
                    childCount: 1),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderText("Events"),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.post_event),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Card(
                                    elevation: 0,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: ListCell.icon(
                                      icon: Icons.add_a_photo,
                                      title: "Post Event",
                                      subtitle: "post your event",
                                      //trailing: Icon(Icons.chevron_right),
                                      //onTap: () => Navigator.pushNamed(
                                      //context, Routes.post_event),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.my_events),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Card(
                                    elevation: 0,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: ListCell.icon(
                                      icon: Icons.event_available,
                                      title: 'Your Events',
                                      subtitle: '10 Events',
                                      //trailing: Icon(Icons.chevron_right),
                                      //onTap: () => Navigator.pushNamed(
                                      //   context, Routes.my_events),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Test(),
                                  );
                                  Navigator.of(context).push(route);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Card(
                                    elevation: 0,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: ListCell.icon(
                                      icon: Icons.adb,
                                      title: 'Test Screen',
                                      subtitle: 'Test',
                                    ),
                                  ),
                                ),
                              ),
                              Separator.divider(indent: 72),
                              ListCell.icon(
                                icon: Icons.event_note,
                                title: 'Registered Events',
                                subtitle: '5 Events',
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {},
                              ),
                              Separator.divider(indent: 72),
                              ListCell.icon(
                                icon: Icons.favorite,
                                title: 'Favourites',
                                subtitle: '10 Favourites',
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {},
                              ),
                              Separator.divider(indent: 72),
                              ListCell.icon(
                                icon: Icons.timer,
                                title: 'Past Events',
                                subtitle: '50 Events',
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {},
                              ),
                              Separator.divider(indent: 72),
                            ],
                          ),
                        ),
                    childCount: 1),
              ),
              SliverGrid.count(
                crossAxisCount: 2,
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.post_event),
                    child: EventGridTile(
                        Icons.add_a_photo, "Post Event", "Post your events"),
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.my_events),
                    child: EventGridTile(
                        Icons.event_available, 'My Events', '10 Events'),
                  ),
                  EventGridTile(
                      Icons.event_note, 'Registered Events', '5 Events'),
                  EventGridTile(Icons.favorite, 'Favourites', '10 Favourites'),
                  EventGridTile(
                      Icons.announcement, 'Announcements', '5 Announcements'),
                  EventGridTile(Icons.message, 'My Chats', '10 Chats'),
                  EventGridTile(Icons.timer, 'Past Events', '50 Events'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
