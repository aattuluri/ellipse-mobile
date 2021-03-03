import 'package:flutter/material.dart';

class SlideMenuHeader extends StatelessWidget {
  final String text;
  const SlideMenuHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(
            start: 10.0,
            bottom: 10,
            top: 10,
          ),
          child: Text(text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(height: 3),
      ],
    );
  }
}

class SlideMenuItem extends StatelessWidget {
  final String text1, text2;
  final IconData icon;
  final Function onTap;
  const SlideMenuItem(this.icon, this.text1, this.text2, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 60.0,
            margin: EdgeInsetsDirectional.only(start: 15.0, end: 5),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(end: 13.0),
                  child: Container(
                    child: Icon(icon, size: 24),
                    margin:
                        EdgeInsets.only(top: 3, left: 3, bottom: 3, right: 3),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      text1,
                      style: TextStyle(
                          fontFamily: "NunitoSans",
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      text2,
                      style: TextStyle(
                          fontFamily: "NunitoSans",
                          fontWeight: FontWeight.w600,
                          fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }
}
