import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/index.dart';
import '../../ui/screens/auth_screen.dart';
import '../../util/index.dart';
import '../../util/constants.dart' as Constants;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  loggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool(Constants.LOGGED_IN) ?? false);
    if (loggedin) {
      Navigator.pushNamed(context, Routes.initialization);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new AuthScreen(),
      );
      Navigator.of(context).push(route);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        /*
        Container(
          child: Image.asset("assets/background.png", fit: BoxFit.fill),
        ),
        */
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: 70,
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "ELL",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "IPSE",
                    style: TextStyle(
                        color: Color(0xffFFA700),
                        fontSize: 45,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "There’s a lot happening around you! Our mission is to provide what’s happening near you!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                onTap: () {
                  loggedin();
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 40,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
