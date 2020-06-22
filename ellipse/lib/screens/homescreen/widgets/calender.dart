import '../../../components/colors.dart';
import '../../../components/view_models/theme_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPopupView extends StatefulWidget {
  const CalendarPopupView(
      {Key key,
      this.initialStartDate,
      this.initialEndDate,
      this.onApplyClick,
      this.onCancelClick,
      this.isChecked,
      this.barrierDismissible = true,
      this.minimumDate,
      this.maximumDate})
      : super(key: key);

  final DateTime minimumDate;
  final DateTime maximumDate;
  final bool barrierDismissible;
  final DateTime initialStartDate;
  final Function(bool) isChecked;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onApplyClick;

  final Function onCancelClick;
  @override
  _CalendarPopupViewState createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  DateTime startDate;
  DateTime endDate;
  bool isChecked = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Container(
          child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: animationController.value,
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    if (widget.barrierDismissible) {
                      Navigator.pop(context);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: CustomColors.primaryTextColor
                                    .withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CustomCalendarView(
                                minimumDate: widget.minimumDate,
                                maximumDate: widget.maximumDate,
                                initialEndDate: widget.initialEndDate,
                                initialStartDate: widget.initialStartDate,
                                startEndDateChange: (DateTime startDateData,
                                    DateTime endDateData) {
                                  setState(() {
                                    startDate = startDateData;
                                    endDate = endDateData;
                                  });
                                },
                                isChecked: (bool value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16, top: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: CustomColors.container,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        try {
                                          isChecked
                                              ? widget.onApplyClick(
                                                  startDate, endDate)
                                              : widget.onApplyClick(
                                                  startDate,
                                                  DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day + 1));
                                          widget.isChecked(isChecked);
                                          Navigator.pop(context);
                                        } catch (_) {}
                                      },
                                      child: Center(
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: CustomColors
                                                  .primaryTextColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ));
    });
  }
}

class CustomCalendarView extends StatefulWidget {
  const CustomCalendarView(
      {Key key,
      this.initialStartDate,
      this.initialEndDate,
      this.startEndDateChange,
      this.minimumDate,
      this.maximumDate,
      this.isChecked})
      : super(key: key);

  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(bool) isChecked;
  final Function(DateTime, DateTime) startEndDateChange;

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  bool isChecked = false;

  void toggleCheckbox(bool value) {
    if (isChecked == false) {
      setState(() {
        isChecked = true;
        startDate = DateTime.now();
        endDate = DateTime.now().add(const Duration(days: 1));
        try {
          widget.isChecked(true);
        } catch (_) {}
      });
    } else {
      setState(() {
        isChecked = false;
        endDate = null;
        startDate = DateTime.now();
        try {
          widget.isChecked(false);
        } catch (_) {}
      });
    }
  }

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = null;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: isChecked
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'From',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                        color: CustomColors.primaryTextColor
                                            .withOpacity(0.9)),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    startDate != null
                                        ? DateFormat('EEE, dd MMM')
                                            .format(startDate)
                                        : '--/-- ',
                                    style: TextStyle(
                                      color: CustomColors.primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 74,
                              width: 1,
                              color: CustomColors.icon,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'To',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                        color: CustomColors.primaryTextColor
                                            .withOpacity(0.9)),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    endDate != null
                                        ? DateFormat('EEE, dd MMM')
                                            .format(endDate)
                                        : '--/-- ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: CustomColors.primaryTextColor),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 16,
                        width: 1,
                        color: Colors.transparent,
                      ),
                      Text(
                        'On',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color:
                                CustomColors.primaryTextColor.withOpacity(0.9)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        startDate != null
                            ? DateFormat('EEE, dd MMM').format(startDate)
                            : '--/-- ',
                        style: TextStyle(
                          color: CustomColors.primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 16,
                        width: 1,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
          ),
          Divider(
            height: 1,
            color: CustomColors.icon,
          ),
          Row(children: <Widget>[
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                hoverColor: CustomColors.primaryColor,
                focusColor: CustomColors.primaryColor,
                value: isChecked,
                onChanged: (value) {
                  toggleCheckbox(value);
                },
                activeColor: CustomColors.primaryTextColor.withOpacity(0.2),
                checkColor: CustomColors.primaryTextColor,
                tristate: false,
              ),
            ),
            Text(
              'Multiple Days',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: CustomColors.primaryTextColor.withOpacity(0.9)),
            ),
          ]),
          Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
            child: Column(children: <Widget>[
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
                              currentMonthDate = DateTime(currentMonthDate.year,
                                  currentMonthDate.month, 0);
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
                              currentMonthDate = DateTime(currentMonthDate.year,
                                  currentMonthDate.month + 2, 0);
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
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: Row(
              children: getDaysNameUI(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Column(
              children: getDaysNoUI(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(dateList[i]),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.primaryTextColor),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                              left: isStartDateRadius(date) ? 4 : 0,
                              right: isEndDateRadius(date) ? 4 : 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: startDate != null && endDate != null
                                  ? getIsItStartAndEndDate(date) ||
                                          getIsInRange(date)
                                      ? CustomColors.primaryTextColor
                                          .withOpacity(0.3)
                                      : Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: isStartDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                topLeft: isStartDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                topRight: isEndDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                bottomRight: isEndDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          if (currentMonthDate.month == date.month) {
                            if (widget.minimumDate != null &&
                                widget.maximumDate != null) {
                              final DateTime newminimumDate = DateTime(
                                  widget.minimumDate.year,
                                  widget.minimumDate.month,
                                  widget.minimumDate.day - 1);
                              final DateTime newmaximumDate = DateTime(
                                  widget.maximumDate.year,
                                  widget.maximumDate.month,
                                  widget.maximumDate.day + 1);
                              if (date.isAfter(newminimumDate) &&
                                  date.isBefore(newmaximumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.minimumDate != null) {
                              final DateTime newminimumDate = DateTime(
                                  widget.minimumDate.year,
                                  widget.minimumDate.month,
                                  widget.minimumDate.day - 1);
                              if (date.isAfter(newminimumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.maximumDate != null) {
                              final DateTime newmaximumDate = DateTime(
                                  widget.maximumDate.year,
                                  widget.maximumDate.month,
                                  widget.maximumDate.day + 1);
                              if (date.isBefore(newmaximumDate)) {
                                onDateClick(date);
                              }
                            } else {
                              onDateClick(date);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getIsItStartAndEndDate(date)
                                  ? CustomColors.primaryTextColor
                                      .withOpacity(0.3)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32.0)),
                              border: Border.all(
                                color: getIsItStartAndEndDate(date)
                                    ? CustomColors.primaryTextColor
                                        .withOpacity(0.7)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: getIsItStartAndEndDate(date)
                                  ? <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          blurRadius: 4,
                                          offset: const Offset(0, 0)),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                    color: getIsItStartAndEndDate(date)
                                        ? CustomColors.primaryColor
                                            .withOpacity(0.8)
                                        : currentMonthDate.month == date.month
                                            ? CustomColors.primaryTextColor
                                            : CustomColors.primaryTextColor
                                                .withOpacity(0.6),
                                    fontSize:
                                        MediaQuery.of(context).size.width > 360
                                            ? 18
                                            : 16,
                                    fontWeight: getIsItStartAndEndDate(date)
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 9,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                            color: DateTime.now().day == date.day &&
                                    DateTime.now().month == date.month &&
                                    DateTime.now().year == date.year
                                ? getIsInRange(date)
                                    ? CustomColors.primaryTextColor
                                    : CustomColors.primaryColor.withOpacity(0.8)
                                : Colors.transparent,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate) && date.isBefore(endDate)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate.day == date.day &&
        startDate.month == date.month &&
        startDate.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate.day == date.day &&
        endDate.month == date.month &&
        endDate.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate.day == date.day &&
        startDate.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate.day == date.day &&
        endDate.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (isChecked == true) {
      if (startDate == null && endDate != null) {
        if (date.isAfter(endDate)) {
          startDate = endDate;
          endDate = date;
        } else {
          startDate = date;
        }
      } else if (startDate != null && endDate == null) {
        if (date.isBefore(startDate)) {
          endDate = startDate;
          startDate = date;
        } else {
          endDate = date;
        }
      } else if (startDate.day == date.day && startDate.month == date.month) {
        startDate = null;
      } else if (endDate.day == date.day && endDate.month == date.month) {
        endDate = null;
      } else if (startDate != null && endDate != null) {
        if (!endDate.isAfter(startDate)) {
          final DateTime d = startDate;
          startDate = endDate;
          endDate = d;
        }
        if (date.isBefore(startDate)) {
          startDate = date;
        }
        if (date.isAfter(endDate)) {
          endDate = date;
        }
      }
      setState(() {
        try {
          widget.startEndDateChange(startDate, endDate);
        } catch (_) {}
      });
    } else if (isChecked == false) {
      if (startDate == null && endDate == null) {
        startDate = date;
      } else if (startDate != date && endDate == null) {
        startDate = date;
      } else if (startDate.day == date.day && startDate.month == date.month) {
        startDate = date;
      } else if (date.isBefore(startDate)) {
        startDate = date;
      } else if (date.isAfter(startDate)) {
        startDate = date;
      }
      setState(() {
        try {
          widget.startEndDateChange(startDate, endDate);
        } catch (_) {}
      });
    }
  }
}

class HotelAppTheme {
  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1.copyWith(fontFamily: fontName),
      headline2: base.headline2.copyWith(fontFamily: fontName),
      headline3: base.headline3.copyWith(fontFamily: fontName),
      headline4: base.headline4.copyWith(fontFamily: fontName),
      headline5: base.headline5.copyWith(fontFamily: fontName),
      headline6: base.headline6.copyWith(fontFamily: fontName),
      button: base.button.copyWith(fontFamily: fontName),
      caption: base.caption.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1.copyWith(fontFamily: fontName),
      bodyText2: base.bodyText2.copyWith(fontFamily: fontName),
      subtitle1: base.subtitle1.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2.copyWith(fontFamily: fontName),
      overline: base.overline.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme() {
    final Color primaryColor = HexColor('#54D3C2');
    final Color secondaryColor = HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
