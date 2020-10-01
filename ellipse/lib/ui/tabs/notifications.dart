import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key key}) : super(key: key);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  void initState() {
    context.read<NotificationsRepository>().refreshData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsRepository>(builder: (context, model, child) {
      return Consumer<EventsRepository>(
        builder: (context, model1, child) => Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: Particles(3)),
              SafeArea(
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
                    //Separator.divider(indent: 16),
                    model.isLoading || model.loadingFailed
                        ? _loadingIndicator
                        : model.allNotifications.isEmpty
                            ? Expanded(
                                child: BigTip(
                                  title: Text('No notifications'),
                                  subtitle:
                                      Text("You don't have notifications"),
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
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                    ),
                                  ),
                                ),
                              )
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < model.allNotifications.length;
                                      i++) ...[
                                    NotificationItem(
                                      num: model.allNotifications.length - i,
                                      onTap: () {
                                        final _event = context
                                            .read<EventsRepository>()
                                            .getEventIndex(model
                                                .allNotifications[i].event_id);

                                        if (_event.toString().validNumeric()) {
                                          Navigator.pushNamed(
                                              context, Routes.info_page,
                                              arguments: {'index': _event});
                                        }
                                      },
                                      time: DateFormat(
                                              'EEE-MMMM dd, yyyy , H:m')
                                          .format(
                                              model.allNotifications[i].time),
                                      title: model.allNotifications[i].title,
                                      description:
                                          model.allNotifications[i].description,
                                    )
                                  ]
                                ],
                              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
