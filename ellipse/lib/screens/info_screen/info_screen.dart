import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../components/view_models/theme_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/colors.dart';
import '../../components/neumorphic_components/widgets.dart';
import 'widgets/tab_interface.dart';
import 'server_tab_screen.dart';
import 'event_tab.dart';
import 'details_tab.dart';
import '../homescreen/home_screen.dart';
import '../../models/events_model.dart';

class InfoScreen extends StatefulWidget {
  final Eve eve;
  InfoScreen({Key key, @required this.eve}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> with TickerProviderStateMixin {
  TabController _controller;
  ScrollController scrollController;
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  String token = "", id = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      preferences.setString("eveid", "${widget.eve.eid}");
    });
    print("$id");
  }

  @override
  void initState() {
    getPref();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() async {
    animationController.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TabInterface> tabs = [
      EventTab('Event'),
      DetailsTab('Details'),
      ServerTab('Announcements'),
    ];

    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.close,
                  color: CustomColors.icon,
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: CustomColors.icon),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.file_download),
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
                        Icon(Icons.share),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Share'),
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
                        break;
                      }
                  }
                },
              )
            ],
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors.primaryColor,
            elevation: 4,
            iconTheme: IconThemeData(color: CustomColors.icon),
            title: Text(
              "${widget.eve.ename}",
              style: TextStyle(
                  color: CustomColors.primaryTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          backgroundColor: CustomColors.primaryColor,
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {},
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 8, right: 8),
                                      child: Card(
                                        elevation: 7,
                                        child: Image.memory(
                                          base64Decode(widget.eve.eurl),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TabBar(
                                    indicatorColor:
                                        CustomColors.primaryTextColor,
                                    indicatorWeight: 3.0,
                                    labelPadding: EdgeInsets.all(0),
                                    controller: _controller,
                                    unselectedLabelColor: Colors.black,
                                    labelColor: Colors.black,
                                    tabs: List.generate(
                                      tabs.length,
                                      (index) {
                                        return Container(
                                          child: Center(
                                            child: Text(
                                              tabs[index].titleName,
                                              style: TextStyle(
                                                  color: CustomColors
                                                      .primaryTextColor),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: tabs,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: CustomColors.primaryColor,

      // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: searchUI,
    );
    //return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
