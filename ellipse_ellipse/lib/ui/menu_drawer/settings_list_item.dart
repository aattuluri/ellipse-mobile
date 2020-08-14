import 'package:flutter/material.dart';
import '../../util/index.dart';

class AppSettings {
  //Settings item with a dropdown option
  static Widget buildSettingsListItemDoubleLine(
      BuildContext context, String heading, String selected, IconData icon,
      {Function onPressed, bool disabled = false}) {
    return IgnorePointer(
      ignoring: disabled,
      child: FlatButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          } else {
            return;
          }
        },
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          height: 60.0,
          margin: EdgeInsetsDirectional.only(start: 30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(end: 13.0),
                child: Container(
                  child: Icon(icon,
                      color: disabled ? Colors.transparent : Colors.white,
                      size: 24),
                  margin: EdgeInsets.only(top: 3, left: 3, bottom: 3, right: 3),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: UIUtil.drawerWidth(context) - 100,
                    child: Text(
                      heading,
                      style: TextStyle(
                        fontFamily: "NunitoSans",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: UIUtil.drawerWidth(context) - 100,
                    child: Text(
                      heading,
                      style: TextStyle(
                        fontFamily: "NunitoSans",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Settings item without any dropdown option but rather a direct functionality
  static Widget buildSettingsListItemSingleLine(
      BuildContext context, String heading, IconData settingIcon,
      {Function onPressed}) {
    return FlatButton(
      //highlightColor: CustomColors.primaryColor,
      //splashColor: CustomColors.container,
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        } else {
          return;
        }
      },
      padding: EdgeInsets.all(0.0),
      child: Container(
        height: 60.0,
        margin: EdgeInsetsDirectional.only(start: 30.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(end: 13.0),
              child: Container(
                child: Icon(
                  settingIcon,
                  //color: CustomColors.icon,
                  size: 24,
                ),
                margin: EdgeInsetsDirectional.only(
                  top: 3,
                ),
              ),
            ),
            Container(
              width: UIUtil.drawerWidth(context) - 100,
              child: Text(
                heading,
                style: TextStyle(
                  fontFamily: "NunitoSans",
                  //fontSize: AppFontSizes.medium,
                  fontWeight: FontWeight.w600,
                  //color: CustomColors.primaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
