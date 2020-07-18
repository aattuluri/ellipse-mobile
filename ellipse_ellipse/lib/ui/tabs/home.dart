import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

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
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, bottom: 10.0, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Explore to",
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold)),
                              Text("events around you !",
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Icon(
                            Icons.event_note,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ),
                    _buildSectionHeader1(),
                    SizedBox(height: 10.0),
                    model.isLoading || model.loadingFailed
                        ? _loadingIndicator
                        : Container(
                            height: 250.0,
                            child: Center(
                              child: ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.allEvents?.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Events event = model.allEvents[index];
                                    final sdate =
                                        DateTime.parse(event.start_time);
                                    Uint8List _image =
                                        Base64Decoder().convert(event.imageUrl);
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
                                                        "https://th.bing.com/th/id/OIP.WgCo2qYb7_GY4EI0Tay2XQHaHa?pid=Api&rs=1",
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
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
                                                        "http://cumminsblogdotorg.files.wordpress.com/2012/09/pentacle13-poster-comp.jpg",
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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
      ),
    );
  }

  _buildSectionHeader2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final int number;

  FoodCard({this.type, this.icon, this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 170,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.6),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    type,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Text(
                    "$number Events",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
