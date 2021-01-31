import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLineListTile {
  String title;
  String date;

  TimeLineListTile({this.title, this.date});
}

class Member {
  String id, name, college, username, userPic;
  Member({this.id, this.name, this.college, this.username, this.userPic});
}

class Field {
  String title;
  String field;
  List options;
  Field({this.title, this.field, this.options});
}

class Round {
  String title, description, link;
  DateTime startDate, endDate;
  List<Object> fields;
  Round(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.link,
      this.fields});
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
