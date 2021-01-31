import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

extension LaunchUrl on String {
  Future get launchUrl async {
    if (await canLaunch(this)) {
      await launch(this);
    } else {
      Fluttertoast.showToast(
          msg: '$this is Invalid Link',
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }
}

extension DateFormatter on String {
  String toDate(BuildContext context) {
    String type;
    if (this == null) return '';
    String dt = this.toString();
    DateTime datetime = DateTime.parse(dt).toLocal();
    int year = datetime.year;
    int month = datetime.month;
    int day = datetime.day;
    int weekday = datetime.weekday;
    int hour = datetime.hour;
    String minute = datetime.minute.toString();
    if (minute.length == 1) {
      minute = "0$minute";
    } else {
      minute = "$minute";
    }
    if (hour > 12) {
      hour = hour - 12;
      type = "PM";
    } else {
      type = "AM";
    }
    String shour = hour.toString();
    if (shour.length == 1) {
      shour = "0$shour";
    } else {
      shour = "$shour";
    }
    DateTime Date = DateTime(year, month, day, weekday);
    String D = DateFormat('dd MMM yyyy').format(Date);
    String fullDate = D + " " "$shour:$minute $type".toString();
    return fullDate;
  }
}
