import '../../ui/pages/post_event.dart';
import '../../util/index.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';
import '../widgets/index.dart';

class EventTab extends StatefulWidget {
  EventTab({Key key}) : super(key: key);

  _EventTabState createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  'Events Dashboard',
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
