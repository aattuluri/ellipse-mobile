import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

class NotificationItem extends StatelessWidget {
  final String title, description, time, status;
  final int num;
  final Function onTap;
  const NotificationItem({
    @required this.title,
    @required this.description,
    @required this.time,
    @required this.num,
    @required this.status,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                            child: Text(
                              "#" + num.toString(),
                              style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 16,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        status == "seen"
                            ? Icon(
                                Icons.chevron_right,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              )
                            : Chip(
                                backgroundColor:
                                    Theme.of(context).textTheme.caption.color,
                                label: Text(
                                  "New",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                )),
                      ]),
                    ),

                    /*Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
    */
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
