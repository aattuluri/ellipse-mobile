import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/ui_util.dart';
import '../../menu_drawer/menu_drawer.dart';
import '../../widgets/app_scaffold.dart';
import 'widgets/filters.dart';
import '../../pages/calendar_view.dart';
import '../../pages/post_event.dart';
import 'widgets/calender.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../models/mode_item_model.dart';
import 'widgets/tile.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../components/colors.dart';
import '../../components/constants.dart';
import '../../components/view_models/main_view_model.dart';
import '../../components/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';
import '../info_screen/info_screen.dart';
import '../../widgets/app_drawer.dart';
import '../../utils/database_helper.dart';
import '../../verification.dart';
import "../../verification.dart";

const margin = EdgeInsets.only(
  left: GLOBAL_EDGE_MARGIN_VALUE,
);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  bool isChecked = false;
  bool isFilter = false;
  DateTime d;
  TextEditingController _searchQuery;
  bool isSearching = false;
  String _searchvalue;
  String token = "", id = "", email = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("eveid", "");
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
    Map data = {'id': "$id"};
    var response =
        await http.post("http://192.168.43.215:4000/check", body: data);
    if (response.statusCode == 401) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => Check(),
      );
      Navigator.of(context).push(route);
    } else if (response.statusCode == 402) {
      Map data = {'email': "$email"};
      var response =
          await http.post("http://192.168.43.215:4000/emailverify", body: data);
      var jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => OtpPageEmailVerify(),
        );
        Navigator.of(context).push(route);
        print(jsonResponse['otp']);
      } else {
        print(response.body);
      }
    } else {
      print(response.body);
    }
  }

  List data;

  Future<List> getData() async {
    final response = await http.get("http://192.168.43.215:4000/events");
    return json.decode(response.body);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    setState(() {
      isSearching = false;
      isFilter = false;
    });
    _searchQuery = new TextEditingController();

    super.initState();
    getPref();
    this.getData();
    //check();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          new InkWell(
            onTap: () => scaffoldKey.currentState.openDrawer(),
            child: new Icon(
              Icons.menu,
              color: CustomColors.icon,
              size: 30,
            ),
          ),
          SizedBox(width: 15),
          Text(
            'Explore Events',
            style:
                TextStyle(color: CustomColors.primaryTextColor, fontSize: 23.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      cursorColor: CustomColors.primaryTextColor,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle:
            TextStyle(color: CustomColors.primaryTextColor, fontSize: 23),
      ),
      style: TextStyle(color: CustomColors.primaryTextColor, fontSize: 23.0),
      //onChanged: updateSearchQuery(_searchQuery),
      onChanged: (value) {
        _searchvalue = value;
      },
    );
  }

  List<Widget> _buildActions() {
    if (isSearching) {
      return <Widget>[
        new IconButton(
          icon: Icon(
            Icons.search,
            color: CustomColors.icon,
            size: 27,
          ),
          onPressed: () {},
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: Icon(
          Icons.search,
          color: CustomColors.icon,
          size: 27,
        ),
        onPressed: () {
          setState(() {
            isSearching = true;
            isFilter = false;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Container(
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 25, bottom: 25),
              child: GestureDetector(
                  child: new Icon(Icons.add_a_photo,
                      size: 40, color: CustomColors.icon),
                  onTap: () {
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) => PostEvent(),
                    );
                    Navigator.of(context).push(route);
                  }),
            ),
            drawer: SizedBox(
              width: UIUtil.drawerWidth(context),
              child: AppDrawer(
                child: MenuDrawer(),
              ),
            ),
            appBar: new AppBar(
              automaticallyImplyLeading: false,
              leading: isSearching
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: CustomColors.icon,
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
                  : null,
              title: isSearching ? _buildSearchField() : _buildTitle(context),
              actions: _buildActions(),
              backgroundColor: CustomColors.primaryColor,
            ),
            key: scaffoldKey,
            backgroundColor: CustomColors.primaryColor,
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
                                          : SizedBox(height: 0)
                                    ],
                                  );
                                }, childCount: 1),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                floating: true,
                                delegate: ContestTabHeader(
                                  Container(child: getFilterBarUI()),
                                ),
                              ),
                            ];
                          },
                          body: Container(
                            height: MediaQuery.of(context).size.height - 50,
                            child: new FutureBuilder<List>(
                              future: getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? new ItemList(
                                        list: snapshot.data,
                                      )
                                    : new Center(
                                        child: new CircularProgressIndicator(),
                                      );
                              },
                            ),
                            /*Consumer<MainViewModel>(
                              builder: (context, viewModel, _) {
                                return GridView.builder(
                                    physics:
                                        BouncingScrollPhysics(), // if you want IOS bouncing effect, otherwise remove this line
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      if (index > viewModel.nodes.length - 1) {
                                        return null;
                                      }
                                      ModeItemModel item =
                                          viewModel.nodes[index];

                                      return GestureDetector(
                                        onTap: () {
                                          var route = new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                InfoScreen(),
                                          );
                                          Navigator.of(context).push(route);
                                        },
                                        child: ModeTile1(
                                            indicatorColor: item.color,
                                            name: item.name,
                                            minutes: item.minutes,
                                            disabled: viewModel.modeStatus ==
                                                ModeStatus.running,
                                            onTap: () {}),
                                      );
                                    },
                                    scrollDirection: Axis.vertical);
                              },
                            ),*/
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
      );
    });
  }

  Widget getTimeDateUI() {
    return Padding(
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

                      showDemoDialog(context: context);
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
                                color: CustomColors.primaryTextColor),
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
                                    color: CustomColors.primaryTextColor,
                                  ),
                                )
                              : Text(
                                  '${DateFormat("dd, MMM").format(startDate)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: CustomColors.primaryTextColor,
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
                        builder: (BuildContext context) => Filters(),
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
                            'Choose event type',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: CustomColors.primaryTextColor),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'all',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: CustomColors.primaryTextColor),
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
                  color: CustomColors.container,
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
                      color: CustomColors.primaryTextColor,
                    ),
                    cursorColor: CustomColors.primaryTextColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17,
                          color: CustomColors.primaryTextColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.container,
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
                  child: Icon(Icons.search, size: 23, color: CustomColors.icon),
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: CustomColors.primaryColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: CustomColors.primaryColor,
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
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => CalendarView(),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.event, color: CustomColors.icon),
                          ),
                          Text(
                            'Calendar View',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: CustomColors.primaryTextColor),
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
                                color: CustomColors.primaryTextColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: CustomColors.icon),
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

  void showDemoDialog({BuildContext context}) {
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

class Eve {
  final String eid;
  final String eurl;
  final String ename;

  Eve(this.eid, this.eurl, this.ename);
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () async {
              //SharedPreferences sharedPreferences =
              //   await SharedPreferences.getInstance();
              //setState(() {
              //  sharedPreferences.setString("eveid", "${list[i]['_id']}");
              //});
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => InfoScreen(
                    eve: new Eve("${list[i]['_id']}",
                        "${list[i]['base64Image']}", "${list[i]['name']}")),
              );
              Navigator.of(context).push(route);
            },
            child: new Card(
              color: CustomColors.container,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    list[i]['user_id'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                          base64Decode(list[i]['base64Image'].toString()),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter),
                    ),
                  ),
                  Text(
                    list[i]['_id'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                  Text(
                    list[i]['fileName'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                  Text(
                    list[i]['description'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                  Text(
                    list[i]['start_time'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                  Text(
                    list[i]['finish_time'].toString(),
                    style: TextStyle(
                        fontSize: 20.0, color: CustomColors.primaryTextColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
