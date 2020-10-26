import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Field {
  String title;
  String field;
  List options;
  Field({this.title, this.field, this.options});
}

class Field1 {
  String title;
  String field;
  List options;
  Field1({this.title, this.field, this.options});
}

enum MessageType {
  Me,
  Other,
}

class SendMenuItems {
  String text;
  String time;
  IconData icons;
  MaterialColor color;
  SendMenuItems(
      {@required this.text, @required this.icons, @required this.color});
}

class MessageData {
  String id;
  String user_id;
  String user_pic;
  String user_name;
  String message;
  String date;
  MessageData(
      {this.id,
      this.user_id,
      this.user_name,
      this.user_pic,
      this.message,
      this.date});
}

class ChatMessage {
  String sender_pic;
  String sender_name;
  String message;
  String time;
  MessageType type;
  String sender_type;
  ChatMessage(
      {@required this.sender_pic,
      @required this.sender_name,
      @required this.message,
      @required this.sender_type,
      @required this.type,
      @required this.time});
}
