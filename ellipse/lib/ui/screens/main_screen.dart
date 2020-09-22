import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => context.read<EventsRepository>().refreshData(),
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.menu,
                    size: 30,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
              ),
              actions: [],
              elevation: 4,
              title: Text(
                "",
                style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
            ),
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
                    ],
                  )),
                ),
                children: [
                  MenuItem(
                    leading: Icon(Icons.event_note),
                    content: Text("Signin"),
                    onClick: () {
                      Navigator.pushNamed(context, Routes.signin);
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
            body: Stack(
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}
