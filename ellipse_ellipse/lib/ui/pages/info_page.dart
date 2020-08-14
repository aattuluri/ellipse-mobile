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
import 'chat_tab1.dart';
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

  Future<List<AnnouncementsModel>> _fetch_announcements(String event_id) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    String _id = event_id.trim().toString();
    var response = await http.get(
        "${Url.URL}/api/event/get_announcements?id=$event_id",
        headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse
          .map((announcement) => new AnnouncementsModel.fromJson(announcement))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
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
        context.watch<EventsRepository>().getEvents(widget.index);
    final sdate = DateTime.parse(_event.start_time);
    final fdate = DateTime.parse(_event.finish_time);
    final reg_last_date = DateTime.parse(_event.reg_last_date);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

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
                    view = RegistrationForm(_event.reg_fields);
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
                    view = Scaffold(
                      body: FutureBuilder<List<AnnouncementsModel>>(
                        future: _fetch_announcements(_event.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<AnnouncementsModel> data = snapshot.data;
                            return ListView.builder(
                                reverse: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final _time =
                                      DateTime.parse(data[index].time);
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    padding: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width,
                                    //height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Container(
                                          child: Icon(Icons.speaker_phone,
                                              size: 23),
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data[index].title,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                data[index].description,
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                DateFormat(
                                                        'EEE-MMMM dd, yyyy HH:mm')
                                                    .format(_time),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'ProductSans',
                                                  //color: Tools.multiColors[Random().nextInt(5)]
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: CircularProgressIndicator()));
                        },
                      ),
                    );
                    default_view = false;
                  });
                  _key.currentState.closeDrawer();
                }),
                SlideMenuItem1(
                    Icons.favorite, "Add to Favourites", "To favourites", () {
                  setState(() {
                    //default_view = false;
                  });
                  _key.currentState.closeDrawer();
                }),
                SlideMenuItem1(Icons.share, "Share", "Share Event", () {
                  setState(() {});
                }),
                SlideMenuItem1(Icons.report, "Report", "Report", () {
                  setState(() {});
                  // _key.currentState.closeDrawer();
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
                    view = ChatTab2(_event.id, "participant", widget.index);
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
                                                    .format(sdate),
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                                DateFormat('yyyy')
                                                    .format(sdate),
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
                                          Text(DateFormat('EEEE').format(sdate),
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
                                              onPressed: () {},
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
                                        icon: Icons.calendar_today,
                                        text: DateFormat(
                                                'EEE-MMMM dd, yyyy HH:mm')
                                            .format(sdate),
                                      ),
                                      ItemSnippet(
                                        icon: Icons.account_balance,
                                        text: _event.college_name,
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
                                    LaunchCountdown(sdate)
                                  ]),
                                ),
                                CardPage.body(
                                  title: "Important Dates",
                                  body: RowLayout(children: <Widget>[
                                    RowText(
                                      "Event Start Date",
                                      DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                          .format(sdate),
                                    ),
                                    RowText(
                                      "Event Finish Date",
                                      DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                          .format(fdate),
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
                                    LaunchCountdown(reg_last_date),
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
/*
  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    final sdate = DateTime.parse(_event.start_time);
    final fdate = DateTime.parse(_event.finish_time);
    final reg_last_date = DateTime.parse(_event.reg_last_date);
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            centerTitle: true,
            title: Text(_event.name),
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
                          Icon(Icons.favorite,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Add to Favourites'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.file_download,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Download'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.share,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Share Event'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.report,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Report'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        {
                          break;
                        }
                      case 2:
                        {
                          break;
                        }
                      case 3:
                        {
                          Share.share(
                            "hgbjk",
                          );
                          break;
                        }
                      case 4:
                        {
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new Report("Event_report", _event.id),
                          );
                          Navigator.of(context).push(route);
                          break;
                        }
                    }
                  },
                ),
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              onTap: (index) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Details",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Chat",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Announcements",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Registration",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: MediaQuery.of(context).size.height * 0.25,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                      SizedBox(height: 10),
                                      FloatingActionButton(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        tooltip: 'Increment',
                                        child: Icon(Icons.close, size: 30),
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
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.9,
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(DateFormat('MMM dd').format(sdate),
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(DateFormat('yyyy').format(sdate),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(DateFormat('EEEE').format(sdate),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text("10:00 AM",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                ],
                              ),
                              Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
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
                                            color: Colors.grey, fontSize: 14)),
                                    FloatingActionButton(
                                      mini: true,
                                      onPressed: () {},
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CardPage.header(
                          /*
                    leading: AbsorbPointer(
                      absorbing: true,
                      child: HeroImage.card(
                          url: "fgchj", tag: "fygh", onTap: () {}),
                    ),
                    */
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
                              ItemSnippet(
                                icon: Icons.account_balance,
                                text: _event.college_name,
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
                          body: RowLayout(
                              children: <Widget>[LaunchCountdown(sdate)]),
                        ),
                        CardPage.body(
                          title: "Important Dates",
                          body: RowLayout(children: <Widget>[
                            RowText(
                              "Event Start Date",
                              DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                  .format(sdate),
                            ),
                            RowText(
                              "Event Finish Date",
                              DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                  .format(fdate),
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            LaunchCountdown(reg_last_date),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              ChatTab2(_event.id, "participant", widget.index),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              FutureBuilder<List<AnnouncementsModel>>(
                future: _fetch_announcements(_event.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<AnnouncementsModel> data = snapshot.data;
                    return ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final _time = DateTime.parse(data[index].time);
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            padding: EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            //height: 120.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .color
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  child: Icon(Icons.speaker_phone, size: 23),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data[index].title,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        data[index].description,
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                            .format(_time),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'ProductSans',
                                          //color: Tools.multiColors[Random().nextInt(5)]
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: CircularProgressIndicator()));
                },
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
              RegistrationForm(_event.reg_fields),
              // ChatTab1(_event.id),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
  */
}
