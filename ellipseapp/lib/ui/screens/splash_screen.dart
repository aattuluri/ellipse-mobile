import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/index.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //SharedPreferences.setMockInitialValues({});
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // Positioned.fill(child: AnimatedBackground()),
            //Positioned.fill(child: Particles(10)),
            Positioned.fill(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ///#3282b8
                  /*  Image.asset(
                    "assets/logo.png",
                    height: 150,
                  ),

                  Text(
                    "E",
                    style: TextStyle(
                        color: Colors.white70,
                        //color: Color(0xFF3282b8),
                        fontSize: 300,
                        fontFamily: 'Gugi',
                        fontWeight: FontWeight.w900),
                  ),*/
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Ellipse",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        //color: Theme.of(context)
                        // .textTheme
                        //.caption
                        //.color
                        //.withOpacity(0.7),
                        fontSize: 55,
                        fontFamily: 'Gugi',
                        fontWeight: FontWeight.w800),
                  ),

                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "There’s a lot of events happening around you! Our mission is to explore best events to you!",
                    style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .caption
                            .color
                            .withOpacity(0.8),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              ),
            )),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.signin);
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 6.5 * MediaQuery.of(context).size.height / 100,
                      maxHeight:
                          7.9 * MediaQuery.of(context).size.height / 100),
                  decoration: BoxDecoration(
                    //color: Color(0xFF00BDAA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          4 * MediaQuery.of(context).size.width / 100),
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 2, child: Container()),
                      Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 25, color: Theme.of(context).accentColor),
                      ),
                      Expanded(
                        flex: 5,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 7 * MediaQuery.of(context).size.width / 100,
                          color: Theme.of(context).accentColor,
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
    );
  }
}
