import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../models/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../repositories/index.dart';
import '../pages/filter_calendar.dart';
import '../pages/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../pages/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';
import '../../util/index.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EventTypeModel {
  IconData icon;
  String eventType;
}

class EventTile extends StatelessWidget {
  IconData icon;
  String eventType;
  EventTile({this.icon, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).textTheme.caption.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 40,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            eventType,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          )
        ],
      ),
    );
  }
}

Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Error"),
          action: SnackBarAction(
            label: "Error",
            onPressed: () => _onRefresh(context, repository),
          ),
        ),
      );
    }
    completer.complete();
  });

  return completer.future;
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<EventTypeModel> eventsType = new List();

  List<EventTypeModel> getEventTypes() {
    List<EventTypeModel> events = new List();
    EventTypeModel eventModel = new EventTypeModel();

    eventModel.icon = Icons.school;
    eventModel.eventType = "Education";
    events.add(eventModel);

    eventModel = new EventTypeModel();
    eventModel.icon = Icons.work;
    eventModel.eventType = "Company";
    events.add(eventModel);

    eventModel = new EventTypeModel();
    eventModel.icon = Icons.mic;
    eventModel.eventType = "Concert";
    events.add(eventModel);

    eventModel = new EventTypeModel();

    eventModel.icon = Icons.mic;
    eventModel.eventType = "Sports";
    events.add(eventModel);

    eventModel = new EventTypeModel();
    return events;
  }

  @override
  void initState() {
    eventsType = getEventTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/logo.png",
                            height: 40,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Ell",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "ipse",
                                style: TextStyle(
                                    color: Color(0xffFCCD00),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.start,
                              arguments: {'currebt_tab': 3},
                            ),
                            child: Icon(
                              Icons.notifications,
                              size: 35,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.calendar_view),
                            child: Icon(
                              Icons.insert_invitation,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "Hello," + _userdetails.name,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Let's explore what’s happening nearby",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                  fontSize: 17),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.view_profile);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Url.URL}/api/image?id=${_userdetails.profile_pic}",
                                  placeholder: (context, url) => Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height:
                                        MediaQuery.of(context).size.width * 0.9,
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Categories",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 95,
                      child: ListView.builder(
                          itemCount: eventsType.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return EventTile(
                              icon: eventsType[index].icon,
                              eventType: eventsType[index].eventType,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        'Search For Events',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        padding: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.start,
                              arguments: {'currebt_tab': 1},
                            );
                          },
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: 'Lets explore some events here...',
                                hintStyle: TextStyle(fontSize: 17.0),
                                border: InputBorder.none,
                                fillColor: Colors.grey.withOpacity(0.5),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey)),
                          ),
                        )),
                    SizedBox(height: 25.0),
                    _buildSectionHeader1(),
                    SizedBox(height: 10.0),
                    model.isLoading || model.loadingFailed
                        ? _loadingIndicator
                        : Container(
                            height: 250.0,
                            child: Center(
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.allEvents?.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Events event = model.allEvents[index];
                                    final sdate =
                                        DateTime.parse(event.start_time);
                                    return sdate.isAfter(DateTime.now())
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 10.0,
                                            ),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              elevation: 4.0,
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        Routes.info_page,
                                                        arguments: {
                                                      'index': index
                                                    }),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Url.URL}/api/image?id=${event.imageUrl}",
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fadeInDuration: Duration(
                                                        milliseconds: 1000),
                                                    placeholder:
                                                        (context, url) => Icon(
                                                      Icons.image,
                                                      size: 80,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.error,
                                                      size: 80,
                                                    ),
                                                  ),
                                                  //Image.memory(_image,
                                                  //  fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                            ),
                          ),
                    _buildSectionHeader2(),
                    SizedBox(height: 10.0),
                    model.isLoading || model.loadingFailed
                        ? _loadingIndicator
                        : Container(
                            height: 250.0,
                            child: Center(
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.allEvents?.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Events event = model.allEvents[index];
                                    final sdate =
                                        DateTime.parse(event.start_time);
                                    print(sdate);
                                    return sdate.isAfter(DateTime.now())
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 10.0,
                                            ),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              elevation: 4.0,
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        Routes.info_page,
                                                        arguments: {
                                                      'index': index
                                                    }),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Url.URL}/api/image?id=${event.imageUrl}",
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fadeInDuration: Duration(
                                                        milliseconds: 1000),
                                                    placeholder:
                                                        (context, url) => Icon(
                                                      Icons.image,
                                                      size: 80,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.error,
                                                      size: 80,
                                                    ),
                                                  ),
                                                  //Image.memory(
                                                  // base64Decode(
                                                  //    event.imageUrl),
                                                  //fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSectionHeader1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Your College Events',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'See All',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  _buildSectionHeader2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Other Events',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'See All',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
