import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/index.dart';
import '../../ui/screens/auth_screen.dart';
import '../../util/index.dart';
import '../../util/constants.dart' as Constants;
import '../widgets/index.dart';

class SplashScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool logged = false;
  redirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedin = (prefs.getBool(Constants.LOGGED_IN) ?? false);
    if (loggedin) {
      Navigator.pushNamed(context, Routes.initialization);
    } else {
      Navigator.pushNamed(context, Routes.signin);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Image.asset(
                  "assets/logo.png",
                  height: 150,
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Ell",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'Gugi',
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "i",
                      style: TextStyle(
                          color: Color(0xffFFA700),
                          fontSize: 45,
                          fontFamily: 'Gugi',
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "pse",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'Gugi',
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "There’s a lot of events happening around you! Our mission is to explore awesome events to you!",
                  style: TextStyle(
                      color: Colors.white,
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
              redirect();
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 6.5 * MediaQuery.of(context).size.height / 100,
                    maxHeight: 7.9 * MediaQuery.of(context).size.height / 100),
                decoration: BoxDecoration(
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
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      flex: 5,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 7 * MediaQuery.of(context).size.width / 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
