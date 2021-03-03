import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class ChatScreen extends StatefulWidget {
  final String type;
  final String id;
  ChatScreen({this.type, this.id});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String tempDate = '';
  bool isLoading = false;
  List<Widget> listChatTiles = [];
  final ScrollController scrollController = ScrollController();
  bool message = false;
  var textController = new TextEditingController();
  messageFieldState() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        setState(() {
          message = false;
        });
      } else {
        setState(() {
          message = true;
        });
      }
    });
  }

  processMessage(dynamic msg) async {
    Events _event;
    if(widget.type == 'eventChat'){
      setState(() {
      _event = context.read<EventsRepository>().event(widget.id);
      });
    }
    String senderPic = msg['user_pic'];
    String messageType = msg['message_type'];
    String senderName = messageType == 'team_status_update_message'
        ? 'Ellipse Bot'
        : widget.type == 'eventChat'
            ? (msg['user_id'] == _event.userId)
                ? msg['user_name'] + " (Admin)"
                : msg['user_name']
            : msg['user_name'];
    String message = msg['message'];
    String dt = msg['date'].toString();
    String senderId = msg['user_id'];
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
      type = "PM";
    } else {
      type = "AM";
    }
    String time = "$hour:$minute $type".toString();
    String dateString = DateFormat('dd MMM yyyy').format(DateTime.parse(dt));
    if (listChatTiles.isEmpty) {
      this.setState(() => listChatTiles.add(ChatDateItem(dateString)));
    } else if (tempDate != '' &&
        DateTime.parse(dt).day != DateTime.parse(tempDate).day) {
      this.setState(() => listChatTiles.add(ChatDateItem(dateString)));
    } else {}
    setState(() {
      tempDate = dt;
    });
    this.setState(() => listChatTiles.add(
          ChatBubble(
            chatMessage: ChatMessage(
                statusUpdate: messageType == 'team_status_update_message',
                senderPic: senderPic,
                senderId: senderId,
                senderName: senderName,
                message: message,
                time: time),
          ),
        ));
    if (scrollController.hasClients) {
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 1), curve: Curves.bounceIn);
    }
  }

  loadMessages() async {
    var response;
    if (widget.type == 'eventChat') {
      response = await httpGetWithHeaders(
          "${Url.URL}/api/chat/load_messages?id=${widget.id}");
    } else if (widget.type == 'teamChat') {
      response = await httpGetWithHeaders(
          "${Url.URL}/api/chat/load_team_chat_messages?id=${widget.id}");
    } else {}
    var data = json.decode(response.body);
    for (final item in data) {
      processMessage(item);
    }
  }

  webSocketConnect() async {
    String userId = prefId;
    if (widget.type == 'eventChat') {
      sockets.send(json.encode({
        'action': 'join_event_room',
        'event_id': widget.id,
        'msg': {
          'user_id': '$userId',
        }
      }));
    } else if (widget.type == 'teamChat') {
      sockets.send(json.encode({
        'action': "join_team_room",
        'team_id': widget.id,
        'msg': {
          'user_id': '$userId',
        }
      }));
    } else {}
  }

  onMessage(String data) {
    var response = json.decode(data);
    print(data.toString());
    dynamic msg = response['msg'];
    String action = response['action'];
    if (action == "receive_event_chat_message") {
      print(msg);
      processMessage(msg);
    } else if (action == "receive_team_message") {
      processMessage(msg);
    } else {}
  }

  load() async {
    setState(() {
      isLoading = true;
      textController.text = "";
    });
    await loadMessages();
    await webSocketConnect();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loadPref();
    sockets.addListener(onMessage);
    messageFieldState();
    load();

    super.initState();
  }

  @override
  void dispose() {
    String userId = prefId;
    if (widget.type == 'eventChat') {
      sockets.send(json.encode({
        'action': "close_event_socket",
        'event_id': widget.id,
        'msg': {
          'user_id': '$userId',
        }
      }));
    } else if (widget.type == 'teamChat') {
      sockets.send(json.encode({
        'action': "close_event_socket",
        'team_id': widget.id,
        'msg': {
          'user_id': '$userId',
        }
      }));
    } else {}
    sockets.removeListener(onMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    if (isLoading) {
      return Scaffold(body: LoaderCircular('Loading Messages'));
    } else {
      return Scaffold(
        bottomNavigationBar: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).textTheme.bodyText1.color),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  autocorrect: false,
                  autofocus: false,
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  textInputAction: TextInputAction.unspecified,
                  keyboardType: TextInputType.multiline,
                  enabled: true,
                  controller: textController,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 20),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type here.....',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    onPressed: () {
                      String datetime =
                          DateTime.now().toIso8601String().toString();
                      if (textController.text.isNotEmpty) {
                        if (widget.type == 'eventChat') {
                          sockets.send(json.encode({
                            'action': "send_event_message",
                            'event_id': widget.id,
                            'msg': {
                              'id': prefId + datetime,
                              'user_id': prefId,
                              'user_name': _userdetails.name,
                              'user_pic': _userdetails.profilePic,
                              'message_type': 'normal_text_message',
                              'message': textController.text,
                              'date': datetime
                            }
                          }));
                        } else if (widget.type == 'teamChat') {
                          sockets.send(json.encode({
                            'action': "send_team_message",
                            'team_id': widget.id,
                            'msg': {
                              'id': prefId + datetime,
                              'user_id': prefId,
                              'user_name': _userdetails.name,
                              'user_pic': _userdetails.profilePic,
                              'message_type': 'normal_text_message',
                              'message': textController.text,
                              'date': datetime
                            }
                          }));
                        } else {}
                        setState(() {
                          textController.text = "";
                        });
                      } else {}
                    }),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: listChatTiles.length,
          physics: BouncingScrollPhysics(),
          reverse: true,
          controller: scrollController,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return listChatTiles[listChatTiles.length - 1 - index];
          },
        ),
      );
    }
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
    print('${widget.chatMessage.senderPic}');
    return ListTile(
      title: RichText(
        maxLines: 2,
        text: TextSpan(
          text: widget.chatMessage.senderName + '  ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: widget.chatMessage.time,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        widget.chatMessage.message,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme.of(context).textTheme.bodyText1.color,
        ),
        maxLines: 100,
      ),
      leading: Container(
        height: 40,
        width: 40,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(540),
            child: widget.chatMessage.statusUpdate
                ? Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        "E",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 25,
                            fontFamily: 'Gugi',
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                : widget.chatMessage.senderPic.isNullOrEmpty()
                    ? NoProfilePicChat()
                    : FadeInImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "${Url.URL}/api/image?id=${widget.chatMessage.senderPic}"),
                        placeholder: AssetImage('assets/icons/loading.gif'),
                      )),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      enabled: widget.chatMessage.senderId == prefId,
      onLongPress: () {
        if (widget.chatMessage.senderId == prefId) {
          generalSheet(
            context,
            title: "Options",
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*
                BottomSheetItem("Reply", Icons.reply, () {
                  Navigator.pushNamed(context, Routes.help_support);
                }),
                Divider(height: 1),*/
                BottomSheetItem("Copy", Icons.copy, () {
                  FlutterClipboard.copy(widget.chatMessage.message)
                      .then((value) {
                    flutterToast(
                        context, 'Copied to Clipboard', 1, ToastGravity.CENTER);
                  });
                  Navigator.pop(context);
                }),
                Divider(height: 1),
                BottomSheetItem("Delete", Icons.delete_outline_outlined, () {}),
              ],
            ),
          );
        } else {}
      },
    );
    /*GestureDetector(
      /* onLongPress: () => showDialog(
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
      ),*/
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
                        widget.chatMessage.senderName +
                            "(${widget.chatMessage.senderType})",
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
                                child:
                                    widget.chatMessage.senderPic.isNullOrEmpty()
                                        ? NoProfilePic()
                                        : FadeInImage(
                                            image: NetworkImage(
                                                "${Url.URL}/api/image?id=${widget.chatMessage.senderPic}"),
                                            placeholder: AssetImage(
                                                'assets/icons/loading.gif'),
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
    );*/
  }
}
