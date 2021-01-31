import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  int currentTab = 0;
  bool isFilter = false;
  final List tabs = [
    IconTab(name: "Upcoming", icon: Icons.update_outlined),
    IconTab(name: "Ongoing", icon: Icons.all_inclusive_outlined),
    IconTab(name: "Past", icon: Icons.access_time),
  ];

  var searchController = new TextEditingController();
  TabController tabController;
  bool isSearching = false;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 150));
  DateTime endDate = DateTime.now().add(const Duration(days: 150));
  bool isChecked = true;
  Decoration _getIndicator(BuildContext context) {
    return UnderlineTabIndicator(
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 3),
        insets: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0,
        ));
  }

  var feature1OverflowMode = OverflowMode.clipContent;
  var feature1EnablePulsingAnimation = false;

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          homeTabPostEvent,
          homeTabEventsSearch,
          homeTabEventsFilter
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<SearchProvider>(context, listen: false).reset();
    tabController.dispose();
    super.dispose();
  }

  double top = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Events> sliderEvents =
        Provider.of<EventsRepository>(context, listen: false).allEvents;
    return Consumer3<EventsRepository, DataProvider, SearchProvider>(
      builder: (context, event, data, search, child) => SafeArea(
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: AnimatedOpacity(
              opacity: isFilter || isSearching ? 0.0 : 1.0,
              duration: Duration(seconds: 1),
              child: featureDiscoveryOverlay(
                context,
                featureId: homeTabPostEvent,
                contentLocation: ContentLocation.above,
                tapTarget: const Icon(
                  Icons.add,
                  size: 40,
                ),
                title: 'Post Event',
                description: 'Click on plus button to post an event',
                child: FloatingActionButton(
                  backgroundColor:
                      Theme.of(context).accentColor.withOpacity(0.8),
                  onPressed: isFilter
                      ? () {}
                      : () {
                          Navigator.pushNamed(context, Routes.post_event);
                        },
                  child: new Icon(Icons.add, size: 40, color: Colors.black),
                ),
              ),
            ),
          ),
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: NestedScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text(
                      "Ellipse",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 30,
                          fontFamily: 'Gugi',
                          fontWeight: FontWeight.w800),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    elevation: 5,
                    actions: [
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        offset: Offset(0.0, 50.0),
                        elevation: 1,
                        onSelected: (i) async {
                          switch (i) {
                            case 1:
                              Navigator.pushNamed(context, Routes.settings);
                              break;
                            case 2:
                              Navigator.pushNamed(context, Routes.about_us);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Settings'),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text('About'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  /* SliverToBoxAdapter(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        pauseAutoPlayOnTouch: true,
                        pauseAutoPlayOnManualNavigate: true,
                        height: height * 0.25,
                        //enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(milliseconds: 3000),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                        aspectRatio: 2.0,
                      ),
                      items: [
                        for (var i = 0; i < sliderEvents.length; i++) ...[
                          HomeTabSlider(
                            imgUrl: sliderEvents[i].imageUrl,
                            onTap: () {},
                          ),
                        ]
                      ],
                    ),
                    /*SizedBox(
                      height: (width - 20) / 3,
                      width: width,
                      child: Container(),
                    ),*/
                  ),*/
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      tabBar: TabBar(
                        indicator: _getIndicator(context),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: tabController,
                        tabs: tabs.map((tab) {
                          return Tab(
                            child: Row(
                              children: [
                                Icon(
                                  tab.icon,
                                  size: 18,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    tab.name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      options: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          children: [
                            Spacer(),
                            featureDiscoveryOverlay(
                              context,
                              featureId: homeTabEventsFilter,
                              contentLocation: ContentLocation.below,
                              tapTarget: const Icon(LineIcons.filter),
                              title: 'Filter Events',
                              description: 'Filter events by type',
                              child: IconButton(
                                tooltip: 'Filter',
                                splashRadius: 20,
                                icon: Icon(
                                  LineIcons.filter,
                                  color: isFilter
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isFilter = !isFilter;
                                  });
                                },
                              ),
                            ),
                            PopupMenuButton(
                              tooltip: 'Re Order',
                              icon: Icon(Icons.sort),
                              offset: Offset(0.0, 50.0),
                              elevation: 1,
                              onSelected: (i) async {
                                switch (i) {
                                  case 1:
                                    context
                                        .read<EventsRepository>()
                                        .sortByName();
                                    break;
                                  case 2:
                                    context
                                        .read<EventsRepository>()
                                        .sortByTime();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Sort by name'),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text('Sort by time'),
                                ),
                              ],
                            ),
                            IconButton(
                              tooltip: 'Refresh',
                              splashRadius: 20,
                              icon: Icon(LineIcons.refresh),
                              onPressed: () async {
                                Provider.of<EventsRepository>(context,
                                        listen: false)
                                    .init();
                              },
                            ),
                            featureDiscoveryOverlay(
                              context,
                              featureId: homeTabEventsSearch,
                              contentLocation: ContentLocation.below,
                              tapTarget: Icon(Icons.search),
                              title: 'Search Events',
                              description: 'Search events ny name',
                              child: IconButton(
                                tooltip: 'Search',
                                splashRadius: 20,
                                icon: Icon(
                                  Icons.search,
                                  color: isSearching
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isSearching = !isSearching;
                                  });
                                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventSearch()),
                                  );*/
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Column(
                        children: [
                          isFilter ? getTimeDateUI() : SizedBox(height: 0),
                          isSearching ? getSearchBarUI() : SizedBox(height: 0),
                        ],
                      );
                    }, childCount: 1),
                  ),
                ];
              },
              body: event.isLoading
                  ? LoaderCircular("Loading Events")
                  : TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        //////Tab1/////
                        event.upcomingEvents.isEmpty
                            ? EmptyData('No Upcoming Events', "",
                                Icons.event_busy_outlined)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < event.upcomingEvents.length;
                                      i++)
                                    if (isFilter) ...[
                                      if (!isSearching ||
                                          event.upcomingEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        if (isChecked
                                            ? event.upcomingEvents[i].startTime
                                                    .isAfter(DateTime(
                                                        startDate.year,
                                                        startDate.month,
                                                        startDate.day - 1)) &&
                                                event
                                                    .upcomingEvents[i].startTime
                                                    .isBefore(DateTime(
                                                        endDate.year,
                                                        endDate.month,
                                                        endDate.day + 1))
                                            : event.upcomingEvents[i].finishTime
                                                    .isAfter(DateTime.now()) &&
                                                event.upcomingEvents[i]
                                                        .startTime.day ==
                                                    startDate.day &&
                                                event.upcomingEvents[i]
                                                        .startTime.month ==
                                                    startDate.month &&
                                                event.upcomingEvents[i]
                                                        .startTime.year ==
                                                    startDate.year) ...[
                                          if (data.filters.contains(
                                                  prefCollegeId.toString())
                                              ? event.upcomingEvents[i]
                                                      .collegeId
                                                      .toString()
                                                      .trim() ==
                                                  prefCollegeId
                                                      .toString()
                                                      .trim()
                                              : event.upcomingEvents[i]
                                                      .collegeId
                                                      .toString()
                                                      .trim() !=
                                                  null) ...[
                                            if (data.filters.contains(event
                                                    .upcomingEvents[i]
                                                    .eventMode) ||
                                                data.filters.contains(event
                                                    .upcomingEvents[i]
                                                    .paymentType)) ...[
                                              EventTileGeneral(
                                                  event.upcomingEvents[i])
                                            ]
                                          ]
                                        ]
                                      ]
                                    ] else if (!isFilter) ...[
                                      if (!isSearching ||
                                          event.upcomingEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        EventTileGeneral(
                                            event.upcomingEvents[i])
                                      ]
                                    ],
                                ],
                              ),
                        /////////Tab 2/////////
                        event.ongoingEvents.isEmpty
                            ? EmptyData('No Upcoming Events', "",
                                Icons.event_busy_outlined)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < event.ongoingEvents.length;
                                      i++)
                                    if (isFilter) ...[
                                      if (!isSearching ||
                                          event.ongoingEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        if (isChecked
                                            ? event.ongoingEvents[i].startTime
                                                    .isAfter(DateTime(
                                                        startDate.year,
                                                        startDate.month,
                                                        startDate.day - 1)) &&
                                                event.ongoingEvents[i].startTime
                                                    .isBefore(DateTime(
                                                        endDate.year,
                                                        endDate.month,
                                                        endDate.day + 1))
                                            : event.ongoingEvents[i].finishTime
                                                    .isAfter(DateTime.now()) &&
                                                event.ongoingEvents[i].startTime
                                                        .day ==
                                                    startDate.day &&
                                                event.ongoingEvents[i].startTime
                                                        .month ==
                                                    startDate.month &&
                                                event.ongoingEvents[i].startTime
                                                        .year ==
                                                    startDate.year) ...[
                                          if (data.filters.contains(
                                                  prefCollegeId.toString())
                                              ? event.ongoingEvents[i].collegeId
                                                      .toString()
                                                      .trim() ==
                                                  prefCollegeId
                                                      .toString()
                                                      .trim()
                                              : event.ongoingEvents[i].collegeId
                                                      .toString()
                                                      .trim() !=
                                                  null) ...[
                                            if (data.filters.contains(event
                                                    .ongoingEvents[i]
                                                    .eventMode) ||
                                                data.filters.contains(event
                                                    .ongoingEvents[i]
                                                    .paymentType)) ...[
                                              EventTileGeneral(
                                                  event.ongoingEvents[i])
                                            ]
                                          ]
                                        ]
                                      ]
                                    ] else if (!isFilter) ...[
                                      if (!isSearching ||
                                          event.ongoingEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        EventTileGeneral(event.ongoingEvents[i])
                                      ]
                                    ],
                                ],
                              ),
                        /*event.ongoingEvents.isEmpty
                            ? EmptyData('No Ongoing Events', "",
                                Icons.event_busy_outlined)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < event.ongoingEvents.length;
                                      i++) ...[
                                    if (!isSearching ||
                                        event.ongoingEvents[i].name
                                            .toLowerCase()
                                            .contains(search.searchText
                                                .toLowerCase()
                                                .trim())) ...[
                                      EventTileGeneral(event.ongoingEvents[i])
                                    ]
                                  ]
                                ],
                              ),*/
                        //////////Tab 3/////////
                        event.pastEvents.isEmpty
                            ? EmptyData('No Upcoming Events', "",
                                Icons.event_busy_outlined)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < event.pastEvents.length;
                                      i++)
                                    if (isFilter) ...[
                                      if (!isSearching ||
                                          event.pastEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        if (isChecked
                                            ? event.pastEvents[i].startTime
                                                    .isAfter(DateTime(
                                                        startDate.year,
                                                        startDate.month,
                                                        startDate.day - 1)) &&
                                                event.pastEvents[i].startTime
                                                    .isBefore(DateTime(
                                                        endDate.year,
                                                        endDate.month,
                                                        endDate.day + 1))
                                            : event.pastEvents[i].finishTime
                                                    .isAfter(DateTime.now()) &&
                                                event.pastEvents[i].startTime
                                                        .day ==
                                                    startDate.day &&
                                                event.pastEvents[i].startTime
                                                        .month ==
                                                    startDate.month &&
                                                event.pastEvents[i].startTime
                                                        .year ==
                                                    startDate.year) ...[
                                          if (data.filters.contains(
                                                  prefCollegeId.toString())
                                              ? event.pastEvents[i].collegeId
                                                      .toString()
                                                      .trim() ==
                                                  prefCollegeId
                                                      .toString()
                                                      .trim()
                                              : event.pastEvents[i].collegeId
                                                      .toString()
                                                      .trim() !=
                                                  null) ...[
                                            if (data.filters.contains(event
                                                    .pastEvents[i].eventMode) ||
                                                data.filters.contains(event
                                                    .pastEvents[i]
                                                    .paymentType)) ...[
                                              EventTileGeneral(
                                                  event.pastEvents[i])
                                            ]
                                          ]
                                        ]
                                      ]
                                    ] else if (!isFilter) ...[
                                      if (!isSearching ||
                                          event.pastEvents[i].name
                                              .toLowerCase()
                                              .contains(search.searchText
                                                  .toLowerCase()
                                                  .trim())) ...[
                                        EventTileGeneral(event.pastEvents[i])
                                      ]
                                    ],
                                ],
                              ),
                        /*event.pastEvents.isEmpty
                            ? EmptyData(
                                'No Past Events', "", Icons.event_busy_outlined)
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < event.pastEvents.length;
                                      i++) ...[
                                    if (!isSearching ||
                                        event.pastEvents[i].name
                                            .toLowerCase()
                                            .contains(search.searchText
                                                .toLowerCase()
                                                .trim())) ...[
                                      EventTileGeneral(event.pastEvents[i])
                                    ],
                                  ],
                                ],
                              ),*/
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Search for events',
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                        onChanged: (value) {
                          Provider.of<SearchProvider>(context, listen: false)
                              .changeSearchText(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.clear();
                          Provider.of<SearchProvider>(context, listen: false)
                              .changeSearchText('');
                        });
                      },
                      child: Icon(Icons.close)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: EdgeInsets.only(left: 18, bottom: 5, top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
                onTap: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => FilterCalendar(
                      barrierDismissible: true,
                      minimumDate: DateTime(DateTime.now().year - 5,
                          DateTime.now().month, DateTime.now().day),
                      maximumDate: DateTime(DateTime.now().year + 5,
                          DateTime.now().month, DateTime.now().day),
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
                  Navigator.of(context).push(route);
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
                            color: Theme.of(context).textTheme.caption.color),
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            )
                          : Text(
                              '${DateFormat("dd, MMM").format(startDate)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
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
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => Filters(
                      onApplyClick: (filters) {
                        setState(() {
                          Provider.of<DataProvider>(context, listen: false)
                              .updateFilters(filters);
                          //filtersList = filters;
                        });
                        print(Provider.of<DataProvider>(context, listen: false)
                            .filters);
                      },
                    ),
                  );
                  Navigator.of(context).push(route);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Filters',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Filter Events',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate({this.tabBar, this.options});
  TabBar tabBar;
  Widget options;
  @override
  double get minExtent => tabBar.preferredSize.height * 2 + 2;
  @override
  double get maxExtent => tabBar.preferredSize.height * 2 + 2;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          tabBar,
          Container(height: 2, color: Theme.of(context).cardColor),
          options
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return true;
  }
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/filterCalendar.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

const TextStyle dropDownTextStyle =
    TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400);
const TextStyle dropDownMenuStyle =
    TextStyle(color: Colors.black, fontSize: 16.0);
const lightGrey = Color(0xFFF3F3F3);

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final List tabs = [
    IconTab(name: "Upcoming", icon: Icons.update_outlined),
    IconTab(name: "Ongoing", icon: Icons.all_inclusive_outlined),
    IconTab(name: "Past", icon: Icons.access_time),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget view;
  TabController tabController;
  ScrollController scrollController;
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 31));
  bool isChecked = true;
  bool isSearching = false;
  bool isFilter = false;
  bool allTabs = true;
  DateTime d;
  List<String> filtersList = [
    "Offline",
    "Online",
    "Free",
    "Paid",
    prefCollegeId
  ];
  @override
  void initState() {
    loadPref();
    tabController = new TabController(
      length: tabs.length,
      vsync: this,
    );
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    setState(() {
      isFilter = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EventsRepository, SearchProvider>(
      builder: (context, event, search, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: isSearching
              ? SearchAppBar(
                  hintText: 'Search',
                  onChanged: (value) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .changeSearchText(value);
                  },
                )
              : Text(
                  "Ellipse",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 30,
                      fontFamily: 'Gugi',
                      fontWeight: FontWeight.w800),
                ),
          automaticallyImplyLeading: false,
          actions: isSearching
              ? [
                  TextButton(
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .reset();
                        setState(() {
                          isSearching = false;
                        });
                      },
                      child: Text('Cancel'))
                ]
              : [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            LineIcons.refresh,
                            color: Theme.of(context).textTheme.caption.color,
                            size: 27,
                          ),
                          onPressed: () {
                            context.read<EventsRepository>().refreshData();
                          }),
                      if (allTabs) ...[
                        IconButton(
                          icon: Icon(
                            LineIcons.filter,
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
                      ],
                      IconButton(
                        icon: Icon(
                          LineIcons.search,
                          color: Theme.of(context).textTheme.caption.color,
                          size: 27,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                          //Navigator.push(context,
                          // MaterialPageRoute(builder: (context) => EventSearch()));
                        },
                      )
                    ],
                  ),
                ],
          bottom: TabBar(
            onTap: (tab) {
              if (tab == 0) {
                setState(() {
                  allTabs = true;
                });
              } else {
                setState(() {
                  allTabs = false;
                });
                setState(() {
                  isFilter = false;
                });
              }
            },
            controller: tabController,
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
        key: _scaffoldKey,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: AnimatedOpacity(
            opacity: isFilter ? 0.0 : 1.0,
            duration: Duration(seconds: 1),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
              onPressed: isFilter
                  ? () {}
                  : () {
                      Navigator.pushNamed(context, Routes.post_event);
                    },
              child: new Icon(Icons.add, size: 40, color: Colors.black),
            ),
          ),
        ),
        body: event.isLoading || event.loadingFailed
            ? LoaderCircular("Loading Events")
            : TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  ///////////////////////////////Tab1//////////////////////////////////////
                  Scaffold(
                    body: Stack(
                      children: <Widget>[
                        NestedScrollView(
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
                            ];
                          },
                          body: event.isLoading || event.loadingFailed
                              ? Center(child: CircularProgressIndicator())
                              : event.upcomingEvents.isEmpty
                                  ? EmptyData('No Upcoming Events', "",
                                      Icons.event_busy_outlined)
                                  : ListView(
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      children: <Widget>[
                                        for (var i = 0;
                                            i < event.upcomingEvents.length;
                                            i++)
                                          if (isFilter) ...[
                                            if (!isSearching ||
                                                event.upcomingEvents[i].name
                                                    .toLowerCase()
                                                    .contains(search.searchText
                                                        .toLowerCase()
                                                        .trim())) ...[
                                              if (isChecked
                                                  ? event.upcomingEvents[i].startTime
                                                          .isAfter(DateTime(
                                                              startDate.year,
                                                              startDate.month,
                                                              startDate.day -
                                                                  1)) &&
                                                      event.upcomingEvents[i].startTime
                                                          .isBefore(DateTime(
                                                              endDate.year,
                                                              endDate.month,
                                                              endDate.day + 1))
                                                  : event.upcomingEvents[i].finishTime.isAfter(DateTime.now()) &&
                                                      event.upcomingEvents[i]
                                                              .startTime.day ==
                                                          startDate.day &&
                                                      event
                                                              .upcomingEvents[i]
                                                              .startTime
                                                              .month ==
                                                          startDate.month &&
                                                      event.upcomingEvents[i]
                                                              .startTime.year ==
                                                          startDate.year) ...[
                                                if (filtersList.contains(
                                                        prefCollegeId
                                                            .toString())
                                                    ? event.upcomingEvents[i]
                                                            .collegeId
                                                            .toString()
                                                            .trim() ==
                                                        prefCollegeId
                                                            .toString()
                                                            .trim()
                                                    : event.upcomingEvents[i]
                                                            .collegeId
                                                            .toString()
                                                            .trim() !=
                                                        null) ...[
                                                  if (filtersList.contains(event
                                                          .upcomingEvents[i]
                                                          .eventMode) ||
                                                      filtersList.contains(event
                                                          .upcomingEvents[i]
                                                          .paymentType)) ...[
                                                    EventTileGeneral(
                                                        event.upcomingEvents[i])
                                                  ]
                                                ]
                                              ]
                                            ]
                                          ] else if (!isFilter) ...[
                                            if (!isSearching ||
                                                event.upcomingEvents[i].name
                                                    .toLowerCase()
                                                    .contains(search.searchText
                                                        .toLowerCase()
                                                        .trim())) ...[
                                              EventTileGeneral(
                                                  event.upcomingEvents[i])
                                            ]
                                          ],
                                      ],
                                    ),
                        ),
                      ],
                    ),
                  ),
                  ///////////////////////////////Tab2//////////////////////////////////////
                  event.ongoingEvents.isEmpty
                      ? EmptyData(
                          'No Ongoing Events', "", Icons.event_busy_outlined)
                      : ListView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            for (var i = 0;
                                i < event.ongoingEvents.length;
                                i++) ...[
                              if (!isSearching ||
                                  event.ongoingEvents[i].name
                                      .toLowerCase()
                                      .contains(search.searchText
                                          .toLowerCase()
                                          .trim())) ...[
                                EventTileGeneral(event.ongoingEvents[i])
                              ]
                            ]
                          ],
                        ),
                  ///////////////////////////////Tab3//////////////////////////////////////
                  event.pastEvents.isEmpty
                      ? EmptyData(
                          'No Past Events', "", Icons.event_busy_outlined)
                      : ListView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            for (var i = 0;
                                i < event.pastEvents.length;
                                i++) ...[
                              if (!isSearching ||
                                  event.pastEvents[i].name
                                      .toLowerCase()
                                      .contains(search.searchText
                                          .toLowerCase()
                                          .trim())) ...[
                                EventTileGeneral(event.pastEvents[i])
                              ],
                            ],
                          ],
                        ),
                ],
              ),
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
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => FilterCalendar(
                          barrierDismissible: true,
                          minimumDate: DateTime(DateTime.now().year - 5,
                              DateTime.now().month, DateTime.now().day),
                          maximumDate: DateTime(DateTime.now().year + 5,
                              DateTime.now().month, DateTime.now().day),
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
                      Navigator.of(context).push(route);
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
                      FocusScope.of(context).requestFocus(FocusNode());
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => Filters(
                          onApplyClick: (filters) {
                            setState(() {});
                            setState(() {
                              filtersList = filters;
                            });
                            print(filtersList);
                          },
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filters',
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
                            'Filter Events',
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
*/
