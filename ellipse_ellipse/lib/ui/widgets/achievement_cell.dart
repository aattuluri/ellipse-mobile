import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:row_collection/row_collection.dart';
import '../../util/index.dart';
import 'index.dart';

/// Widget used in SpaceX's achievement list, under the 'Home Screen'.
class AchievementCell extends StatelessWidget {
  final String title, subtitle, body, time;
  final int index;

  const AchievementCell({
    @required this.title,
    @required this.subtitle,
    @required this.body,
    @required this.time,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /*
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'ProductSans',
                        color: Tools.multiColors[Random().nextInt(5)]),
                  ),
                  */
                  SizedBox(height: 2),
                  Row(children: <Widget>[
                    Expanded(
                      child: Row(children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).accentColor,
                            //Theme.of(context).accentColor,
                          ),
                          child: Center(
                            child: Icon(Icons.notifications,
                                size: 23,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                          ),
                        ),
                        Separator.spacer(),
                        Expanded(
                          child: RowLayout(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            space: 2,
                            children: <Widget>[
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ProductSans',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'ProductSans',
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Separator.smallSpacer(),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'ProductSans',
                            //color: Tools.multiColors[Random().nextInt(5)]
                          ),
                        ),
                        //TextExpand.small(body),
                      ]),
                ]),
          ),
        ),
        Separator.divider(indent: 16),
      ],
    );
  }
}
