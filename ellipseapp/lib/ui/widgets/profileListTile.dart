import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const ProfileListTile(this.title, this.subtitle, this.icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).textTheme.bodyText1.color,
          //Theme.of(context).accentColor,
        ),
        child: Center(
          child: Icon(icon,
              size: 25, color: Theme.of(context).scaffoldBackgroundColor),
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
          Separator.spacer(space: 4),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'ProductSans',
          color: Theme.of(context).textTheme.caption.color,
        ),
      ),
      // trailing: trailing,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      onTap: () {},
    );
  }
}
