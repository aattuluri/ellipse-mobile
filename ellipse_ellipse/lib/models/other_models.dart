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

enum MessageType2 {
  Sender,
  Receiver,
}

class SendMenuItems2 {
  String text;
  String time;
  IconData icons;
  MaterialColor color;
  SendMenuItems2(
      {@required this.text, @required this.icons, @required this.color});
}

class ChatMessage2 {
  String message;
  String time;
  MessageType2 type;
  String sender_type;
  ChatMessage2(
      {@required this.message,
      @required this.sender_type,
      @required this.type,
      @required this.time});
}
