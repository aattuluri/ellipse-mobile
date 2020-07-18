import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';
import '../widgets/index.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
        ),
      ),
    );
  }
}
