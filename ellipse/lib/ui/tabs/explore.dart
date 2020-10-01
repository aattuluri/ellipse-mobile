import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/filter_calendar.dart';
import '../widgets/index.dart';

const TextStyle dropDownTextStyle =
    TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400);
const TextStyle dropDownMenuStyle =
    TextStyle(color: Colors.black, fontSize: 16.0);
const lightGrey = Color(0xFFF3F3F3);
Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Error"),
          action: SnackBarAction(
            label: "Error",
            onPressed: () => _onRefresh(context, repository),
          ),
        ),
      );
    }
    completer.complete();
  });

  return completer.future;
}

class IconTab {
  IconTab({
    this.name,
    this.icon,
  });

  final String name;
  final IconData icon;
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final List tabs = [
    IconTab(name: "All", icon: Icons.all_inclusive),
    IconTab(name: "Registered", icon: Icons.beenhere),
    IconTab(name: "Posted", icon: Icons.star),
    IconTab(name: "Past", icon: Icons.access_time),
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget view;
  TabController tab_controller;
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  ScrollController scrollController;
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 31));
  bool isChecked = true;
  bool isFilter = false;
  bool tab_all = true;
  DateTime d;
  final TextEditingController _searchQuery = new TextEditingController();
  bool isSearching = false;
  String _searchText = "";
  List<dynamic> registered = [];
  loadRegEvents() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get(
        "${Url.URL}/api/user/registeredEvents?id=$prefId",
        headers: headers);
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        registered = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<String> filters_list = [];
  bool mycollege = true;
  bool allcolleges = false;
  bool all = true;
  bool online = true;
  bool offline = true;
  bool paid = true;
  bool free = true;
  @override
  void initState() {
    loadPref();
    tab_controller = new TabController(
      length: 4,
      vsync: this,
    );
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loadRegEvents();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    setState(() {
      isSearching = false;
      isFilter = false;
    });
    _SearchListState();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 5),
          Text(
            "Ellipse",
            style: TextStyle(
                //color: Theme.of(context)
                //     .textTheme
                //  .caption
                //  .color
                //.withOpacity(0.8),
                color: Theme.of(context).accentColor,
                fontSize: 35,
                fontFamily: 'Gugi',
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      cursorColor: Theme.of(context).textTheme.caption.color,
      decoration: InputDecoration(
        hintText: 'Search...',
        icon: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.caption.color,
            size: 27,
          ),
          onPressed: () {
            setState(() {
              _searchQuery.clear();
            });
            setState(() {
              isSearching = false;
            });
          },
        ),
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Theme.of(context).textTheme.caption.color, fontSize: 23),
      ),
      style: TextStyle(
          color: Theme.of(context).textTheme.caption.color, fontSize: 23.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: isSearching ? _buildSearchField() : _buildTitle(context),
            actions: [
              isSearching
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).textTheme.caption.color,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchQuery.clear();
                        });
                      },
                    )
                  : Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.autorenew,
                              color: Theme.of(context).textTheme.caption.color,
                              size: 27,
                            ),
                            onPressed: () => _onRefresh(context, model)),
                        tab_all
                            ? IconButton(
                                icon: Icon(
                                  Icons.sort,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                  size: 27,
                                ),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (isFilter == false) {
                                    setState(() {
                                      isFilter = true;
                                    });
                                  } else {
                                    setState(() {
                                      isFilter = false;
                                    });
                                  }
                                },
                              )
                            : SizedBox.shrink(),
                        tab_all
                            ? IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                  size: 27,
                                ),
                                onPressed: () {
                                  print(allcolleges);
                                  setState(() {
                                    isSearching = true;
                                    isFilter = false;
                                  });
                                },
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
            ],
            bottom: TabBar(
              onTap: (tab) {
                if (tab == 0) {
                  setState(() {
                    tab_all = true;
                  });
                  context.read<EventsRepository>().refreshData();
                } else {
                  setState(() {
                    isFilter = false;
                    isSearching = false;
                  });
                  setState(() {
                    tab_all = false;
                  });
                }
              },
              controller: tab_controller,
              isScrollable: true,
              tabs: tabs.map((tab) {
                return Tab(
                  child: Row(
                    children: [
                      Icon(
                        tab.icon,
                        size: 18,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          tab.name,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          key: scaffoldKey,
          floatingActionButton: isFilter
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(right: 25, bottom: 25),
                  child: FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.8),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.post_event);
                    },
                    child: new Icon(Icons.add_a_photo,
                        size: 40, color: Colors.black),
                  ),
                ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tab_controller,
            children: <Widget>[
              ///////////////////////////////Tab1//////////////////////////////////////
              SafeArea(
                child: SliderMenuContainer(
                  key: _key,
                  isShadow: false,
                  sliderOpen: SliderOpen.RIGHT_TO_LEFT,
                  sliderMenuOpenOffset: MediaQuery.of(context).size.width * 0.7,
                  sliderMenu: ListView(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {});
                          _key.currentState.closeDrawer();
                        },
                        child: Container(
                          height: 60.0,
                          margin:
                              EdgeInsetsDirectional.only(start: 15.0, end: 5),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsetsDirectional.only(end: 13.0),
                                child: Container(
                                  child: Icon(Icons.arrow_forward, size: 24),
                                  margin: EdgeInsets.only(
                                      top: 3, left: 3, bottom: 3, right: 3),
                                ),
                              ),
                              Text(
                                "Close",
                                style: TextStyle(
                                    fontFamily: "NunitoSans",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 0,
                        ),
                        child: Center(
                          child: Text("Filters",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 0,
                        ),
                        child: Text("Filter by type",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    onTap: () {
                                      all
                                          ? setState(() {
                                              all = false;
                                              online = false;
                                              offline = false;
                                              paid = false;
                                              free = false;
                                            })
                                          : setState(() {
                                              all = true;
                                              online = true;
                                              offline = true;
                                              paid = true;
                                              free = true;
                                            });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            all
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: all
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                : Colors.grey.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "All",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    onTap: () {
                                      offline
                                          ? setState(() {
                                              this.setState(() => filters_list
                                                  .remove("offline"));

                                              offline = false;
                                              all = false;
                                            })
                                          : setState(() {
                                              this.setState(() =>
                                                  filters_list.add("offline"));
                                              offline = true;
                                            });
                                      online && offline && free && paid
                                          ? setState(() {
                                              all = true;
                                            })
                                          : null;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            offline
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: offline
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                : Colors.grey.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Offline",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    onTap: () {
                                      online
                                          ? setState(() {
                                              this.setState(() => filters_list
                                                  .remove("online"));
                                              online = false;
                                              all = false;
                                            })
                                          : setState(() {
                                              this.setState(() =>
                                                  filters_list.add("online"));
                                              online = true;
                                            });
                                      online && offline && free && paid
                                          ? setState(() {
                                              all = true;
                                            })
                                          : null;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            online
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: online
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                : Colors.grey.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Online",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    onTap: () {
                                      free
                                          ? setState(() {
                                              this.setState(() =>
                                                  filters_list.remove("free"));
                                              free = false;
                                              all = false;
                                            })
                                          : setState(() {
                                              this.setState(() =>
                                                  filters_list.add("free"));
                                              free = true;
                                            });
                                      online && offline && free && paid
                                          ? setState(() {
                                              all = true;
                                            })
                                          : null;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            free
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: free
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                : Colors.grey.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Free",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    onTap: () {
                                      paid
                                          ? setState(() {
                                              this.setState(() =>
                                                  filters_list.remove("paid"));
                                              paid = false;
                                              all = false;
                                            })
                                          : setState(() {
                                              this.setState(() =>
                                                  filters_list.add("paid"));
                                              paid = true;
                                            });
                                      online && offline && free && paid
                                          ? setState(() {
                                              all = true;
                                            })
                                          : null;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            paid
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: paid
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                : Colors.grey.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Paid",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 10.0,
                          bottom: 10,
                          top: 0,
                        ),
                        child: Text("Filter by college",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "My College",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                              ),
                              CupertinoSwitch(
                                activeColor: mycollege
                                    ? Theme.of(context).textTheme.caption.color
                                    : Colors.grey.withOpacity(0.6),
                                onChanged: (bool value) {
                                  setState(() {
                                    mycollege = value;
                                  });
                                  if (allcolleges == true && value == true) {
                                    setState(() {
                                      allcolleges = false;
                                    });
                                  }
                                  if (allcolleges == false && value == false) {
                                    setState(() {
                                      allcolleges = true;
                                    });
                                  }
                                },
                                value: mycollege,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "All Colleges",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                              ),
                              CupertinoSwitch(
                                activeColor: allcolleges
                                    ? Theme.of(context).textTheme.caption.color
                                    : Colors.grey.withOpacity(0.6),
                                onChanged: (bool value) {
                                  setState(() {
                                    allcolleges = value;
                                  });
                                  if (mycollege == true && value == true) {
                                    setState(() {
                                      mycollege = false;
                                    });
                                  }
                                  if (mycollege == false && value == false) {
                                    setState(() {
                                      mycollege = true;
                                    });
                                  }
                                },
                                value: allcolleges,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 35, right: 35, bottom: 16, top: 8),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24.0)),
                              highlightColor: Colors.transparent,
                              onTap: () {
                                try {
                                  _key.currentState.closeDrawer();
                                  filters_list.clear();
                                  if (online) {
                                    this.setState(
                                        () => filters_list.add("Online"));
                                  }
                                  if (offline) {
                                    this.setState(
                                        () => filters_list.add("Offline"));
                                  }
                                  if (free) {
                                    this.setState(
                                        () => filters_list.add("Free"));
                                  }
                                  if (paid) {
                                    this.setState(
                                        () => filters_list.add("Paid"));
                                  }
                                  print("filters_list");
                                  print(filters_list);
                                } catch (_) {
                                  print("error");
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Apply',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  sliderMain: Scaffold(
                    body: Stack(
                      children: <Widget>[
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: NestedScrollView(
                                  controller: _scrollController,
                                  headerSliverBuilder: (BuildContext context,
                                      bool innerBoxIsScrolled) {
                                    return <Widget>[
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: <Widget>[
                                              isFilter
                                                  ? getTimeDateUI()
                                                  : SizedBox(height: 0),
                                              SizedBox(height: 10.0),
                                            ],
                                          );
                                        }, childCount: 1),
                                      ),
                                    ];
                                  },
                                  body: model.isLoading || model.loadingFailed
                                      ? _loadingIndicator
                                      : ListView(
                                          physics: ClampingScrollPhysics(),
                                          //padding: EdgeInsets.symmetric(
                                          //   horizontal: 10.0),
                                          scrollDirection: Axis.vertical,
                                          children: <Widget>[
                                            for (var i = 0;
                                                i < model.allEvents.length;
                                                i++)
                                              if (isFilter &&
                                                  model.allEvents[i].start_time
                                                      .isAfter(
                                                          DateTime.now())) ...[
                                                if (isChecked
                                                    ? model.allEvents[i].start_time
                                                            .isAfter(DateTime(
                                                                startDate.year,
                                                                startDate.month,
                                                                startDate.day -
                                                                    1)) &&
                                                        model.allEvents[i]
                                                            .start_time
                                                            .isBefore(DateTime(
                                                                endDate.year,
                                                                endDate.month,
                                                                endDate.day +
                                                                    1))
                                                    : model.allEvents[i].start_time.isAfter(DateTime.now()) &&
                                                        model.allEvents[i].start_time.day ==
                                                            startDate.day &&
                                                        model
                                                                .allEvents[i]
                                                                .start_time
                                                                .month ==
                                                            startDate.month &&
                                                        model
                                                                .allEvents[i]
                                                                .start_time
                                                                .year ==
                                                            startDate.year) ...[
                                                  if (mycollege
                                                      ? model.allEvents[i]
                                                              .college_id
                                                              .toString()
                                                              .trim() ==
                                                          prefCollegeId
                                                              .toString()
                                                              .trim()
                                                      : model.allEvents[i]
                                                              .college_id
                                                              .toString()
                                                              .trim() !=
                                                          null) ...[
                                                    if (all || (online && offline && !paid && !free) || (paid && free && !online && !offline)) ...[EventTileGeneral(true, i, "info_page")] else if ((online &&
                                                            !offline &&
                                                            !paid &&
                                                            !free &&
                                                            model.allEvents[i].event_mode ==
                                                                "Online") ||
                                                        (!online &&
                                                            offline &&
                                                            !paid &&
                                                            !free &&
                                                            model.allEvents[i].event_mode ==
                                                                "Offline") ||
                                                        (!online &&
                                                            !offline &&
                                                            paid &&
                                                            !free &&
                                                            model.allEvents[i].payment_type ==
                                                                "Paid") ||
                                                        (!online &&
                                                            !offline &&
                                                            !paid &&
                                                            free &&
                                                            model.allEvents[i].payment_type == "Free")) ...[EventTileGeneral(true, i, "info_page")] else if ((!online && offline && paid && free && model.allEvents[i].event_mode != "Online") ||
                                                        (online &&
                                                            !offline &&
                                                            paid &&
                                                            free &&
                                                            model.allEvents[i].event_mode !=
                                                                "Offline") ||
                                                        (online &&
                                                            offline &&
                                                            !paid &&
                                                            free &&
                                                            model.allEvents[i].payment_type !=
                                                                "Paid") ||
                                                        (online && offline && paid && !free && model.allEvents[i].payment_type != "Free")) ...[EventTileGeneral(true, i, "info_page")] else if ((online &&
                                                            !offline &&
                                                            paid &&
                                                            !free &&
                                                            model.allEvents[i].event_mode == "Online" &&
                                                            model.allEvents[i].payment_type == "Paid") ||
                                                        (online && !offline && !paid && free && model.allEvents[i].event_mode == "Offline" && model.allEvents[i].payment_type == "Free") ||
                                                        (!online && offline && paid && !free && model.allEvents[i].event_mode == "Offline" && model.allEvents[i].payment_type == "Paid") ||
                                                        (!online && offline && !paid && free && model.allEvents[i].event_mode == "Offline" && model.allEvents[i].payment_type == "Free")) ...[EventTileGeneral(true, i, "info_page")]
                                                  ]
                                                ]
                                              ]
                                              //////////////////////////////filter///////////////////////////////////////
                                              /////////no filter
                                              else if (!isFilter &&
                                                  model.allEvents[i].start_time
                                                      .isAfter(
                                                          DateTime.now())) ...[
                                                if (isSearching && tab_all) ...[
                                                  if (model.allEvents[i].name
                                                          .toLowerCase()
                                                          .contains(_searchText
                                                              .toLowerCase()) &&
                                                      model.allEvents[i]
                                                          .start_time
                                                          .isAfter(DateTime
                                                              .now())) ...[
                                                    EventSearchItem(
                                                        model.allEvents[i]
                                                            .imageUrl,
                                                        model.allEvents[i].name,
                                                        () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          Routes.info_page,
                                                          arguments: {
                                                            'index': i,
                                                            'type': 'user'
                                                          });
                                                    })
                                                  ]
                                                ] else
                                                  EventTileGeneral(
                                                      true, i, "info_page")
                                              ]
                                          ],
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////////////////Tab2//////////////////////////////////////

              ListView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  for (var i = 0; i < model.allEvents.length; i++) ...[
                    for (var j = 0; j < registered.length; j++) ...[
                      if (registered[j]['user_id'] == prefId &&
                          registered[j]['event_id'] ==
                              model.allEvents[i].id) ...[
                        EventTileGeneral(true, i, "info_page")
                      ]
                    ]
                  ]
                ],
              ),
              ///////////////////////////////Tab3//////////////////////////////////////
              ListView(
                physics: ClampingScrollPhysics(),
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  for (var i = 0; i < model.allEvents.length; i++)
                    if (model.allEvents[i].user_id.toString().trim() ==
                        prefId.toString().trim()) ...[
                      EventTileGeneral(true, i, "myevents_info_page")
                    ],
                ],
              ),

              ///////////////////////////////Tab4//////////////////////////////////////
              ListView(
                physics: ClampingScrollPhysics(),
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (var i = 0;
                      i <
                          (model.allEvents.length > 6
                              ? 6
                              : model.allEvents.length);
                      i++)
                    if (model.allEvents[i].start_time
                        .isBefore(DateTime.now())) ...[
                      EventTileGeneral(true, i, "null")
                    ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCalendarDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        maximumDate: DateTime(
            DateTime.now().year + 5, DateTime.now().month, DateTime.now().day),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        isChecked: (bool isCheck) {
          setState(() {
            isChecked = isCheck;
            if (isCheck == false) {
              endDate = null;
              print(endDate);
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: EdgeInsets.only(left: 18, bottom: 10, top: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showCalendarDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          isChecked
                              ? Text(
                                  '${DateFormat("dd MMM").format(startDate)} - ${DateFormat("dd MMM").format(endDate)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                )
                              : Text(
                                  '${DateFormat("dd, MMM").format(startDate)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 2,
              height: 45,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      setState(() {
                        _key.currentState.toggle();
                      });
                      /*
                      FocusScope.of(context).requestFocus(FocusNode());
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => Filters(
                          onApplyClick: (bool all1, List filters,
                              bool mycollege1, bool allcolleges1) {
                            setState(() {
                              all = all1;
                              mycollege = mycollege1;
                              allcolleges = allcolleges1;
                            });
                            setState(() {
                              filters_list = filters;
                            });
                            print(filters_list);
                          },
                        ),
                      );
                      Navigator.of(context).push(route);
                      //showFilterDialog(context: context);
                      */
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filter Events',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'All',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    return searchUI;
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
