import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  _key.currentState.toggle();
                });
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
          ],
          elevation: 4,
          title: Text(
            "Drawer",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body: SliderMenuContainer(
            key: _key,
            isShadow: false,
            sliderOpen: SliderOpen.RIGHT_TO_LEFT,
            sliderMenuOpenOffset: 250,
            sliderMenu: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Text("Announcements",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(Icons.announcement, "Announcements",
                    "Your Announcements", () {}),
                SlideMenuItem1(Icons.add_alert, "Add Announcement",
                    "Add Announcement", () {}),
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Text("Chat",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(Icons.chat, "Chat", "Your Chat", () {}),
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Text("Registration",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(Icons.group, "Participants",
                    "Registered Participants", () {}),
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Text("Event",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 3),
                SlideMenuItem1(Icons.share, "Share", "Share Event", () {}),
                SlideMenuItem1(
                    Icons.edit_outlined, "Edit Event", "Edit Event", () {}),
                SlideMenuItem1(
                    Icons.delete, "Delete Event", "Delete Event", () {}),
              ],
            ),
            sliderMain: PostEvent()),
      ),
    );
  }
}
