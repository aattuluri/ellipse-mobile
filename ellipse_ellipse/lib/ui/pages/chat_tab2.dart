import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import '../widgets/index.dart';
//import 'package:flutter_socket_io/flutter_socket_io.dart';
//import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:core';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../util/index.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../util/index.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';

class ChatTab2 extends StatefulWidget {
  final String event_id, sender_type;
  final index;
  ChatTab2(this.event_id, this.sender_type, this.index);
  @override
  _ChatTab2State createState() => _ChatTab2State();
}

class _ChatTab2State extends State<ChatTab2> {
  WebSocketChannel channel;
  ScrollController scrollController;
  bool message = false;
  String token = "", id = "", email = "", college = "";
  String _messageText = "";
  var textController = new TextEditingController();
  _SearchListState() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        setState(() {
          _messageText = "";
          message = false;
        });
      } else {
        setState(() {
          _messageText = textController.text;
          message = true;
        });
      }
    });
  }

  load_meassages() async {
    var response = await http
        .get("${Url.URL}/api/chat/load_messages?id=${widget.event_id}");
    print(response.body);
    var data = json.decode(response.body);
    for (final item in data) {
      String sender_type = item['sender_type'];
      String message = item['message'];
      String dt = item['time'];
      String eventid = item['event_id'];
      String senderid = item['sender_id'];
      String type;
      DateTime datetime = DateTime.parse(dt);
      int hour = datetime.hour;
      String minute = datetime.minute.toString();
      if (minute.length == 1) {
        minute = "0$minute";
      } else {
        minute = "$minute";
      }
      if (hour > 12) {
        hour = hour - 12;
        type = "pm";
      } else {
        type = "am";
      }
      String time = "$hour:$minute $type".toString();
      if (widget.event_id == eventid) {
        this.setState(
          () => chatMessage.add(
            ChatMessage2(
                message: message,
                time: time,
                sender_type: sender_type,
                type: senderid == id
                    ? sender_type == "admin"
                        ? widget.sender_type != "admin"
                            ? MessageType2.Receiver
                            : MessageType2.Sender
                        : widget.sender_type != "participant"
                            ? MessageType2.Receiver
                            : MessageType2.Sender
                    : MessageType2.Receiver),
          ),
        );
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 1000,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      }
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    print(id);
  }

  @override
  Future<void> initState() {
    print("Event Id: ${widget.event_id}");
    getPref();
    _SearchListState();
    scrollController = ScrollController();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      textController.text = "";
    });
    load_meassages();
    channel = IOWebSocketChannel.connect('${Url.WEBSOCKET_URL}');
    channel.stream.listen((data) {
      print(data);
      var response = json.decode(data);
      String action = response['action'];
      switch (action) {
        case "receive_message":
          String sender_type = response['sender_type'];
          String message = response['message'];
          String dt = response['time'];
          String eventid = response['event_id'];
          String senderid = response['sender_id'];
          String type;
          DateTime datetime = DateTime.parse(dt);
          int hour = datetime.hour;
          String minute = datetime.minute.toString();
          if (minute.length == 1) {
            minute = "0$minute";
          } else {
            minute = "$minute";
          }
          if (hour > 12) {
            hour = hour - 12;
            type = "pm";
          } else {
            type = "am";
          }
          String time = "$hour:$minute $type".toString();
          if (widget.event_id == eventid) {
            this.setState(
              () => chatMessage.add(
                ChatMessage2(
                    message: message,
                    time: time,
                    sender_type: sender_type,
                    type: senderid == id
                        ? sender_type == "admin"
                            ? widget.sender_type != "admin"
                                ? MessageType2.Receiver
                                : MessageType2.Sender
                            : widget.sender_type != "participant"
                                ? MessageType2.Receiver
                                : MessageType2.Sender
                        : MessageType2.Receiver),
              ),
            );
            scrollController.animateTo(
              scrollController.position.maxScrollExtent + 1000,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeOut,
            );
          }
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  List<ChatMessage2> chatMessage = [];

  List<SendMenuItems2> menuItems = [
    SendMenuItems2(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems2(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems2(
        text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems2(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems2(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            //height: MediaQuery.of(context).size.height * 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: chatMessage.length,
              controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 5, bottom: 60),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ChatBubble2(
                  chatMessage: chatMessage[index],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 65,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: InkWell(
                            onTap: () {
                              showModal();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            autocorrect: false,
                            autofocus: false,
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
                            textInputAction: TextInputAction.unspecified,
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                            controller: textController,
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                fontSize: 20),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Type here.....',
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              String datetime = DateTime.now().toString();
                              if (textController.text.isNotEmpty) {
                                channel.sink.add(json.encode({
                                  'action': "send_message",
                                  'event_id': widget.event_id,
                                  'msg': {
                                    'id': id + datetime,
                                    'user_id': id,
                                    'user_name': _userdetails.username,
                                    'user_pic': _userdetails.profile_pic,
                                    'message': textController.text,
                                    'date': datetime
                                  }
                                }));
                                setState(() {
                                  textController.text = "";
                                });
                              } else {}
                            },
                            child: Icon(
                              Icons.send,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatBubble2 extends StatefulWidget {
  ChatMessage2 chatMessage;
  ChatBubble2({@required this.chatMessage});
  @override
  _ChatBubble2State createState() => _ChatBubble2State();
}

class _ChatBubble2State extends State<ChatBubble2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.content_copy,
                          size: 21.0,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          "Copy Message",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          size: 21.0,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          "Delete Message",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
        child: Align(
          alignment: (widget.chatMessage.type == MessageType2.Receiver
              ? Alignment.topLeft
              : Alignment.topRight),
          child: widget.chatMessage.type == MessageType2.Sender
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "You",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.80,
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SelectableText(
                              widget.chatMessage.message,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.chatMessage.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 45),
                      child: Text(
                        "guna0027(${widget.chatMessage.sender_type})",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundImage: AssetImage("assets/g.png"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.80,
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SelectableText(
                                  "${widget.chatMessage.message}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.chatMessage.time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
