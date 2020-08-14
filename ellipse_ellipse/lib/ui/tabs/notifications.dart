import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';
import '../widgets/index.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key key}) : super(key: key);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool no_notifications = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 15, bottom: 0),
              child: Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.caption.color),
              ),
            ),
            SizedBox(height: 3),
            Separator.divider(indent: 16),
            no_notifications
                ? Expanded(
                    child: BigTip(
                      title: Text('No notifications'),
                      subtitle: Text("You don't have notifications"),
                      action: Container(),
                      actionCallback: () => Navigator.pop(context),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor,
                          //Theme.of(context).accentColor,
                        ),
                        child: Center(
                          child: Icon(Icons.notifications_none,
                              size: 45,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, position) {
                        return AchievementCell(
                          time: "18 June 2020,11:00 AM",
                          title: "New Event in Your college",
                          subtitle: "Rivera2020 - Fest",
                          body: "From 20 June to 28 June",
                          index: 1,
                        );
                      },
                    ),
                  ),
            /*
            Column(
              children: [
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
                AchievementCell(
                  time: "18 June 2020,11:00 AM",
                  title: "New Event in Your college",
                  subtitle: "Rivera2020 - Fest",
                  body: "From 20 June to 28 June",
                  index: 1,
                ),
                Separator.divider(indent: 16),
              ],
            ),
            */
          ],
        ),
      ),
    );
  }
}
