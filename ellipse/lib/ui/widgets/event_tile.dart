import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: InkWell(
          onTap: () {
            if (widget.route == "info_page") {
              Navigator.pushNamed(context, Routes.info_page,
                  arguments: {'index': widget.index, 'type': 'user'});
            } else if (widget.route == "myevents_info_page") {
              Navigator.pushNamed(
                context,
                Routes.info_page,
                arguments: {'index': widget.index, 'type': 'admin'},
              );
            } else if (widget.route == "null") {}
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
                        Text(
                          _event.name,
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
                            Text(
                              _event.start_time.toString().toDate(context),
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
                              Icons.location_on,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _event.college_name,
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
      /* Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
        child: InkWell(
          onTap: () {
            if (widget.route == "info_page") {
              Navigator.pushNamed(context, Routes.info_page,
                  arguments: {'index': widget.index, 'type': 'user'});
            } else if (widget.route == "myevents_info_page") {
              Navigator.pushNamed(
                context,
                Routes.info_page,
                arguments: {'index': widget.index, 'type': 'admin'},
              );
            } else if (widget.route == "null") {}
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 7.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: ConstrainedBox(
                constraints:
                    new BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      child: FadeInImage(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 1000),
                        image: NetworkImage(
                            "${Url.URL}/api/image?id=${_event.imageUrl}"),
                        placeholder: AssetImage('assets/icons/loading.gif'),
                      ),
                    ),
                    /*
                    Container(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            _event.name,
                            minFontSize: 5,
                            style: TextStyle(
                                fontSize: 18, fontFamily: "ProductSans"),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              AutoSizeText(
                                DateFormat('MMMM dd,yyyy EEE-HH:mm')
                                    .format(_event.start_time),
                                minFontSize: 5,
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              AutoSizeText(
                                _event.college_name,
                                minFontSize: 5,
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          /* Row(
                            children: [
                              Spacer(),
                              Chip(
                                label: _event.registered == true
                                    ? Text(
                                        "Registered",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    : Text(
                                        "Not Registered",
                                        style: TextStyle(fontSize: 12),
                                      ),
                              ),
                            ],
                          ),
                          */
                        ],
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
*/
      /* Padding(
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
                  arguments: {'index': widget.index, 'type': 'user'});
            } else if (widget.route == "myevents_info_page") {
              Navigator.pushNamed(
                context,
                Routes.info_page,
                arguments: {'index': widget.index, 'type': 'admin'},
              );
            } else if (widget.route == "null") {}
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
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 1000),
                          image: NetworkImage(
                              "${Url.URL}/api/image?id=${_event.imageUrl}"),
                          placeholder: AssetImage('assets/icons/loading.gif'),
                        ),
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 70.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.8),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.8),
                          ])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
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
                              Text(
                                  DateFormat('MMM dd')
                                      .format(_event.start_time),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text(DateFormat('yyyy').format(_event.start_time),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_event.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(DateFormat('EEEE').format(_event.finish_time),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                        Spacer(),
                        /*
                        Row(
                          children: <Widget>[
                            FloatingActionButton(
                              backgroundColor: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .color
                                  .withOpacity(0.2),
                              mini: true,
                              onPressed: () {},
                              child: Icon(
                                Icons.favorite_outline,
                                color: Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            FloatingActionButton(
                              backgroundColor: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .color
                                  .withOpacity(0.2),
                              mini: true,
                              onPressed: () {},
                              child: Icon(
                                Icons.share,
                                color: Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                          ],
                        ),
                        */
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      */
    );
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
