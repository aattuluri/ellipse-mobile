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
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../util/index.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

enum MessageType {
  Sender,
  Receiver,
}

class ChatTab1 extends StatefulWidget {
  final String event_id;
  final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  ChatTab1(this.event_id);
  @override
  _ChatTab1State createState() => _ChatTab1State();
}

class _ChatTab1State extends State<ChatTab1> {
  //SocketIO socketIO;
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    print(id);
  }

  load_messages() async {
    /*
    http.Response response = await http.get(
        "${Url.URL}/api/chat/getMessages?id =${widget.event_id}",
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    var jsonResponse = json.decode(response.body);
    print("Jsonresponse $jsonResponse");
    print('Response body: ${response.body}');
    */
  }

  @override
  void initState() {
    print("Event Id: ${widget.event_id}");
    getPref();
    _SearchListState();
    scrollController = ScrollController();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      textController.text = "";
    });
    /////////////////////////////////
    widget.channel.stream.listen((data) {
      print(data);
      String message = data;
      this.setState(
        () => chatMessage.add(
          ChatMessage(
              message: message,
              type: message.length > 5
                  ? MessageType.Sender
                  : MessageType.Receiver),
        ),
      );
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    });
    //////////////////////////////////
    /*
    socketIO = SocketIOManager().createSocketIO(
      'http://192.168.43.215:4000',
      '/',
    );
    socketIO.init();

    socketIO.connect();
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(
        () => chatMessage.add(
          ChatMessage(message: data['message'], type: MessageType.Receiver),
        ),
      );
      //this.setState(() => messages.add(data['message']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    */
    super.initState();
    /*
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 1000,
      duration: Duration(milliseconds: 600),
      curve: Curves.ease,
    );
    */
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  List<ChatMessage> chatMessage = [
    ChatMessage(message: "Hi John", type: MessageType.Receiver),
    ChatMessage(message: "Hope you are doin good", type: MessageType.Receiver),
    ChatMessage(
        message:
            "Hello Jane, I'm good what about you Hello Jane, I'm good what about you Hello Jane, I'm good what about you",
        type: MessageType.Sender),
    ChatMessage(
        message: "I'm fine, Working from homeI'm fine, Working from home",
        type: MessageType.Receiver),
    ChatMessage(message: "Oh! Nice. Same here man", type: MessageType.Sender),
    ChatMessage(message: "Hope you are doin good", type: MessageType.Receiver),
    ChatMessage(
        message:
            "Hello Jane, I'm good what about you Hello Jane, I'm good what about you Hello Jane, I'm good what about you",
        type: MessageType.Sender),
    ChatMessage(
        message: "I'm fine, Working from home", type: MessageType.Receiver),
    ChatMessage(message: "Hi John", type: MessageType.Receiver),
    ChatMessage(message: "Hope you are doin good", type: MessageType.Receiver),
    ChatMessage(
        message:
            "Hello Jane, I'm good what about you Hello Jane, I'm good what about you Hello Jane, I'm good what about you",
        type: MessageType.Sender),
    ChatMessage(
        message:
            "I'm fine, Working from home I'm fine, Working from home I'm fine, Working from home",
        type: MessageType.Receiver),
    ChatMessage(message: "Oh! Nice. Same here man", type: MessageType.Sender),
    ChatMessage(message: "Hope you are doin good", type: MessageType.Receiver),
  ];

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
                return ChatBubble(
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
                              if (textController.text.isNotEmpty) {
                                widget.channel.sink.add(textController.text);
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent +
                                      1000,
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.ease,
                                );
                                setState(() {
                                  textController.text = "";
                                });
                                /*
                                socketIO.sendMessage(
                                    'send_message',
                                    json.encode(
                                        {'message': textController.text}));
                                */
                                /*
                                this.setState(
                                  () => chatMessage.add(
                                    ChatMessage(
                                        message: textController.text,
                                        type: textController.text.length > 6
                                            ? MessageType.Sender
                                            : MessageType.Receiver),
                                  ),
                                );
                                */
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

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({@required this.message, @required this.type});
}

class SendMenuItems {
  String text;
  IconData icons;
  MaterialColor color;
  SendMenuItems(
      {@required this.text, @required this.icons, @required this.color});
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
          alignment: (widget.chatMessage.type == MessageType.Receiver
              ? Alignment.topLeft
              : Alignment.topRight),
          child: widget.chatMessage.type == MessageType.Sender
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
                              "8:00 pm",
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
                        "guna0027",
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
                                  widget.chatMessage.message,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "8:00 pm",
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
