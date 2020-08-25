import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import '../../util/index.dart';
import '../pages/index.dart';

class InfoPage extends StatefulWidget {
  final int index;

  const InfoPage(this.index);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  bool default_view = true;
  Widget view;
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  ScrollController scrollController;
  String token = "", id = "", email = "", college = "";
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

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    print(id);
  }

  @override
  void initState() {
    getPref();
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
        context.watch<EventsRepository>().getEventIndex(widget.index);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.start,
                  arguments: {'currebt_tab': 1},
                );
              },
              child: Icon(Icons.arrow_back)),
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
            sliderMenu: ListView(
              children: <Widget>[
                SlideMenuItem1(Icons.desktop_windows, "Event View",
                    "View event information", () {
                  setState(() {
                    default_view = true;
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
                SlideMenuItem1(Icons.group, "Register", "Register to event",
                    () {
                  setState(() {
                    view = RegistrationForm(widget.index, _event.reg_fields);
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
                  child: Text("Event",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(
                    Icons.announcement, "Announcements", "Your Announcements",
                    () {
                  setState(() {
                    view = Announcements(widget.index, _event.id);
                    default_view = false;
                  });
                  _key.currentState.closeDrawer();
                }),
                SlideMenuItem1(
                    Icons.favorite, "Add to Favourites", "To favourites", () {
                  setState(() {
                    //default_view = false;
                  });
                }),
                SlideMenuItem1(Icons.share, "Share", "Share Event", () {
                  if (Platform.isAndroid) {
                    Share.share(_event.name);
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
                  setState(() {
                    view = ChatPage(
                        _event.id, "participant", widget.index, _event.user_id);
                    default_view = false;
                  });
                  _key.currentState.closeDrawer();
                }),
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
                                background: InkWell(
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
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "${Url.URL}/api/image?id=${_event.imageUrl}",
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 80,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
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
                                                child:
                                                    Icon(Icons.close, size: 30),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Url.URL}/api/image?id=${_event.imageUrl}",
                                      placeholder: (context, url) => Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Icon(
                                          Icons.image,
                                          size: 80,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              DateFormat('EEEE')
                                                  .format(_event.start_time),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text("10:00 AM",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14)),
                                        ],
                                      ),
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
                                            Text("Add To Calendar",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14)),
                                            FloatingActionButton(
                                              mini: true,
                                              onPressed: () async {
                                                await Add2Calendar.addEvent2Cal(
                                                    Event(
                                                  title: "eatrt",
                                                  allDay: false,
                                                  description: "wegrht",
                                                  location: "wegrhtjy",
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
                                        : Container(),
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
