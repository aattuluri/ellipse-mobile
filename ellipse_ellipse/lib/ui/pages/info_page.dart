import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';
import 'package:sliver_fab/sliver_fab.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';

class InfoPage extends StatefulWidget {
  final int index;

  const InfoPage(this.index);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  String token = "", id = "", email = "", college = "";
  String _messageText = "";
  bool message = false;
  var textController = new TextEditingController();
  ScrollController _scrollController;
  List<MessageBubble> messageBubbles = [];
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
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

  @override
  void initState() {
    getPref();
    print(widget.index);
    super.initState();
    _SearchListState();
    _scrollController = ScrollController();
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
    messageBubbles.add(MessageBubble(
      sender: "rdhzeherhn",
      text: "ryhaey berevr ervreber ththh rethdrh rh erdh erheh  erh",
      isMe: false,
    ));
    messageBubbles.add(MessageBubble(
      sender: "afgsfhdghj",
      text: "ae brre beye yb ey n b b",
      isMe: true,
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    final sdate = DateTime.parse(_event.start_time);
    final fdate = DateTime.parse(_event.finish_time);
    final reg_last_date = DateTime.parse(_event.reg_last_date);
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(_event.name),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  offset: Offset(0, 50),
                  elevation: 1,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.favorite,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Add to Favourites'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.file_download,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Download'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.share,
                              color: Theme.of(context).textTheme.caption.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Share Event'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        {
                          break;
                        }
                      case 2:
                        {
                          Share.share(
                            "hgbjk",
                          );
                          break;
                        }
                    }
                  },
                ),
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              onTap: (index) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Details",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Chat",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Announcements",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Other",
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: MediaQuery.of(context).size.height * 0.25,
                      floating: false,
                      pinned: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => Container(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            "https://th.bing.com/th/id/OIP.WgCo2qYb7_GY4EI0Tay2XQHaHa?pid=Api&rs=1",
                                        placeholder: (context, url) =>
                                            Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Icon(
                                            Icons.image,
                                            size: 80,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                      SizedBox(height: 10),
                                      FloatingActionButton(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        tooltip: 'Increment',
                                        child: Icon(Icons.close, size: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://th.bing.com/th/id/OIP.WgCo2qYb7_GY4EI0Tay2XQHaHa?pid=Api&rs=1",
                              placeholder: (context, url) => Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.9,
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),

                            /*Image.memory(
                    base64Decode(
                      _event.imageUrl.toString(),
                    ),
                  ),*/
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.only(top: 0.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: RowLayout.cards(
                      children: <Widget>[
                        CardPage.header(
                          /*
                    leading: AbsorbPointer(
                      absorbing: true,
                      child: HeroImage.card(
                          url: "fgchj", tag: "fygh", onTap: () {}),
                    ),
                    */
                          title: _event.name,
                          subtitle: RowLayout(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            space: 6,
                            children: <Widget>[
                              ItemSnippet(
                                icon: Icons.calendar_today,
                                text: DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                    .format(sdate),
                              ),
                              _event.event_mode == "Offline"
                                  ? ItemSnippet(
                                      icon: Icons.location_on,
                                      text: _event.venue,
                                      onTap: () {})
                                  : ItemSnippet(
                                      icon: Icons.location_on,
                                      text: _event.platform_link,
                                      onTap: () {}),
                            ],
                          ),
                          details: _event.description,
                        ),
                        CardPage.body(
                          title: "Time Left",
                          body: RowLayout(
                              children: <Widget>[LaunchCountdown(sdate)]),
                        ),
                        CardPage.body(
                          title: "Important Dates",
                          body: RowLayout(children: <Widget>[
                            RowText(
                              "Event Start Date",
                              DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                  .format(sdate),
                            ),
                            RowText(
                              "Event Finish Date",
                              DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                  .format(fdate),
                            ),
                            Separator.divider(),
                            RowText(
                              "Registration Last Date",
                              DateFormat('EEE-MMMM dd, yyyy HH:mm')
                                  .format(reg_last_date),
                            )
                          ]),
                        ),
                        CardPage.body(
                          title: "Event Details",
                          body: RowLayout(children: <Widget>[
                            RowText(
                              "Event Type",
                              _event.event_type,
                            ),
                            RowText(
                              "Mode",
                              _event.event_mode,
                            ),
                            RowText(
                              "Event Cost",
                              _event.payment_type,
                            ),
                            _event.payment_type == "Paid"
                                ? RowText(
                                    "Registration Fee",
                                    _event.registration_fee,
                                  )
                                : Container(),
                          ]),
                        ),
                        CardPage.body(
                          title: " Event Registration",
                          body: RowLayout(children: <Widget>[
                            Text(
                              "Link",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            TextExpand(_event.reg_link),
                            Separator.divider(),
                            Text(
                              "Time left to Register",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            LaunchCountdown(reg_last_date),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        //reverse: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 15.0),
                        children: messageBubbles,
                      ),
                    ),
                    Center(
                      child: Container(
                        //color: Color(0x54FFFFFF),
                        padding: EdgeInsets.only(
                            left: 7, right: 7, top: 5, bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: TextField(
                                      autocorrect: false,
                                      cursorColor: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                      textInputAction:
                                          TextInputAction.unspecified,
                                      keyboardType: TextInputType.multiline,
                                      enabled: true,
                                      controller: textController,
                                      //autofocus: true,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                          fontSize: 20),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(13),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        hintText: "Type here...",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color,
                                            fontSize: 20),
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, top: 4, right: 15),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.keyboard_hide,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.content_paste,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Spacer(),
                                  message
                                      ? InkWell(
                                          onTap: () {
                                            messageBubbles.add(MessageBubble(
                                              sender: "rdhzeherhn",
                                              text: textController.text,
                                              isMe: false,
                                            ));
                                            setState(() {
                                              textController.text = "";
                                            });
                                            _scrollToBottom();
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.send,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {},
                                          child: Container(
                                            child: Icon(
                                              Icons.mic,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://d1dhn91mufybwl.cloudfront.net/collections/items/856aaec61aa77da73b05737i38712271/covers/page_1/medium"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "dbzb",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: 200.0,
                              child: Text("dzbbzfhgjh fhhhhh fxdb"),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: 200.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "srhfdgh",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  Container(
                                    height: 25.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Center(
                                      child: Text(
                                        "esrfhdty",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount: 50,
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
              SingleChildScrollView(
                child: Center(
                  child: Icon(
                    Icons.event_note,
                    size: 130,
                  ),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(isMe ? "You" : sender,
              style: TextStyle(
                fontSize: 12.0,
              )),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    bottomRight: Radius.circular(13.0))
                : BorderRadius.only(
                    topRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    bottomRight: Radius.circular(13.0)),
            elevation: 5.0,
            color: isMe ? Colors.blueGrey : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text("$text",
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15.0,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
