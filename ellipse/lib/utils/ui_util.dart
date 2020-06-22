import 'package:flutter/material.dart';

class UIUtil {
  static double drawerWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width < 375)
      return MediaQuery.of(context).size.width * 0.94;
    else
      return MediaQuery.of(context).size.width * 0.85;
  }

  static bool smallScreen(BuildContext context) {
    if (MediaQuery.of(context).size.height < 667)
      return true;
    else
      return false;
  }
}
