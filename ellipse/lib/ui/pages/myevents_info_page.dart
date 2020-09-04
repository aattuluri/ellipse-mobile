import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/events_model.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';
import 'chat_page.dart';
import 'edit_event.dart';

class MyEventsInfoPage extends StatefulWidget {
  final int index;

  const MyEventsInfoPage(this.index);
  @override
  _MyEventsInfoPageState createState() => _MyEventsInfoPageState();
}

class _MyEventsInfoPageState extends State<MyEventsInfoPage>
    with TickerProviderStateMixin {
  bool default_view = true;
  Widget view;
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String token = "", id = "", email = "", college = "";
  TabController _nestedTabController;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    // final sdate = DateTime.parse(_event.start_time);
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
                  child: Text("Announcements",
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
                    Icons.add_alert, "Add Announcement", "Add Announcement",
                    () {
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
                SlideMenuItem1(Icons.group_outlined, "Participants",
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
                  Share.share("https://ellipseapp.com/un/event/${_event.id}");
                }),
                SlideMenuItem1(Icons.edit_outlined, "Edit Event", "Edit Event",
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
                          ];
                        },
                        body: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.only(top: 0.0),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: RowLayout.cards(
                              children: <Widget>[
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    space: 6,
                                    children: <Widget>[
                                      ItemSnippet(
                                        icon: Icons.calendar_today,
                                        text: DateFormat(
                                                'EEE-MMMM dd, yyyy HH:mm')
                                            .format(_event.start_time),
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
/*
  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    return SafeArea(
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
                        Icon(Icons.edit,
                            color: Theme.of(context).textTheme.caption.color),
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
                            color: Theme.of(context).textTheme.caption.color),
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
          bottom: TabBar(
            controller: _nestedTabController,
            isScrollable: true,
            onTap: (index) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            tabs: [
              Tab(
                // icon: Icon(Icons.event),
                child: Text('Event', style: TextStyle(fontSize: 15)),
              ),
              Tab(
                //icon: Icon(Icons.chat),
                child: Text('Chat', style: TextStyle(fontSize: 15)),
              ),
              Tab(
                // icon: Icon(Icons.announcement),
                child: Text('Announcements', style: TextStyle(fontSize: 15)),
              ),
              Tab(
                // icon: Icon(Icons.event_note),
                child: Text('Registration', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
        drawer: SizedBox(
          width: UIUtil.drawerWidth(context),
          child: AppDrawer(
            child: MenuDrawer(),
          ),
        ),
        body: TabBarView(
          controller: _nestedTabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ///////////////////////////////////////////////////////////
            Tab1(widget.index, _event.id),
            ///////////////////////////////////////////////////////////
            ChatTab2(_event.id, "admin", widget.index),
            ///////////////////////////////////////////////////////////
            Tab3(widget.index, _event.id),
            //////////////////////////////////////////////////////////
            Tab4(widget.index, _event.id),
            ///////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
  */
}

class Tab1 extends StatefulWidget {
  final int index;
  final String id;
  const Tab1(this.index, this.id);
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with TickerProviderStateMixin {
  TabController _nestedTabController;
  @override
  void initState() {
    _nestedTabController = new TabController(length: 2, vsync: this);
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: TabBar(
              controller: _nestedTabController,
              //indicatorColor: Theme.of(context).textTheme.caption.color,
              isScrollable: true,
              onTap: (index) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Event Details",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Event",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _nestedTabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ///////////////////////////////////////////////////////////////
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
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
                                  .format(_event.start_time),
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
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                          ),
                          LaunchCountdown(_event.reg_last_date),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ///////////////////////////////////////////////////////
            EditEvent(widget.index),
            //////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}

class Tab3 extends StatefulWidget {
  final int index;
  final String id;
  const Tab3(this.index, this.id);
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with TickerProviderStateMixin {
  TabController _nestedTabController;
  @override
  void initState() {
    _nestedTabController = new TabController(length: 2, vsync: this);
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: TabBar(
              controller: _nestedTabController,
              //indicatorColor: Theme.of(context).textTheme.caption.color,
              isScrollable: true,
              onTap: (index) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Your Announcements",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Add Announcement",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _nestedTabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            //////////////////////////////////////////////////////////
            Announcements(widget.index, widget.id),
            //////////////////////////////////////////////////////////
            AddAnnouncement(widget.index, widget.id),
            //////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}

class Tab4 extends StatefulWidget {
  final int index;
  final String id;
  const Tab4(this.index, this.id);
  @override
  _Tab4State createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> with TickerProviderStateMixin {
  TabController _nestedTabController;
  @override
  void initState() {
    _nestedTabController = new TabController(length: 2, vsync: this);
    print(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: TabBar(
              controller: _nestedTabController,
              //indicatorColor: Theme.of(context).textTheme.caption.color,
              isScrollable: true,
              onTap: (index) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Registered Participants",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Registration form",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _nestedTabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            /////////////////////////////////////////////////////////
            RegisteredParticipants(widget.index),
            ///////////////////////////////////////////////////////////
            Container(),
            /////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
