import 'package:auto_size_text/auto_size_text.dart';
import '../models/setting_item.dart';
import 'package:flutter/material.dart';
import '../utils/app_icons.dart';
import '../utils/styles.dart';
import '../utils/ui_util.dart';
import '../components/colors.dart';

class AppSettings {
  //Settings item with a dropdown option
  static Widget buildSettingsListItemDoubleLine(
      BuildContext context, String heading, String selected, IconData icon,
      {Function onPressed, bool disabled = false}) {
    return IgnorePointer(
      ignoring: disabled,
      child: FlatButton(
        highlightColor: CustomColors.primaryColor,
        splashColor: CustomColors.container,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(end: 13.0),
                child: Container(
                  child: Icon(icon,
                      color: disabled ? Colors.transparent : CustomColors.icon,
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
                    child: AutoSizeText(
                      heading,
                      style: disabled
                          ? AppStyles.textStyleSettingItemHeader45(context)
                          : AppStyles.textStyleSettingItemHeader(context),
                      maxLines: 1,
                      stepGranularity: 0.1,
                      minFontSize: 8,
                    ),
                  ),
                  Container(
                    width: UIUtil.drawerWidth(context) - 100,
                    child: AutoSizeText(
                      selected,
                      style: disabled
                          ? AppStyles.textStyleSettingItemSubheader30(context)
                          : AppStyles.textStyleSettingItemSubheader(context),
                      maxLines: 1,
                      stepGranularity: 0.1,
                      minFontSize: 8,
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
      highlightColor: CustomColors.primaryColor,
      splashColor: CustomColors.container,
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
                  color: CustomColors.icon,
                  size: 24,
                ),
                margin: EdgeInsetsDirectional.only(
                  top: 3,
                  start: settingIcon == AppIcons.logout
                      ? 6
                      : settingIcon == AppIcons.changerepresentative
                          ? 0
                          : settingIcon == AppIcons.backupseed
                              ? 1
                              : settingIcon == AppIcons.transferfunds ? 2 : 3,
                  bottom: 3,
                  end: settingIcon == AppIcons.logout
                      ? 0
                      : settingIcon == AppIcons.changerepresentative
                          ? 6
                          : settingIcon == AppIcons.backupseed
                              ? 5
                              : settingIcon == AppIcons.transferfunds ? 4 : 3,
                ),
              ),
            ),
            Container(
              width: UIUtil.drawerWidth(context) - 100,
              child: Text(
                heading,
                style: AppStyles.textStyleSettingItemHeader(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
