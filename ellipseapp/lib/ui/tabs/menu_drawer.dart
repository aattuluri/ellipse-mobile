import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class MenuDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loadPref();
    context.read<UserDetailsRepository>().refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserDetailsRepository>(builder: (context, model, child) {
        final UserDetails _userdetails =
            context.watch<UserDetailsRepository>().getUserDetails(0);
        return Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: ClampingScrollPhysics(),
            // scrollDirection: Axis.vertical,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DrawerHeaderItem(Icons.share, "Share", () {}),
                  DrawerHeaderItem(Icons.star_border, "Rate Us", () {}),
                  DrawerHeaderItem(
                      Icons.chat_bubble_outline, "Feedback", () {}),
                  DrawerHeaderItem(Icons.info_outline, "About", () {}),
                ],
              ),
              Divider(),
              // createDrawerHeader(),
              Column(
                children: [
                  DrawerItemsTitle("Event"),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                  DrawerItem(Icons.add, "Create Event", () {}),
                ],
              ),
            ],
          ),
        );
      }),
    );
    /*ConstrainedBox(
      constraints: new BoxConstraints(
          maxWidth: 270,
          // MediaQuery.of(context).size.width * 0.70,
          minWidth: 250),
      //MediaQuery.of(context).size.width * 0.70),
      child: Container(
        color: Theme.of(context).cardColor,
        child: ListView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DrawerHeaderItem(Icons.share, "Share", () {}),
                DrawerHeaderItem(Icons.star_border, "Rate Us", () {
                  FlutterWebBrowser.openWebPage(
                    url: 'https://play.google.com/store/apps',
                    androidToolbarColor: Theme.of(context).primaryColor,
                  );
                }),
                DrawerHeaderItem(Icons.chat_bubble_outline, "Feedback", () {
                  print("feedback");
                }),
                DrawerHeaderItem(Icons.info_outline, "About", () {}),
              ],
            ),
            Divider(
              thickness: 0.5,
            ),
            DrawerItemsTitle("Converter"),
            DrawerItem(Icons.autorenew, "Unit Converter", () {}),
            DrawerItem(Icons.monetization_on, "Currency Converter", () {}),
            Divider(
              thickness: 1.5,
            ),
            DrawerItemsTitle("Life"),
            DrawerItem(Icons.accessibility, "Age Calculator", () {}),
            DrawerItem(Icons.donut_large, "BMI Calculator", () {}),
            Divider(
              thickness: 1.5,
            ),
            DrawerItemsTitle("Finance"),
            DrawerItem(Icons.insert_chart, "Interest Calculator", () {}),
            DrawerItem(Icons.local_atm, "Loan Calculator", () {}),
            DrawerItem(Icons.local_offer, "Expense Calculator", () {}),
            DrawerItem(Icons.style, "GST Calculator", () {}),
            DrawerItem(Icons.attach_money, "EMI Calculator", () {}),
            Divider(
              thickness: 1.5,
            ),
            DrawerItemsTitle("Math"),
            DrawerItem(Icons.toll, "Numeral System", () {}),
            Divider(
              thickness: 1.5,
            ),
            DrawerItemsTitle("Other"),
            DrawerItem(Icons.settings, "Settings", () {}),
            DrawerItem(Icons.exit_to_app, "Exit App", () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }),
          ],
        ),
      ),
    );
    */
  }

  Widget createDrawerBodyItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget createDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('images/bg_header.jpeg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Welcome to Flutter",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
}
