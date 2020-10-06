import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import '../../util/index.dart';

class EventSearchItem extends StatelessWidget {
  final String image, title;
  final Function onTap;
  const EventSearchItem(this.image, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              child: FadeInImage(
                image: NetworkImage("${Url.URL}/api/image?id=$image"),
                placeholder: AssetImage('assets/icons/loading.gif'),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          onTap: onTap,
        ),
        Separator.divider(indent: 16),
        //EventTile1(true, i, "info_page"),
      ],
    );
  }
}
