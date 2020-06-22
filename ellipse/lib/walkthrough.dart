import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'screens/auth_screen.dart';
import 'components/constants.dart' as Constants;

class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  final List<String> _titlesList = [
    'Explore Events',
    'Post Events',
  ];

  final List<String> _subtitlesList = [
    'View upcoming Events.',
    'Manage your events',
  ];

  final List<IconData> _imageList = [
    Icons.explore,
    Icons.add_a_photo,
  ];
  final List<Widget> _pages = [];

  List<Widget> populatePages(BuildContext context) {
    _pages.clear();
    _titlesList.asMap().forEach((index, value) => _pages.add(getPage(
        _imageList.elementAt(index), value, _subtitlesList.elementAt(index))));
    _pages.add(getLastPage(context));
    return _pages;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            "skip",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ]),
        PageView(
          children: populatePages(context),
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildCircleIndicator(),
          ),
        )
      ],
    ));
  }

  @override
  Widget _buildCircleIndicator() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
              bottom: 5, left: MediaQuery.of(context).size.width * 0.2),
          child: CirclePageIndicator(
            selectedDotColor: Colors.white,
            dotColor: Colors.white30,
            selectedSize: 10,
            size: 10,
            itemCount: _pages.length,
            currentPageNotifier: _currentPageNotifier,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new AuthScreen(),
          );
          Navigator.of(context).push(route);
        },
        child: Container(
          margin: EdgeInsets.only(right: 25),
          child: Row(children: <Widget>[
            Text(
              "skip",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 22,
            ),
          ]),
        ),
      ),
    ]);
  }

  @override
  Widget getPage(IconData icon, String title, String subTitle) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffbb448), Color(0xffe46b10)])),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: new Icon(
                    icon,
                    color: Colors.white,
                    size: 130,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    subTitle,
                    style: TextStyle(color: Colors.white70, fontSize: 27.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget getLastPage(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffbb448), Color(0xffe46b10)])),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Welcome to',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Ell',
                      style: GoogleFonts.portLligatSans(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 70,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'i',
                          style: TextStyle(
                              color: Color.fromRGBO(128, 0, 0, 1),
                              fontSize: 70),
                        ),
                        TextSpan(
                          text: 'pse',
                          style: TextStyle(color: Colors.white, fontSize: 70),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 45,
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlineButton(
                      highlightedBorderColor: Colors.white,
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => AuthScreen(),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      shape: StadiumBorder(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
