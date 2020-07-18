import 'dart:async';
import 'package:big_tip/big_tip.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../pages/filter_calendar.dart';
import '../pages/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';
import '../pages/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';
import '../../util/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';

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

/// This tab holds main information about the next launch.
/// It has a countdown widget.
class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 31));
  bool isChecked = true;
  bool isFilter = false;

  DateTime d;
  final TextEditingController _searchQuery = new TextEditingController();
  bool isSearching = false;
  String _searchText = "";
  String token = "", id = "", email = "", college = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college = preferences.getString("college");
    });
  }

  bool mycollege = true;
  bool allcolleges = false;
  bool all = true;
  bool online = false;
  bool offline = false;
  bool paid = false;
  bool free = false;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getPref();
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
    var horizontalTitleAlignment = CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          SizedBox(width: 15),
          Text(
            'Events',
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 23.0),
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
        icon: Icon(
          Icons.search,
          color: Theme.of(context).textTheme.caption.color,
          size: 27,
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
        child: SafeArea(
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
                          setState(() {
                            isSearching = false;
                          });
                        },
                      )
                    : Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                size: 27,
                              ),
                              onPressed: () => _onRefresh(context, model)),
                          IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                size: 27,
                              ),
                              onPressed: () => Navigator.pushNamed(
                                  context, Routes.calendar_view)),
                          IconButton(
                            icon: Icon(
                              Icons.sort,
                              color: Theme.of(context).textTheme.caption.color,
                              size: 27,
                            ),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
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
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).textTheme.caption.color,
                              size: 27,
                            ),
                            onPressed: () {
                              print(allcolleges);
                              setState(() {
                                isSearching = true;
                                isFilter = false;
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
            key: scaffoldKey,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 25, bottom: 25),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.post_event);
                },
                child:
                    new Icon(Icons.add_a_photo, size: 40, color: Colors.black),
              ),
            ),
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
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
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
                              /*SliverPersistentHeader(
                                pinned: true,
                                floating: true,
                                delegate: ContestTabHeader(
                                  Container(child: getFilterBarUI()),
                                ),
                              ),*/
                            ];
                          },
                          body: model.isLoading || model.loadingFailed
                              ? _loadingIndicator
                              : ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: model.allEvents?.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Events event = model.allEvents[index];
                                    final sdate =
                                        DateTime.parse(event.start_time);
                                    return isFilter
                                        ? mycollege
                                            ? event.college_id.toString().trim() ==
                                                    college.toString().trim()
                                                ? isChecked //////////multiple days
                                                    ? sdate.isAfter(DateTime(startDate.year, startDate.month, startDate.day - 1)) && sdate.isBefore(DateTime(endDate.year, endDate.month, endDate.day + 1))
                                                        ? EventTile1(
                                                            event.name,
                                                            event.imageUrl,
                                                            index)
                                                        : Container()
                                                    /////////one day
                                                    : sdate.isAfter(DateTime.now()) && sdate.day == startDate.day && sdate.month == startDate.month && sdate.year == startDate.year
                                                        ? EventTile1(
                                                            event.name,
                                                            event.imageUrl,
                                                            index)
                                                        : Container()
                                                : Container()
                                            : allcolleges
                                                ? isChecked //////////multiple days
                                                    ? sdate.isAfter(DateTime(startDate.year, startDate.month, startDate.day - 1)) && sdate.isBefore(DateTime(endDate.year, endDate.month, endDate.day + 1))
                                                        ? EventTile1(
                                                            event.name,
                                                            event.imageUrl,
                                                            index)
                                                        : Container()
                                                    /////////one day
                                                    : sdate.isAfter(DateTime.now()) &&
                                                            sdate.day ==
                                                                startDate.day &&
                                                            sdate.month ==
                                                                startDate
                                                                    .month &&
                                                            sdate.year ==
                                                                startDate.year
                                                        ? EventTile1(
                                                            event.name,
                                                            event.imageUrl,
                                                            index)
                                                        : Container()
                                                : Container()
                                        //////////////////////////////filter///////////////////////////////////////
                                        /////////no filter
                                        : sdate.isAfter(DateTime.now())
                                            ? isSearching
                                                ? event.name
                                                        .toLowerCase()
                                                        .contains(_searchText.toLowerCase())
                                                    ? EventTile1(event.name, event.imageUrl, index)
                                                    : Container()
                                                : EventTile1(event.name, event.imageUrl, index)
                                            : Container();
                                  },
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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 10, top: 12),
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => Filters(
                            onApplyClick: (bool all1,
                                bool offline1,
                                bool online1,
                                bool free1,
                                bool paid1,
                                bool mycollege1,
                                bool allcolleges1) {
                              setState(() {
                                all = all1;
                                online = online1;
                                offline = offline1;
                                paid = paid1;
                                free = free1;
                                mycollege = mycollege1;
                                allcolleges = allcolleges1;
                              });
                            },
                          ),
                        );
                        Navigator.of(context).push(route);
                        //showFilterDialog(context: context);
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
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
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.caption.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17,
                          color: Theme.of(context).textTheme.caption.color),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : null,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 23,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.event,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          Text(
                            'Calendar View',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filters',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
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
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
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
