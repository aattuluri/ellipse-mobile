import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/routes.dart';

class EventTileGeneral extends StatefulWidget {
  final Events event_;
  EventTileGeneral(this.event_);
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
        context.watch<EventsRepository>().event(widget.event_.eventId);
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.info_page,
            arguments: {'type': 'user', 'event_': _event});
      },
      child: Card(
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
                          _event.startTime.toString().toDate(context),
                          minFontSize: 5,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AutoSizeText(
                          _event.eventType,
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
    );
  }
}

class EventTileAdmin extends StatefulWidget {
  final Events event_;
  EventTileAdmin(this.event_);
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
        context.watch<EventsRepository>().event(widget.event_.eventId);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.info_page,
          arguments: {'type': 'admin', 'event_': _event},
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          _event.startTime.toString().toDate(context),
                          minFontSize: 5,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AutoSizeText(
                          _event.eventType,
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
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_event.admin) ...[
                    Text(
                      'You are : Admin',
                      textAlign: TextAlign.start,
                    ),
                  ] else if (_event.moderator) ...[
                    Text('You are : Moderator'),
                  ],
                  SizedBox(
                    height: 5,
                  ),
                  Text('Event Status : ' + _event.status)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
