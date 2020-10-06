import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';

import '../../models/events_model.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class InfoPage extends StatefulWidget {
  final int index;
  final String type;

  const InfoPage(this.index, this.type);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  bool default_view = true;
  Widget view;
  List<String> favourites = [];
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  ScrollController scrollController;
  String _messageText = "";
  bool message = false;
  var textController = new TextEditingController();
  _SearchListState() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        setState(() {
          _messageText = "";
          message = false;
        });
      } else {
        setState(() {
          _messageText = textController.text;
          message = true;
        });
      }
    });
  }

  @override
  void initState() {
    loadPref();
    print(widget.index);
    super.initState();
    _SearchListState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  _key.currentState.toggle();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Theme.of(context).textTheme.caption.color,
                ),
              ),
            ),
          ],
          elevation: 4,
          title: Text(
            _event.name,
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body: SliderMenuContainer(
            key: _key,
            isShadow: false,
            sliderOpen: SliderOpen.RIGHT_TO_LEFT,
            sliderMenuOpenOffset: 250,
            sliderMenu: widget.type == "user"
                ///////////////////////////////////////////user///////////////////////////////////
                ? ListView(
                    children: <Widget>[
                      SlideMenuItem1(Icons.desktop_windows, "Event View",
                          "View event information", () {
                        setState(() {
                          default_view = true;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      SlideMenuItem1(
                          Icons.access_time, "Timeline", "Event timeline", () {
                        setState(() {
                          view = Timeline(widget.index, _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Registration",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(
                          Icons.group, "Register", "Register to event", () {
                        if (_event.registered == true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Event Registration"),
                                content: new Text(
                                    "You have to already registered to this event"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (_event.registered == false &&
                            _event.reg_mode == "form") {
                          setState(() {
                            view = RegistrationForm(
                                widget.index, _event.reg_fields);
                            default_view = false;
                          });

                          _key.currentState.closeDrawer();
                        } else if (_event.reg_mode == "link") {
                          String link = _event.reg_link;
                          FlutterWebBrowser.openWebPage(
                            url: '$link',
                            androidToolbarColor: Theme.of(context).primaryColor,
                          );
                        }
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Event",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.announcement, "Announcements",
                          "Your Announcements", () {
                        setState(() {
                          view = Announcements(widget.index, _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      SlideMenuItem1(Icons.share, "Share", "Share Event", () {
                        if (Platform.isAndroid) {
                          Share.share(
                              "https://ellipseapp.com/un/event/${_event.id}");
                        } else if (Platform.isIOS) {}
                      }),
                      SlideMenuItem1(Icons.report, "Report", "Report", () {
                        setState(() {
                          view = Report("Event_report", _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Chat",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.chat, "Chat", "Your Chat", () {
                        if (_event.registered == true ||
                            _event.reg_mode == "link") {
                          setState(() {
                            view = ChatPage(_event.id, "participant",
                                widget.index, _event.user_id);
                            default_view = false;
                          });
                          _key.currentState.closeDrawer();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Chat"),
                                content: new Text(
                                    "You have to register to event to chat with event admin"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                    ],
                  )
                ////////////////////////////////////////////admin///////////////////////////////////////////////
                : ListView(
                    children: <Widget>[
                      SlideMenuItem1(Icons.desktop_windows, "Event View",
                          "View event information", () {
                        setState(() {
                          default_view = true;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      SlideMenuItem1(
                          Icons.access_time, "Timeline", "Event timeline", () {
                        setState(() {
                          view = Timeline(widget.index, _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Announcements",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.announcement, "Announcements",
                          "Your Announcements", () {
                        setState(() {
                          view = Announcements(widget.index, _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      SlideMenuItem1(Icons.add_alert, "Add Announcement",
                          "Add Announcement", () {
                        setState(() {
                          view = AddAnnouncement(widget.index, _event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Chat",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.chat, "Chat", "Your Chat", () {
                        setState(() {
                          view = ChatPage(
                              _event.id, "admin", widget.index, _event.user_id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Registrations",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.group, "Participants",
                          "Registered Participants", () {
                        setState(() {
                          view = Participants(_event.id);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      /*
                SlideMenuItem1(Icons.attach_email, "Send Mail",
                    "Send mail to participants", () {}),
                */
                      /*
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Text("Moderators",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(Icons.group, "Manage Moderators",
                    "moderators for event", () {}),
                SlideMenuItem1(Icons.group_add, "Add Moderator",
                    "Add new moderator", () {}),
                */
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text("Event",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 3),
                      SlideMenuItem1(Icons.share, "Share", "Share Event", () {
                        Share.share(
                            "https://ellipseapp.com/un/event/${_event.id}");
                      }),
                      SlideMenuItem1(Icons.edit, "Edit Event", "Edit Event",
                          () {
                        setState(() {
                          view = EditEvent(widget.index);
                          default_view = false;
                        });
                        _key.currentState.closeDrawer();
                      }),
                      /*
                SlideMenuItem1(
                    Icons.delete, "Delete Event", "Delete Event", () {}),
                */
                    ],
                  ),
            sliderMain: Container(
                child: default_view
                    ? NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              expandedHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                              floating: false,
                              pinned: false,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (_) => Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.7),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FadeInImage(
                                                  image: NetworkImage(
                                                      "${Url.URL}/api/image?id=${_event.imageUrl}"),
                                                  placeholder: AssetImage(
                                                      'assets/icons/loading.gif'),
                                                ),
                                                SizedBox(height: 10),
                                                FloatingActionButton(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  tooltip: 'Increment',
                                                  child: Icon(Icons.close,
                                                      size: 30),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      child: FadeInImage(
                                        image: NetworkImage(
                                            "${Url.URL}/api/image?id=${_event.imageUrl}"),
                                        placeholder: AssetImage(
                                            'assets/icons/loading.gif'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.only(top: 0.0),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: RowLayout.cards(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                DateFormat('MMM dd')
                                                    .format(_event.start_time),
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                                DateFormat('yyyy')
                                                    .format(_event.start_time),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: ShapeDecoration(
                                            shape: StadiumBorder(),
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color
                                                .withOpacity(0.1)),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(width: 8),
                                            AutoSizeText(
                                              "Add To Calendar",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .color),
                                            ),
                                            FloatingActionButton(
                                              mini: true,
                                              onPressed: () async {
                                                await Add2Calendar.addEvent2Cal(
                                                    Event(
                                                  title: _event.name,
                                                  allDay: false,
                                                  description:
                                                      _event.description,
                                                  location: _event.venue,
                                                  startDate: _event.start_time,
                                                  endDate: _event.finish_time,
                                                ));
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CardPage.header(
                                  title: _event.name,
                                  subtitle: RowLayout(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    space: 6,
                                    children: <Widget>[
                                      ItemSnippet(
                                        icon: Icons.account_balance,
                                        text: _event.college_name,
                                      ),
                                      /*
                                      _event.event_mode == "Offline"
                                          ? ItemSnippet(
                                              icon: Icons.location_on,
                                              text: _event.venue,
                                              onTap: () {})
                                          : ItemSnippet(
                                              icon: Icons.location_on,
                                              text: _event.platform_link,
                                              onTap: () {}),
                                      */
                                    ],
                                  ),
                                  details: _event.description,
                                ),
                                CardPage.body(
                                  title: "Requirements",
                                  body: RowLayout(children: <Widget>[
                                    Container(),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10.0,
                                      children: _event.requirements
                                          .map(
                                            (value) => RaisedButton(
                                              child: Text(value),
                                              shape: StadiumBorder(),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                                  .withOpacity(0.4),
                                              colorBrightness: Brightness.dark,
                                              onPressed: () {},
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ]),
                                ),
                                CardPage.body(
                                  title: "Themes",
                                  body: RowLayout(children: <Widget>[
                                    Container(),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10.0,
                                      children: _event.tags
                                          .map(
                                            (value) => RaisedButton(
                                              child: Text(value),
                                              shape: StadiumBorder(),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                                  .withOpacity(0.4),
                                              colorBrightness: Brightness.dark,
                                              onPressed: () {},
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ]),
                                ),
                                CardPage.body(
                                  title: "Time Left",
                                  body: RowLayout(children: <Widget>[
                                    LaunchCountdown(_event.start_time)
                                  ]),
                                ),
                                CardPage.body(
                                  title: "Important Dates",
                                  body: RowLayout(children: <Widget>[
                                    RowText(
                                      "Event Start Date",
                                      DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                          .format(_event.start_time),
                                    ),
                                    RowText(
                                      "Event Finish Date",
                                      DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                          .format(_event.finish_time),
                                    ),
                                    Separator.divider(),
                                    RowText(
                                      "Registration Last Date",
                                      DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                          .format(_event.reg_last_date),
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
                                        : SizedBox.shrink(),
                                    _event.o_allowed == true
                                        ? RowText(
                                            "Other college students",
                                            "Allowed",
                                          )
                                        : RowText(
                                            "Other college students",
                                            "Not Allowed",
                                          )
                                  ]),
                                ),
                                CardPage.body(
                                  title: " Event Registration",
                                  body: RowLayout(children: <Widget>[
                                    _event.reg_mode == "link"
                                        ? Text(
                                            "Link",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                            ),
                                          )
                                        : Container(),
                                    _event.reg_mode == "link"
                                        ? TextExpand(_event.reg_link)
                                        : Container(),
                                    _event.reg_link == null
                                        ? Container()
                                        : Separator.divider(),
                                    Text(
                                      "Time left to Register",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                    ),
                                    LaunchCountdown(_event.reg_last_date),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : view)),
      ),
    );
  }
}
