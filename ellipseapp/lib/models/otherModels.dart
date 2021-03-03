import 'dart:io';

import 'package:EllipseApp/models/formFieldModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilledData {
  String field, key;
  dynamic value;
  FilledData({this.field, this.key, this.value});
}

class TimeLineListTile {
  String title;
  String date;

  TimeLineListTile({this.title, this.date});
}

class TeamSize {
  String minSize, maxSize;
  TeamSize({this.minSize, this.maxSize});
}

class Member {
  String id, name, college, username, userPic;
  Member({this.id, this.name, this.college, this.username, this.userPic});
}

class FormFile {
  String title;
  File file;

  FormFile({@required this.title, @required this.file});
}

class Field {
  bool req;
  String title;
  String field;
  List options;
  Field(
      {@required this.req,
      @required this.title,
      @required this.field,
      @required this.options});
}

class ChatMessage {
  String senderPic;
  String senderId;
  bool statusUpdate;
  String senderName;
  String message;
  String time;
  ChatMessage(
      {@required this.senderPic,
      @required this.senderId,
      @required this.statusUpdate,
      @required this.senderName,
      @required this.message,
      @required this.time});
}
