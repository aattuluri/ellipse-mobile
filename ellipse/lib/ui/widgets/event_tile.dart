import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/routes.dart';

class EventTileGeneral extends StatefulWidget {
  final bool visible;
  final int index;
  final String route;
  EventTileGeneral(this.visible, this.index, this.route);
  @override
  State createState() => new EventTileGeneralState();
}

class EventTileGeneralState extends State<EventTileGeneral>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvent(widget.index);
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.info_page, arguments: {
              'index': widget.index,
              'type': 'user',
              'event_': _event
            });
            /* if (widget.route == "info_page") {
              Navigator.pushNamed(context, Routes.info_page,
                  arguments: {'index': widget.index, 'type': 'user'});
            } else if (widget.route == "myevents_info_page") {
              Navigator.pushNamed(
                context,
                Routes.info_page,
                arguments: {'index': widget.index, 'type': 'admin'},
              );
            } else if (widget.route == "null") {}*/
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    width: MediaQuery.of(context).size.width - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          _event.name,
                          minFontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              LineIcons.calendar_o,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            AutoSizeText(
                              _event.start_time.toString().toDate(context),
                              minFontSize: 5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_balance_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            AutoSizeText(
                              _event.college_name,
                              minFontSize: 5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  child: FadeInImage(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 1000),
                    image: NetworkImage(
                        "${Url.URL}/api/image?id=${_event.imageUrl}"),
                    placeholder: AssetImage('assets/icons/loading.gif'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventTileAdmin extends StatefulWidget {
  final bool visible;
  final int index;
  final String route;
  EventTileAdmin(this.visible, this.index, this.route);
  @override
  State createState() => new EventTileAdminState();
}

class EventTileAdminState extends State<EventTileAdmin>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    loadPref();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final Events _event =
        context.watch<EventsRepository>().getEvent(widget.index);
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.info_page,
              arguments: {
                'index': widget.index,
                'type': 'admin',
                'event_': _event
              },
            );
            /* if (widget.route == "info_page") {
              Navigator.pushNamed(context, Routes.info_page,
                  arguments: {'index': widget.index, 'type': 'user'});
            } else if (widget.route == "myevents_info_page") {
              Navigator.pushNamed(
                context,
                Routes.info_page,
                arguments: {'index': widget.index, 'type': 'admin'},
              );
            } else if (widget.route == "null") {}*/
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16),
                          width: MediaQuery.of(context).size.width - 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                _event.name,
                                //minFontSize: 5,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    LineIcons.calendar_o,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AutoSizeText(
                                    _event.start_time
                                        .toString()
                                        .toDate(context),
                                    minFontSize: 5,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_balance_outlined,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AutoSizeText(
                                    _event.college_name,
                                    minFontSize: 5,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        child: FadeInImage(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 1000),
                          image: NetworkImage(
                              "${Url.URL}/api/image?id=${_event.imageUrl}"),
                          placeholder: AssetImage('assets/icons/loading.gif'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Chip(
                        label: Text(_event.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /*Visibility(
      visible: widget.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: w,
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _event.name,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _event.start_time.toString().toDate(context),
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      //color: facebook_dgrey_color,
                                      fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
              Divider(),
              //Separator.divider(),
              ////////////////////////////////////////////////////////////////////////////
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.info_page,
                    arguments: {
                      'index': widget.index,
                      'type': 'admin',
                      'event_': _event
                    },
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: w * 0.30,
                          height: w * 0.30,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              child: FadeInImage(
                                width: w * 0.27,
                                height: w * 0.27,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 1000),
                                image: NetworkImage(
                                    "${Url.URL}/api/image?id=${_event.imageUrl}"),
                                placeholder:
                                    AssetImage('assets/icons/loading.gif'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: w * 0.70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_balance_outlined,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AutoSizeText(
                                    _event.college_name,
                                    minFontSize: 5,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        _event.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_outlined,
                            size: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          AutoSizeText(
                            _event.college_name,
                            minFontSize: 5,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //////////////////////////////////////////////////////////////////////////////
              /*
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                    icon: _event.status == "active"
                        ? Icon(Icons.verified_outlined)
                        : Icon(Icons.access_time), //icon image
                    label: AutoSizeText(_event.status), //text to show in button
                    onPressed: () {},
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.share_outlined), //icon image
                    label: AutoSizeText('Share'), //text to show in button
                    onPressed: () {},
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.visibility_outlined), //icon image
                    label: AutoSizeText('View'), //text to show in button
                    onPressed: () {},
                  ),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );*/
  }
}

class EventTileCalendar extends StatefulWidget {
  final bool visible;
  final int index;
  final String route;
  EventTileCalendar(this.visible, this.index, this.route);
  @override
  State createState() => new EventTileCalendarState();
}

class EventTileCalendarState extends State<EventTileCalendar> {
  String token = "", id = "", email = "";
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvent(widget.index);
    return Row(
      children: [
        Container(
          width: 60,
          //height: 200,
          margin: EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RotatedBox(
                quarterTurns: 3,
                child: new Text(_event.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(DateFormat('MMM dd').format(_event.start_time),
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              Text(DateFormat('yyyy').format(_event.start_time),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: Visibility(
            visible: widget.visible,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 5.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                elevation: 7.0,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  onTap: () {
                    if (widget.route == "info_page") {
                      Navigator.pushNamed(context, Routes.info_page,
                          arguments: {'index': widget.index});
                    } else if (widget.route == "myevents_info_page") {
                      /*  Navigator.pushNamed(
                        context,
                        Routes.my_events_info_page,
                        arguments: {'index': widget.index},
                      );*/
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: [
                            Center(
                                child: Image(
                              image: NetworkImage(
                                  "${Url.URL}/api/image?id=${_event.imageUrl}"),
                            )
                                /* CachedNetworkImage(
                                imageUrl:
                                    "${Url.URL}/api/image?id=${_event.imageUrl}",
                                filterQuality: FilterQuality.high,
                                fadeInDuration: Duration(milliseconds: 1000),
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
                                errorWidget: (context, url, error) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Icon(
                                    Icons.error,
                                    size: 80,
                                  ),
                                ),
                              ),
                              */
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
