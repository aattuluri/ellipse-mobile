library constants;

import 'package:flutter/material.dart';

class UIUtil {
  static double drawerWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width < 375)
      return MediaQuery.of(context).size.width * 0.90;
    else
      return MediaQuery.of(context).size.width * 0.80;
  }

  static bool smallScreen(BuildContext context) {
    if (MediaQuery.of(context).size.height < 667)
      return true;
    else
      return false;
  }
}

//import 'package:flutter/material.dart';
const LOGGED_IN = 'logged_in';
const CHECKED = 'checked';

const FINISHED_ON_BOARDING = 'finishedOnBoarding';
const EMAILVERIFY = 'verify';
const GLOBAL_EDGE_MARGIN_VALUE = 25.0;
const DRAWER_BUTTON_MARGIN_TOP = 6.0;
const NEUMORPHIC_DEFAULT_RADIUS = 14.0;
