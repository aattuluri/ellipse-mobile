import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';

class ChatPage extends StatefulWidget {
  final String event_id, sender_type, event_uid;
  final index;
  ChatPage(this.event_id, this.sender_type, this.index, this.event_uid);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  WebSocketChannel channel;
  bool isLoading = false;
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

  getPref() async {
    setState(() {
      //isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get(
        "${Url.URL}/api/chat/load_messages?id=${widget.event_id}",
        headers: headers);
    // print(response.body);
    var data = json.decode(response.body);
    print(data);
    setState(() {
      // isLoading = false;
    });
    for (final item in data) {
      String sender_pic = item['user_pic'];
      String sender_name = item['user_name'];
      String message = item['message'];
      String dt = item['date'].toString();
      String senderid = item['user_id'];
      String type;
      DateTime datetime = DateTime.parse(dt).toLocal();
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

      this.setState(
        () => chatMessage.add(
          ChatMessage(
              sender_pic: sender_pic,
              sender_name: sender_name,
              message: message,
              time: time,
              // time: time,
              sender_type:
                  senderid == widget.event_uid ? "admin" : "participant",
              type: senderid == id
                  ? MessageType.Me
                  /* sender_type == "admin"
                      ? widget.sender_type != "admin"
                          ? MessageType2.Receiver
                          : MessageType2.Sender
                      : widget.sender_type != "participant"
                          ? MessageType2.Receiver
                          : MessageType2.Sender
              */
                  : MessageType.Other),
        ),
      );
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Future<void> initState() {
    _SearchListState();
    scrollController = ScrollController();

    getPref();

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      textController.text = "";
    });
    channel = IOWebSocketChannel.connect('${Url.WEBSOCKET_URL}');
    channel.stream.listen((data) {
      var response = json.decode(data);
      String action = response['action'];
      switch (action) {
        case "receive_message":
          print(response);
          String eventid = response['event_id'];
          print(eventid);
          dynamic msg = response['msg'];
          String sender_pic = msg['user_pic'];
          String sender_name = msg['user_name'];
          String message = msg['message'];
          String dt = msg['date'].toString();
          String senderid = msg['user_id'];
          print(msg['message']);
          String type;
          DateTime datetime = DateTime.parse(dt).toLocal();
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
                ChatMessage(
                    sender_pic: sender_pic,
                    sender_name: sender_name,
                    message: message,
                    time: time,
                    // time: time,
                    sender_type:
                        senderid == widget.event_uid ? "admin" : "participant",
                    type: senderid == id
                        ? MessageType.Me
                        /* sender_type == "admin"
                      ? widget.sender_type != "admin"
                          ? MessageType2.Receiver
                          : MessageType2.Sender
                      : widget.sender_type != "participant"
                          ? MessageType2.Receiver
                          : MessageType2.Sender
              */
                        : MessageType.Other),
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

  List<ChatMessage> chatMessage = [];

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
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
      child: isLoading
          ? SafeArea(
              child: Scaffold(
                body: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading Messages....",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    child: ListView.builder(
                      itemCount: chatMessage.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 5, bottom: 60),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                          chatMessage: chatMessage[index],
                        );
                      },
                    ),
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
                              /*
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
                        */
                              SizedBox(
                                width: 15,
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                      fontSize: 20),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Type here.....',
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    String datetime =
                                        DateTime.now().toUtc().toString();
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

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
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
          alignment: (widget.chatMessage.type == MessageType.Other
              ? Alignment.topLeft
              : Alignment.topRight),
          child: widget.chatMessage.type == MessageType.Me
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
                        widget.chatMessage.sender_name +
                            "(${widget.chatMessage.sender_type})",
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
                            height: 35,
                            width: 35,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(540),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      "${Url.URL}/api/image?id=${widget.chatMessage.sender_pic}"),
                                  placeholder:
                                      AssetImage('assets/icons/loading.gif'),
                                )),
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
