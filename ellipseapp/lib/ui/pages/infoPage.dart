import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';

import '../../models/eventsModel.dart';
import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class InfoPage extends StatefulWidget {
  final Events event_;
  const InfoPage(this.event_);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  bool default_view = true;
  String oPic = '';
  TabController tabController;
  Widget view;
  bool isDownloading = false;
  bool organizedByLoad = true;
  Map<String, dynamic> organizedBy;
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  final ScrollController _scrollController = ScrollController();
  bool message = false;
  var textController = new TextEditingController();

  download(String url, String name) async {
    setState(() {
      isDownloading = true;
    });
    var response = await httpGetWithoutHeaders(url);
    final Directory directory =
        await pathProvider.getApplicationDocumentsDirectory();
    final String path = directory.path;
    final imageFile = File('$path/image.png');
    await imageFile.writeAsBytes(response.bodyBytes);
    await OpenFile.open('$path/image.png');
    setState(() {
      isDownloading = false;
    });
  }

  getOrganizerInfo() async {
    setState(() {
      organizedByLoad = true;
    });
    Events eve = widget.event_;
    String eId = eve.eventId;
    String uId = eve.userId;
    var response2 = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_organizer_details?eventId=$eId&userId=$uId");
    if (response2.statusCode == 200) {
      print('Response status: ${response2.statusCode}');
      print('Response body: ${response2.body}');
    }

    setState(() {
      organizedBy = json.decode(response2.body);
      oPic = organizedBy['profile_pic'].toString().trim();
      organizedByLoad = false;
    });
  }

  @override
  void initState() {
    tabController = new TabController(
      length: 1,
      vsync: this,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{infoPageSliderMenu},
      );
    });
    loadPref();
    getOrganizerInfo();
    super.initState();
    //scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  route(String title, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DialogWidget(title: title, child: widget)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDownloading) {
      return LoaderCircular("Downloading");
    } else {
      final Events _event =
          context.watch<EventsRepository>().event(widget.event_.eventId);
      Map<String, dynamic> teamSize = _event.teamSize;
      return SafeArea(
        child: Consumer<EventsRepository>(
          builder: (context, event, child) => Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              actions: [
                featureDiscoveryOverlay(
                  context,
                  featureId: infoPageSliderMenu,
                  contentLocation: ContentLocation.below,
                  tapTarget: Icon(
                    Icons.menu,
                    color: Theme.of(context).textTheme.caption.color,
                    size: 27,
                  ),
                  title: 'Menu',
                  description: 'Click here to open menu',
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).textTheme.caption.color,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          _key.currentState.toggle();
                        });
                      }),
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
              sliderMenu: _event.admin || _event.moderator
                  /////////////admin moderator//////////////
                  ? Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: true,
                      thickness: 5,
                      radius: Radius.circular(50),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        children: <Widget>[
                          SlideMenuItem(
                              Icons.access_time, "Timeline", "Event timeline",
                              () {
                            route('Timeline', Timeline(_event.eventId));
                          }),
                          SlideMenuHeader("Announcements"),
                          SlideMenuItem(Icons.announcement_outlined,
                              "Announcements", "Your Announcements", () {
                            route('Announcements',
                                Announcements(_event.eventId, "admin"));
                          }),
                          SlideMenuItem(Icons.add_alert_outlined,
                              "Add Announcement", "Add Announcement", () {
                            route('Add Announcement',
                                AddAnnouncement(_event.eventId));
                          }),
                          SlideMenuHeader("Chat"),
                          SlideMenuItem(
                              Icons.chat_outlined, "Chat", "Your Chat", () {
                            route(
                                'Chat',
                                ChatScreen(
                                    type: 'eventChat', id: _event.eventId));
                          }),
                          SlideMenuHeader("Participation"),
                          SlideMenuItem(Icons.collections_bookmark,
                              "Submissions", "Event Submissions", () {
                            route('Submissions',
                                EventSubmissions(_event.eventId));
                          }),
                          if(_event.isTeamed)...[
                          SlideMenuItem(Icons.extension, "Teams",
                              "Registered Participants", () {
                            route('Teams', EventTeams(_event.eventId));
                          }),
                          ],
                          SlideMenuItem(Icons.people_outline, "Participants",
                              "Registered Participants", () {
                            route('Participants', Participants(_event.eventId));
                          }),
                          SlideMenuItem(LineIcons.certificate, "Certificates",
                              "Distribute Participation\nCertificates ", () {
                            route('Certificates',
                                CertificatesAdmin(_event.eventId.toString()));
                          }),
                          SlideMenuHeader("Event"),
                          if (_event.admin) ...[
                            SlideMenuItem(Icons.emoji_people, "Moderators",
                                "Manage Event Moderators", () {
                              route('Moderators',
                                  EventModerators(_event.eventId));
                            }),
                          ],
                          SlideMenuItem(
                              Icons.edit_outlined, "Edit Event", "Edit Event",
                              () {
                            route('Edit Event', EditEvent(_event.eventId));
                          }),
                          SlideMenuItem(
                              Icons.share_outlined, "Share", "Share Event", () {
                            Share.share(_event.shareLink);
                          }),
                          SlideMenuItem(Icons.download_outlined, "Download",
                              "Download Event Poster", () {
                            download(
                                "${Url.URL}/api/image?id=${_event.imageUrl}",
                                _event.name);
                          }),
                        ],
                      ),
                    )
                  /////////////user///////////////
                  : _event.user
                      ? Scrollbar(
                          controller: _scrollController,
                          isAlwaysShown: true,
                          thickness: 5,
                          radius: Radius.circular(50),
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            children: <Widget>[
                              /* SlideMenuItem1(Icons.desktop_windows, "Event View",
                              "View event information", () {
                            setState(() {
                              default_view = true;
                            });
                            _key.currentState.closeDrawer();
                          }),*/
                              SlideMenuItem(Icons.access_time, "Timeline",
                                  "Event timeline", () {
                                route('Timeline', Timeline(_event.eventId));
                              }),
                              SlideMenuHeader("Registration"),
                              SlideMenuItem(Icons.event_available_rounded,
                                  "Register", "Register to event", () {
                                if (_event.admin) {
                                  alertDialog(context, "Event Registration",
                                      "You are admin to this event.You can not register to this event");
                                } else if (_event.registered == true) {
                                  alertDialog(context, "Event Registration",
                                      "You have already registered to this event");
                                } else if (_event.regLastDate
                                    .isBefore(DateTime.now())) {
                                  alertDialog(context, "Event Registration",
                                      "Event Registration Closed");
                                } else if (_event.registered == false &&
                                    _event.regMode == "form") {
                                  route(
                                      'Registration',
                                      RegistrationForm(
                                          _event.eventId, _event.regFields));
                                } else if (_event.regMode == "link") {
                                  String link = _event.regLink;
                                  link.launchUrl;
                                }
                              }),
                              if (_event.registered ||
                                  _event.regMode == 'link') ...[
                                SlideMenuHeader("Participation"),
                                if (_event.isTeamed &&
                                    (_event.registered ||
                                        _event.regMode == 'link')) ...[
                                  SlideMenuItem(
                                      Icons.emoji_events_outlined,
                                      "Participation",
                                      "Your Participation", () {
                                    route(
                                        'Participation', Participation(_event));
                                  }),
                                ],
                                SlideMenuItem(Icons.collections_bookmark,
                                    "Submissions", "Event Submissions", () {
                                  route('My Submissions',
                                      MySubmissions(_event.eventId));
                                }),
                              ],
                              SlideMenuHeader("Chat"),
                              SlideMenuItem(
                                  Icons.chat_outlined, "Chat", "Your Chat", () {
                                if (_event.registered == true ||
                                    _event.regMode == "link") {
                                  route(
                                      'Chat',
                                      ChatScreen(
                                          type: 'eventChat',
                                          id: _event.eventId));
                                } else {
                                  messageDialog(context,
                                      "You have to register to event to chat with event admin");
                                }
                              }),
                              SlideMenuHeader("Event"),
                              SlideMenuItem(Icons.announcement_outlined,
                                  "Announcements", "Your Announcements", () {
                                route('Announcements',
                                    Announcements(_event.eventId, "user"));
                              }),
                              SlideMenuItem(Icons.download_outlined, "Download",
                                  "Download Event Poster", () {
                                download(
                                    "${Url.URL}/api/image?id=${_event.imageUrl}",
                                    _event.name);
                              }),
                              SlideMenuItem(
                                  Icons.share_outlined, "Share", "Share Event",
                                  () {
                                if (Platform.isAndroid) {
                                  Share.share(_event.shareLink);
                                } else if (Platform.isIOS) {}
                              }),
                              SlideMenuItem(
                                  Icons.report_outlined, "Report", "Report",
                                  () {
                                route('Report',
                                    Report("Event_report", _event.eventId));
                              }),
                            ],
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          isAlwaysShown: true,
                          thickness: 5,
                          radius: Radius.circular(50),
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            children: <Widget>[],
                          ),
                        ),
              sliderMain: event.isLoading
                  ? LoaderCircular("Loading Events")
                  : Container(
                      child: default_view
                          ? NestedScrollView(
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    expandedHeight:
                                        MediaQuery.of(context).size.height *
                                            0.25,
                                    floating: false,
                                    pinned: false,
                                    flexibleSpace: FlexibleSpaceBar(
                                      centerTitle: true,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                          Navigator.pop(
                                                              context);
                                                        },
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                padding: EdgeInsets.only(top: 0.0),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: RowLayout.cards(
                                    children: <Widget>[
                                      SizedBox(width: 20),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      DateFormat('MMM dd')
                                                          .format(
                                                              _event.startTime),
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                      DateFormat('yyyy').format(
                                                          _event.startTime),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                    heroTag: "Add To Calendar",
                                                    onPressed: () async {
                                                      await Add2Calendar
                                                          .addEvent2Cal(Event(
                                                        title: _event.name,
                                                        allDay: false,
                                                        description:
                                                            _event.description,
                                                        location: _event.venue,
                                                        startDate:
                                                            _event.startTime,
                                                        endDate:
                                                            _event.finishTime,
                                                      ));
                                                    },
                                                    child: Icon(Icons.add),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            if (_event.regMode == 'link' ||
                                                (_event.registered &&
                                                    _event.user) ||
                                                _event.admin ||
                                                _event.moderator) ...[
                                              FloatingActionButton(
                                                mini: true,
                                                heroTag: "Chat",
                                                onPressed: () async {
                                                  route(
                                                      'Chat',
                                                      ChatScreen(
                                                          type: 'eventChat',
                                                          id: _event.eventId));
                                                },
                                                child:
                                                    Icon(Icons.chat_outlined),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (_event.admin) ...[
                                        Chip(
                                          label: Text('You are Admin'),
                                        ),
                                      ] else if (_event.moderator) ...[
                                        Chip(
                                          label: Text('You are Moderator'),
                                        ),
                                      ],
                                      CardPage.header(
                                        title: _event.name,
                                        subtitle: RowLayout(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          space: 5,
                                          children: <Widget>[
                                            ItemSnippet(
                                              icon: Icons.access_time_outlined,
                                              text: _event.startTime
                                                  .toString()
                                                  .toDate(context),
                                            ),
                                            ItemSnippet(
                                              icon: Icons.person_rounded,
                                              text: _event.isTeamed
                                                  ? 'Team Size : ' +
                                                      _event
                                                          .parseTeamSize()
                                                          .minSize
                                                          .toString() +
                                                      '-' +
                                                      _event
                                                          .parseTeamSize()
                                                          .maxSize
                                                          .toString() +
                                                      ' Members'
                                                  : 'Individual Participation',

                                              /* _event.isTeamed
                                                  ? 'Team Size : ' +
                                                      teamSize['min_team_size']
                                                          .toString() +
                                                      '-' +
                                                      teamSize['max_team_size']
                                                          .toString() +
                                                      ' Members'
                                                  : 'Individual Participation',
                                              */
                                            ),
                                          ],
                                        ),
                                        details: _event.description,
                                      ),
                                      (!_event.registered &&
                                              !_event.admin &&
                                              !_event.moderator &&
                                              _event.regLastDate
                                                  .isAfter(DateTime.now()))
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: new Row(
                                                children: <Widget>[
                                                  new Expanded(
                                                    child: FlatButton(
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)),
                                                      splashColor: Theme.of(
                                                              context)
                                                          .scaffoldBackgroundColor
                                                          .withOpacity(0.6),
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color
                                                          .withOpacity(0.5),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 15),
                                                        child: new Row(
                                                          children: <Widget>[
                                                            new Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          20.0),
                                                              child: Text(
                                                                "Register Now",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor),
                                                              ),
                                                            ),
                                                            new Expanded(
                                                              child:
                                                                  Container(),
                                                            ),
                                                            new Transform
                                                                .translate(
                                                              offset: Offset(
                                                                  15.0, 0.0),
                                                              child:
                                                                  new Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            15),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (_event.admin) {
                                                          alertDialog(
                                                              context,
                                                              "Event Registration",
                                                              "You are admin to this event.You can not register to this event");
                                                        } else if (_event
                                                                .registered ==
                                                            true) {
                                                          alertDialog(
                                                              context,
                                                              "Event Registration",
                                                              "You have to already registered to this event");
                                                        } else if (_event
                                                                    .registered ==
                                                                false &&
                                                            _event.regMode ==
                                                                "form") {
                                                          route(
                                                              'Registration',
                                                              RegistrationForm(
                                                                  _event
                                                                      .eventId,
                                                                  _event
                                                                      .regFields));
                                                        } else if (_event
                                                                .regMode ==
                                                            "link") {
                                                          String link =
                                                              _event.regLink;
                                                          link.launchUrl;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      CardPage.body(
                                        title: "Event Details",
                                        body: RowLayout(children: <Widget>[
                                          RowText(
                                            "Event Type",
                                            _event.eventType,
                                          ),
                                          RowText(
                                            "Mode",
                                            _event.eventMode,
                                          ),
                                          RowText(
                                            "Event Cost",
                                            _event.paymentType,
                                          ),
                                          _event.paymentType == "Paid"
                                              ? RowText(
                                                  "Registration Fee",
                                                  _event.registrationFee,
                                                )
                                              : SizedBox.shrink(),
                                          _event.oAllowed == true
                                              ? RowText(
                                                  "Other college students",
                                                  "Allowed",
                                                )
                                              : RowText(
                                                  "Other college students",
                                                  "Not Allowed",
                                                ),
                                        ]),
                                      ),
                                      if (_event.eventMode == "Online" &&
                                          !_event.platformDetails
                                              .isNullOrEmpty()) ...[
                                        CardPage.body(
                                          title: "Platform Details",
                                          body: RowLayout(children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 0,
                                            ),
                                            TextExpand(_event.platformDetails),
                                          ]),
                                        ),
                                      ],
                                      if (_event.eventMode == "Offline") ...[
                                        CardPage.body(
                                          title: "Venue",
                                          body: RowLayout(children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 0,
                                            ),
                                            TextExpand(_event.venue),
                                          ]),
                                        ),
                                      ],
                                      if (_event.regMode == 'link') ...[
                                        CardPage.body(
                                          title: "Registration Link",
                                          body: RowLayout(children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _event.regLink.launchUrl;
                                              },
                                              child: Text(
                                                _event.regLink,
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.copy_outlined,
                                                      ),
                                                      onPressed: () {
                                                        FlutterClipboard.copy(
                                                                _event.regLink)
                                                            .then((value) {
                                                          flutterToast(
                                                              context,
                                                              'Copied to Clipboard',
                                                              1,
                                                              ToastGravity
                                                                  .CENTER);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.share_outlined,
                                                      ),
                                                      onPressed: () {
                                                        Share.share(
                                                            _event.regLink);
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                      CardPage.body(
                                        title: "Important Dates",
                                        body: Column(children: <Widget>[
                                          ListTile(
                                            title: Text("Registration Ends at"),
                                            subtitle: Text(
                                              _event.regLastDate
                                                  .toString()
                                                  .toDate(context),
                                            ),
                                            /* trailing: IconButton(
                                              icon: Icon(
                                                Icons.add_alert_outlined,
                                              ),
                                              onPressed: () async {
                                                final DateTime datetime =
                                                    _event.regLastDate;
                                                await scheduleNotification(
                                                    context,
                                                    0,
                                                    _event.name +
                                                        ' ' +
                                                        'Registration Last Date',
                                                    _event.regLastDate
                                                        .toString()
                                                        .toDate(context),
                                                    datetime,
                                                    '-------');
                                                flutterToast(
                                                    context,
                                                    'Remainder Set to ' +
                                                        _event.regLastDate
                                                            .toString()
                                                            .toDate(context),
                                                    2,
                                                    ToastGravity.CENTER);
                                              },
                                            ),*/
                                          ),
                                          ListTile(
                                            title: Text("Starts at"),
                                            subtitle: Text(
                                              _event.startTime
                                                  .toString()
                                                  .toDate(context),
                                            ),

                                            /*trailing: IconButton(
                                              icon: Icon(
                                                Icons.add_alert_outlined,
                                              ),
                                              onPressed: () async {
                                                final DateTime datetime =
                                                    _event.startTime;
                                                await scheduleNotification(
                                                    context,
                                                    0,
                                                    _event.name +
                                                        ' ' +
                                                        'Start Date',
                                                    _event.startTime
                                                        .toString()
                                                        .toDate(context),
                                                    datetime,
                                                    '-------');
                                                flutterToast(
                                                    context,
                                                    'Remainder Set to ' +
                                                        _event.startTime
                                                            .toString()
                                                            .toDate(context),
                                                    2,
                                                    ToastGravity.CENTER);
                                              },
                                            ),
                                            */
                                          ),
                                          ListTile(
                                            title: Text("Ends at"),
                                            subtitle: Text(
                                              _event.finishTime
                                                  .toString()
                                                  .toDate(context),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      if (_event.prizes.isNotEmpty) ...[
                                        CardPage.body(
                                          title: "Prizes",
                                          body: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                width: double.infinity,
                                              ),
                                              for (var i = 0;
                                                  i < _event.prizes.length;
                                                  i++) ...[
                                                ListTile(
                                                  // leading:Icon(Icons.emoji_events_outlined,) ,
                                                  title: Text(
                                                    _event.prizes[i]['title'],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Amount : " +
                                                          _event.prizes[i]
                                                              ['prize']),
                                                      Text(_event.prizes[i]
                                                          ['desc']),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ],
                                      _event.requirements.isNotEmpty
                                          ? CardPage.body(
                                              title: "Prerequisites",
                                              body:
                                                  RowLayout(children: <Widget>[
                                                Container(),
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  spacing: 10.0,
                                                  children: _event.requirements
                                                      .map(
                                                        (value) => RaisedButton(
                                                          child: Text(value),
                                                          shape:
                                                              StadiumBorder(),
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              .color
                                                              .withOpacity(0.4),
                                                          colorBrightness:
                                                              Brightness.dark,
                                                          onPressed: () {},
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ]),
                                            )
                                          : SizedBox.shrink(),
                                      _event.tags.isNotEmpty
                                          ? CardPage.body(
                                              title: "Tags",
                                              body:
                                                  RowLayout(children: <Widget>[
                                                Container(),
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  spacing: 10.0,
                                                  children: _event.tags
                                                      .map(
                                                        (value) => RaisedButton(
                                                          child: Text(value),
                                                          shape:
                                                              StadiumBorder(),
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              .color
                                                              .withOpacity(0.4),
                                                          colorBrightness:
                                                              Brightness.dark,
                                                          onPressed: () {},
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ]),
                                            )
                                          : SizedBox.shrink(),
                                      if (!_event.themes.isNullOrEmpty()) ...[
                                        CardPage.body(
                                          title: "Themes",
                                          body: RowLayout(children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 0,
                                            ),
                                            TextExpand(
                                              _event.themes,
                                            ),
                                          ]),
                                        ),
                                      ],
                                      CardPage.body(
                                        title: "Time Left",
                                        body: RowLayout(children: <Widget>[
                                          SizedBox(
                                            width: double.infinity,
                                          ),
                                          if (_event.startTime
                                                  .isBefore(DateTime.now()) &&
                                              _event.finishTime
                                                  .isAfter(DateTime.now())) ...[
                                            RaisedButton(
                                              child: Text("Event Started"),
                                              shape: StadiumBorder(),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                                  .withOpacity(0.4),
                                              colorBrightness: Brightness.dark,
                                              onPressed: () {},
                                            ),
                                          ] else if (_event.startTime
                                                  .isBefore(DateTime.now()) &&
                                              _event.finishTime.isBefore(
                                                  DateTime.now())) ...[
                                            RaisedButton(
                                              child: Text("Event Finished"),
                                              shape: StadiumBorder(),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                                  .withOpacity(0.4),
                                              colorBrightness: Brightness.dark,
                                              onPressed: () {},
                                            ),
                                          ] else ...[
                                            LaunchCountdown(_event.startTime)
                                          ]
                                        ]),
                                      ),
                                      CardPage.body(
                                        title: "About ${_event.name}",
                                        body: RowLayout(children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 0,
                                          ),
                                          TextExpand(_event.about),
                                        ]),
                                      ),
                                      if (!_event.rules.isNullOrEmpty()) ...[
                                        CardPage.body(
                                          title: "Rules",
                                          body: RowLayout(children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 0,
                                            ),
                                            TextExpand(
                                              _event.rules,
                                            ),
                                          ]),
                                        ),
                                      ],
                                      CardPage.body(
                                        title: "Organized By",
                                        body: organizedByLoad
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : RowLayout(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 10.0),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      540),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              height: 55,
                                                              width: 55,
                                                              child: oPic
                                                                      .isNullOrEmpty()
                                                                  ? NoProfilePic()
                                                                  : FadeInImage(
                                                                      image: NetworkImage(
                                                                          "${Url.URL}/api/image?id=${organizedBy['profile_pic']}"),
                                                                      placeholder:
                                                                          AssetImage(
                                                                              'assets/icons/loading.gif'),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            AutoSizeText(
                                                              organizedBy[
                                                                  'name'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10.0),
                                                            AutoSizeText(
                                                              organizedBy[
                                                                  'college_name'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : view),
            ),
          ),
        ),
      );
    }
  }
}
