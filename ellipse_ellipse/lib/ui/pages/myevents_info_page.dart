import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';
import 'package:sliver_fab/sliver_fab.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';
import '../../util/index.dart';

class MyEventsInfoPage extends StatefulWidget {
  final int index;

  const MyEventsInfoPage(this.index);
  @override
  _MyEventsInfoPageState createState() => _MyEventsInfoPageState();
}

class _MyEventsInfoPageState extends State<MyEventsInfoPage>
    with TickerProviderStateMixin {
  String token = "", id = "", email = "", college = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    getPref();
    print(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    final sdate = DateTime.parse(_event.start_time);
    final fdate = DateTime.parse(_event.finish_time);
    final reg_last_date = DateTime.parse(_event.reg_last_date);
    return SafeArea(
      child: Scaffold(
        body: SliverFab(
          expandedHeight: MediaQuery.of(context).size.height * 0.3,
          floatingWidget: Container(),
          slivers: <Widget>[
            SliverBar(
              title: _event.name,
              header: InkWell(
                child: Container(
                    child:
                        Image.memory(base64Decode(_event.imageUrl.toString()))),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    offset: Offset(0, 50),
                    elevation: 1,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Edit Event'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Delete Event'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          {
                            Navigator.pushNamed(
                              context,
                              Routes.edit_event,
                              arguments: {'index': widget.index},
                            );
                            break;
                          }
                        case 2:
                          {
                            break;
                          }
                      }
                    },
                  ),
                )
              ],
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: RowLayout.cards(children: <Widget>[
                  CardPage.header(
                    leading: AbsorbPointer(
                      absorbing: true,
                      child: HeroImage.card(
                          url: "fgchj", tag: "fygh", onTap: () {}),
                    ),
                    title: _event.name,
                    subtitle: RowLayout(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      space: 6,
                      children: <Widget>[
                        ItemSnippet(
                          icon: Icons.calendar_today,
                          text: DateFormat('EEE-MMMM dd, yyyy HH:mm')
                              .format(sdate),
                        ),
                        _event.event_mode == "Offline"
                            ? ItemSnippet(
                                icon: Icons.location_on,
                                text: _event.venue,
                                onTap: () {})
                            : ItemSnippet(
                                icon: Icons.location_on,
                                text: _event.platform_link,
                                onTap: () {}),
                      ],
                    ),
                    details: _event.description,
                  ),
                  CardPage.body(
                    title: "Time Left",
                    body: RowLayout(children: <Widget>[LaunchCountdown(sdate)]),
                  ),
                  CardPage.body(
                    title: "Important Dates",
                    body: RowLayout(children: <Widget>[
                      RowText(
                        "Event Start Date",
                        DateFormat('EEE-MMMM dd, yyyy HH:mm').format(sdate),
                      ),
                      RowText(
                        "Event Finish Date",
                        DateFormat('EEE-MMMM dd, yyyy HH:mm').format(fdate),
                      ),
                      Separator.divider(),
                      RowText(
                        "Registration Last Date",
                        DateFormat('EEE-MMMM dd, yyyy HH:mm')
                            .format(reg_last_date),
                      )
                    ]),
                  ),
                  CardPage.body(
                    title: "Event Details",
                    body: RowLayout(children: <Widget>[
                      RowText(
                        "Event Type",
                        _event.event_type,
                      ),
                      RowText(
                        "Mode",
                        _event.event_mode,
                      ),
                      RowText(
                        "Event Cost",
                        _event.payment_type,
                      ),
                      _event.payment_type == "Paid"
                          ? RowText(
                              "Registration Fee",
                              _event.registration_fee,
                            )
                          : Container(),
                    ]),
                  ),
                  CardPage.body(
                    title: " Event Registration",
                    body: RowLayout(children: <Widget>[
                      Text(
                        "Link",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                      TextExpand(_event.reg_link),
                      Separator.divider(),
                      Text(
                        "Time left to Register",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                      LaunchCountdown(reg_last_date)
                    ]),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
