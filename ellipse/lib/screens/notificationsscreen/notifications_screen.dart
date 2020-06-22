import 'package:intl/intl.dart';

import '../../components/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/colors.dart';
import '../../components/constants.dart';

List<int> time = [
  7,
  8,
  9,
  10,
  11,
  12,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  1,
  2,
  3,
  4,
  5,
  6
];

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime selected;
  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    super.initState();
  }

  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style: TextStyle(
            fontSize: 20.0, color: CustomColors.icon, letterSpacing: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Container(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: CustomColors.primaryColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                0,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      MyBackButton(),
                      SizedBox(width: 30),
                      Text(
                        'Calendar View',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: CustomColors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            border: Border.all(
                              color: CustomColors.icon,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24.0)),
                              onTap: () {
                                setState(() {
                                  currentMonthDate = DateTime(
                                      currentMonthDate.year,
                                      currentMonthDate.month,
                                      0);
                                  setListOfDate(currentMonthDate);
                                });
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                color: CustomColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            DateFormat('MMMM, yyyy').format(currentMonthDate),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: CustomColors.primaryTextColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            border: Border.all(
                              color: CustomColors.icon,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24.0)),
                              onTap: () {
                                setState(() {
                                  currentMonthDate = DateTime(
                                      currentMonthDate.year,
                                      currentMonthDate.month + 2,
                                      0);
                                  setListOfDate(currentMonthDate);
                                });
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: CustomColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 58.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dateList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return currentMonthDate.month == dateList[index].month
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = dateList[index];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        DateFormat('EEE')
                                            .format(dateList[index]),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: dateList[index] == selected
                                                ? Color(0xFFE46472)
                                                : CustomColors.primaryTextColor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        DateFormat('dd')
                                            .format(dateList[index]),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: dateList[index] == selected
                                                ? Color(0xFFE46472)
                                                : CustomColors.primaryTextColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null;
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: time.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${time[index]} ${time[index] > 8 ? 'PM' : 'AM'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: CustomColors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 5,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  _dashedText(),
                                  TaskContainer(
                                    title: 'Project Research',
                                    subtitle:
                                        'Discuss with the colleagues about the future plan',
                                    boxColor: LightColors.kLightYellow2,
                                  ),
                                  _dashedText(),
                                  TaskContainer(
                                    title: 'Work on Medical App',
                                    subtitle: 'Add medicine tab',
                                    boxColor: LightColors.kLavender,
                                  ),
                                  TaskContainer(
                                    title: 'Call',
                                    subtitle: 'Call to david',
                                    boxColor: LightColors.kPalePink,
                                  ),
                                  TaskContainer(
                                    title: 'Design Meeting',
                                    subtitle:
                                        'Discuss with designers for new task for the medical app',
                                    boxColor: LightColors.kLightGreen,
                                  ),
                                ],
                              ),
                            )
                          ],
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
    });
  }
}

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: CustomColors.icon,
          ),
        ),
      ),
    );
  }
}

class TaskContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color boxColor;

  TaskContainer({
    this.title,
    this.subtitle,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: boxColor, borderRadius: BorderRadius.circular(30.0)),
    );
  }
}

class LightColors {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
}
