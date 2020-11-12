import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Visibility(
      visible: widget.visible,
      child: InkWell(
        onTap: () {
          if (_event.finish_time.isBefore(DateTime.now())) {
          } else {
            Navigator.pushNamed(context, Routes.info_page, arguments: {
              'index': widget.index,
              'type': 'user',
              'event_': _event
            });
          }
        },
        child:
            /*Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            //borderRadius: BorderRadius.circular(8)
          ),
          child:*/
            Card(
          elevation: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 16, top: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            _event.name,
                            minFontSize: 15,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          AutoSizeText(
                            _event.start_time.toString().toDate(context),
                            minFontSize: 5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          AutoSizeText(
                            _event.event_type,
                            minFontSize: 5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            // topRight: Radius.circular(8),
                            //bottomRight: Radius.circular(8)
                            ),
                        child: FadeInImage(
                          width: w * 0.25,
                          height: w * 0.25,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 1000),
                          image: NetworkImage(
                              "${Url.URL}/api/image?id=${_event.imageUrl}"),
                          placeholder: AssetImage('assets/icons/loading.gif'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //),
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
        },
        child:
            /*Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            //borderRadius: BorderRadius.circular(8)
          ),
          child:*/
            Card(
          elevation: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 16, top: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            _event.name,
                            minFontSize: 15,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          AutoSizeText(
                            _event.start_time.toString().toDate(context),
                            minFontSize: 5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          AutoSizeText(
                            _event.event_type,
                            minFontSize: 5,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            // topRight: Radius.circular(8),
                            //bottomRight: Radius.circular(8)
                            ),
                        child: FadeInImage(
                          width: w * 0.25,
                          height: w * 0.25,
                          fit: BoxFit.fill,
                          fadeInDuration: Duration(milliseconds: 1000),
                          image: NetworkImage(
                              "${Url.URL}/api/image?id=${_event.imageUrl}"),
                          placeholder: AssetImage('assets/icons/loading.gif'),
                        ),
                      ),
                    ),
                  ),
                ],
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
        //),
      ),
    );
    /*  Navigator.pushNamed(
              context,
              Routes.info_page,
              arguments: {
                'index': widget.index,
                'type': 'admin',
                'event_': _event
              },
            );

   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Chip(
            label: Text(_event.status),
          ),
        ],
      ),
    ),*/
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
