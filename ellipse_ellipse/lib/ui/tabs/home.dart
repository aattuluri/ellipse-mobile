import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../repositories/index.dart';
import '../pages/filter_calendar.dart';
import '../pages/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../pages/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';
import '../../util/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../screens/index.dart';

class ItemCard extends StatelessWidget {
  final String text;
  final IconData icon;

  const ItemCard({Key key, @required this.text, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      //margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          top: 15,
          bottom: 24,
          right: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Icon(
                icon,
                size: 32,
                color:
                    Theme.of(context).textTheme.caption.color.withOpacity(0.9),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(text,
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

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

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String token = "", id = "", email = "", college_id = "";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoHeight = screenHeight * 0.4;
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            /*
            drawer: SingleChildScrollView(
              child: MultiLevelDrawer(
                backgroundColor: Theme.of(context).cardColor,
                rippleColor: Colors.blueGrey,
                subMenuBackgroundColor: Theme.of(context).cardColor,
                divisionColor: Theme.of(context).dividerColor.withOpacity(0.3),
                header: Container(
                  // height: size.height * 0.25,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        //leading: Icon(Icons.arrow_back),
                        trailing: Icon(Icons.arrow_back),
                        // title: Text("Close"),
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      Image.asset(
                        "assets/logo.png",
                        height: 50,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text("Ellipse")
                    ],
                  )),
                ),
                children: [
                  MenuItem(
                    leading: Icon(Icons.event_note),
                    content: Text("My Events"),
                    onClick: () {
                      Navigator.of(context).pop(true);
                      Navigator.pushNamed(context, Routes.my_events);
                    },
                  ),
                  MenuItem(
                    leading: Icon(Icons.event_available),
                    content: Text("Registered Events"),
                    onClick: () {},
                  ),
                  MenuItem(
                    leading: Icon(Icons.event_busy),
                    content: Text("Past Events"),
                    onClick: () {},
                  ),
/*
                  MenuItem(
                      leading: Icon(Icons.person),
                      trailing: Icon(Icons.arrow_right),
                      content: Text(
                        "My Profile",
                      ),
                      subMenuItems: [
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 1")),
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 2")),
                        SubMenuItem(
                            onClick: () {},
                            submenuContent: Text("Option 3 wywy ryhrw ywy")),
                      ],
                      onClick: () {}),
                  MenuItem(
                      leading: Icon(Icons.settings),
                      trailing: Icon(Icons.arrow_right),
                      content: Text("Settings"),
                      onClick: () {},
                      subMenuItems: [
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 1")),
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 2"))
                      ]),
                  MenuItem(
                      leading: Icon(Icons.payment),
                      trailing: Icon(Icons.arrow_right),
                      content: Text(
                        "Payments",
                      ),
                      subMenuItems: [
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 1")),
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 2")),
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 3")),
                        SubMenuItem(
                            onClick: () {}, submenuContent: Text("Option 4")),
                      ],
                      onClick: () {}),
                  */
                ],
              ),
            ),
            */
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(child: Particles(3)),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /*
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Icon(
                                Icons.menu,
                                size: 30,
                              ),
                              onTap: () {
                                scaffoldKey.currentState.openDrawer();
                              },
                            ),
                          ],
                        ),
                      ),
                      */

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/logo.png",
                              height: 50,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Ell",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "ipse",
                                  style: TextStyle(
                                      color: Color(0xffFCCD00),
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Hello,' + _userdetails.name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        /*
                                        TextSpan(text: '\n'),
                                        TextSpan(
                                            text: _userdetails.name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500)),
                                        */
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(540),
                                    child: Image(
                                      image: NetworkImage(
                                          "${Url.URL}/api/image?id=${_userdetails.profile_pic}"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EventSearch()));
                                    },
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Lets explore some events here...',
                                          hintStyle: TextStyle(fontSize: 17.0),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.search)),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.start,
                                    arguments: {'currebt_tab': 1},
                                  );
                                },
                                child: Material(
                                  color: Theme.of(context).cardColor,
                                  elevation: 4,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        top: 16.0,
                                        bottom: 32.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Events Available",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          model.allEvents.length.toString() +
                                              " Events",
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.95),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 7),
                                        child: InkWell(
                                          onTap: () => Navigator.pushNamed(
                                              context, Routes.my_events),
                                          child: ItemCard(
                                              text: "Manage Your Events",
                                              icon: Icons.event_note),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: InkWell(
                                          onTap: () => Navigator.pushNamed(
                                              context,
                                              Routes.registered_events),
                                          child: ItemCard(
                                              text: "Registered Events",
                                              icon: Icons.event_available),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Latest Events",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.start,
                                        arguments: {'currebt_tab': 1},
                                      );
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: <Widget>[
                                    for (var i = 0; i < 6; i++)
                                      if (model.allEvents[i].start_time
                                          .isAfter(DateTime.now())) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                            vertical: 5.0,
                                          ),
                                          child: Container(
                                            height: 200,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              elevation: 4.0,
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        Routes.info_page,
                                                        arguments: {
                                                      'index': i
                                                    }),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Url.URL}/api/image?id=${model.allEvents[i].imageUrl}",
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fadeInDuration: Duration(
                                                        milliseconds: 1000),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 200,
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.error,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
