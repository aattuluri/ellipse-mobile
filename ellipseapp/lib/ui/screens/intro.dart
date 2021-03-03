import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/index.dart';

final pagesCount = 4;

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int currentPage = 0;
  PageController _pageController;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _pageController = new PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: h,
            child: Column(
              children: [
                Container(
                  height: h * 0.10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlatButton(
                          onPressed: () {
                            if (currentPage == 0) {
                            } else {
                              _pageController.animateToPage(currentPage - 1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            }
                          },
                          child: Text(
                            "back",
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool loggedin =
                                (prefs.getBool('loggedIn') ?? false);
                            if (loggedin) {
                              Navigator.pushNamed(
                                context,
                                Routes.start,
                                arguments: {'currentTab': 0},
                              );
                            } else {
                              Navigator.pushNamed(context, Routes.signin);
                            }
                          },
                          child: Text(
                            "skip",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  height: h * 0.60,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      FirstPage(),
                      onBoardPage("event.svg",
                          "Find and register for all your College events from one App"),
                      onBoardPage(
                          "add.svg", "Post events and manage them with ease"),
                      onBoardPage("certificate.svg",
                          "Feature Rich dashboard for Event Administrators"),
                      onBoardPage("dashboard.svg",
                          "Create announcements, Live chat with participants and generate event certificates"),
                    ],
                    onPageChanged: (value) => {setCurrentPage(value)},
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  height: h * 0.05,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          pagesCount + 1, (index) => getIndicator(index))),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  height: h * 0.15,
                  child: GestureDetector(
                    onTap: () async {
                      print(currentPage);
                      if (currentPage == pagesCount) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool loggedin = (prefs.getBool('loggedIn') ?? false);
                        if (loggedin) {
                          Navigator.pushNamed(
                            context,
                            Routes.start,
                            arguments: {'current_tab': 0},
                          );
                        } else {
                          Navigator.pushNamed(context, Routes.signin);
                        }
                      } else {
                        _pageController.animateToPage(currentPage + 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      }
                    },
                    child: Container(
                      height: w * 0.15,
                      width: w * 0.15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor),
                      child: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setCurrentPage(int value) {
    setState(() {
      currentPage = value;
    });
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 10,
        width: (currentPage == pageNo) ? 20 : 10,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (currentPage == pageNo)
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.caption.color.withOpacity(0.6)));
  }

  Column onBoardPage(String filename, String title) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Opacity(
            opacity: 0.7,
            child: SvgPicture.asset(
              'assets/svg/$filename',
              colorBlendMode: BlendMode.overlay,
              allowDrawingOutsideViewBox: true,
              alignment: Alignment.center,
              width: w * 0.50,
              //height: w * 0.65,
            ),
          ),
          /* FlareActor(
            'assets/flares/$filename.svg',
            alignment: Alignment.center,
            animation: 'logo',
            fit: BoxFit.cover,
          ),
          */
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: AutoSizeText(
            title,
            minFontSize: 5,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        /*Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )*/
      ],
    );
  }

  Column FirstPage() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 18,
        ),
        /* Container(
          width: w,
          child: TextLiquidFill(
            text: 'Ellipse',
            textAlign: TextAlign.center,
            waveColor: Theme.of(context).accentColor,
            boxBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            textStyle: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 55,
                fontFamily: 'Gugi',
                fontWeight: FontWeight.w800),
            boxHeight: 200.0,
          ),
        ),*/

        Text(
          "Ellipse",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 55,
              fontFamily: 'Gugi',
              fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 14,
        ),
        Text(
          "There’s a lot of events happening around you! Our mission is to explore best events to you!",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).textTheme.caption.color.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(
          height: 14,
        ),
        SizedBox(
          height: 0,
          width: 0,
          child: SvgPicture.asset(
            'assets/svg/event.svg',
            colorBlendMode: BlendMode.overlay,
            allowDrawingOutsideViewBox: true,
            alignment: Alignment.center,
            width: w * 0.50,
            //height: w * 0.65,
          ),
        ),
      ],
    );
  }
}
