import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../util/index.dart';

const String version = '0.4.20';

class NoGrowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  ScrollController _scrollController;
  bool _scroll;
  @override
  void initState() {
    super.initState();
    _scroll = false;
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 0 && !_scroll && mounted) {
          setState(() => _scroll = true);
        }
        if (_scrollController.offset <= 0 && _scroll && mounted) {
          setState(() => _scroll = false);
        }
      });
  }

  Widget _listItem(
          BuildContext context, String text, IconData icons, String url) =>
      InkWell(
        onTap: () {},
        child: Container(
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icons, color: Theme.of(context).accentColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Text(text),
            ],
          ),
        ),
      );

  Widget _translatorInfo(BuildContext context, {String name}) => Container(
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(LineIcons.user, color: Theme.of(context).accentColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
                child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.fade,
            )),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("About"),
        elevation: _scroll ? 1 : 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoGrowBehavior(),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Ellipse",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 35,
                            fontFamily: 'Gugi',
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("version 1.0.0"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Ellipse is an application platform which can be used to post events.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.pdfView, arguments: {
                        'title': 'Privacy Policy',
                        'link': "https://ellipseapp.com/Privacy_Policy.pdf"
                      });
                      /*Navigator.pushNamed(context, Routes.mdDecode, arguments: {
                        'title': 'Privacy Policy',
                        'url':
                            'https://gunasekhar0027.github.io/ellipsedata/privacy_policy.md'
                      });*/
                    },
                    child: Text("Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.mdDecode, arguments: {
                        'title': 'Terms and Conditions',
                        'url':
                            'https://gunasekhar0027.github.io/ellipsedata/terms_and_conditions.md'
                      });
                    },
                    child: Text("Terms And Conditions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                  ),
                  /*
                  Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //  Text(
                        //    s.developer,
                        //    style: TextStyle(
                        //        color: context.accentColor,
                        //        fontWeight: FontWeight.bold),
                        //  ),
                        _listItem(context, 'Twitter @tsacdop',
                            LineIcons.twitter, 'https://twitter.com/tsacdop'),
                        _listItem(context, 'GitHub', LineIcons.github_alt,
                            'https://github.com/stonega/tsacdop'),
                        _listItem(context, 'Telegram', LineIcons.whatsapp,
                            'https://t.me/joinchat/Bk3LkRpTHy40QYC78PK7Qg'),

                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'I need to pay for podcast search API and '
                            'always get headache without caffeine.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Team",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _translatorInfo(context, name: 'Gunasekhar'),
                        _translatorInfo(context, name: 'Lalith Sagar'),
                        _translatorInfo(context, name: 'Anil Kumar'),
                      ],
                    ),
                  ),
                  //Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  InkWell(
                    onTap: () {
                      ''.launchUrl;
                    },
                    child: Text("Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTapDown: (detail) async {
                        OverlayEntry _overlayEntry;
                        Overlay.of(context).insert(_overlayEntry);
                        await Future.delayed(Duration(seconds: 2));
                        _overlayEntry?.remove();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.blue,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          FlutterLogo(
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "About Us",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: ListView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Center(
              child: Text(
                "Ellipse",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 50,
                    fontFamily: 'Gugi',
                    fontWeight: FontWeight.w800),
              ),
            ),
            Center(
              child: Text(
                'Version',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.caption.color),
              ),
            ),
            Center(
              child: Text(
                "_packageInfo.version",
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.caption.color),
              ),
            ),

            /* Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 15, bottom: 0),
                    child: Center(
                      child: Text(
                        'Our Team',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                    ),
                  ),
                  TeamItem(
                      "",
                      "Gunasekhar A",
                      "Developer",
                      "(Flutter Developer,Web Developer)",
                      "gunasekhar158@gmail.com",
                      "VIT University,Vellore",
                      () {}),
                  TeamItem(
                      "",
                      "Lalith Sagar P",
                      "Developer",
                      "(IOS Developer,Web Developer)",
                      "lalithpunepalli@gmail.com",
                      "VIT University,Vellore",
                      () {}),
                  TeamItem(
                      "",
                      "Anil Kumar A",
                      "Financer",
                      "(-------------------------------------------)",
                      "anilcs0405@gmail.com",
                      "--------------",
                      () {}),
                ]),*/
          ],
        ),
      ),
    );
  }
}

class TeamItem extends StatelessWidget {
  final String image;
  final String name;
  final String type;
  final String skills;
  final String email;
  final String address;
  final Function onTap;
  const TeamItem(this.image, this.name, this.type, this.skills, this.email,
      this.address, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: <Widget>[
              Text(
                type,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9D9D9),
                    backgroundImage: NetworkImage(image),
                    radius: 36.0,
                  ),
                  */
                  RichText(
                    text: TextSpan(
                      text: name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\n' + skills,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: '\n' + address,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
