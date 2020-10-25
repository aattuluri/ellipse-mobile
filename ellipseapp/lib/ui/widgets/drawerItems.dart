import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String text1;
  final IconData icon;
  final Function onTap;
  const DrawerItem(this.icon, this.text1, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 45.0,
            margin: EdgeInsetsDirectional.only(start: 15.0, end: 5),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(end: 13.0),
                  child: Container(
                    child: Icon(icon, size: 26),
                    margin:
                        EdgeInsets.only(top: 3, left: 5, bottom: 3, right: 10),
                  ),
                ),
                Text(
                  text1,
                  style: TextStyle(
                      fontFamily: "NunitoSans",
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}

class DrawerItemsTitle extends StatelessWidget {
  final String text;

  const DrawerItemsTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: 20.0,
        bottom: 10.0,
        top: 10.0,
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}

class DrawerHeaderItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  const DrawerHeaderItem(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Icon(
              icon,
              color: Theme.of(context).textTheme.caption.color,
              size: 24,
            ),
          ),
          Text(
            text,
            style: TextStyle(
                fontFamily: "NunitoSans",
                fontWeight: FontWeight.w600,
                fontSize: 11),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
