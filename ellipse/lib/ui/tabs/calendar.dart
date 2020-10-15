import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Error"),
          action: SnackBarAction(
            label: "Error",
            onPressed: () => _onRefresh(context, repository),
          ),
        ),
      );
    }
    completer.complete();
  });

  return completer.future;
}

class CalendarTab extends StatefulWidget {
  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  ScrollController _scrollControllerDay, _scrollControllerMonth;
  List<DateTime> daysList = <DateTime>[];
  List<DateTime> monthsList = <DateTime>[];
  List<int> timeList = <int>[];
  DateTime date = DateTime.now();
  DateTime currentDate;
  DateTime currentMonth;
  DateTime currentYear;
  DateTime selectedday;
  DateTime selectedmonth;
  String viewby;
  String _selectedview;
  final List<String> _dropdownValues = ["Day", "Month", "Year"];
  void setListOfDays(DateTime Date) {
    daysList.clear();
    final DateTime newDate1 = DateTime(Date.year, Date.month, 0);
    for (int i = 0; i < 31; i++) {
      daysList.add(newDate1.add(Duration(days: i + 1)));
    }
  }

  void setListOfMonths(DateTime Date) {
    monthsList.clear();
    final DateTime newDate2 = DateTime(Date.year, 0, 0);
    for (int i = 3; i < 15; i++) {
      monthsList.add(DateTime(newDate2.year, newDate2.month + i, 0));
    }
  }

  @override
  void initState() {
    setState(() {
      currentDate = DateTime.now();
      currentMonth = DateTime.now();
      currentYear = DateTime.now();
      _selectedview = "Month";
    });
    setState(() {
      selectedmonth = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      selectedday = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    });
    setListOfDays(currentDate);
    setListOfMonths(currentDate);
    _scrollControllerDay = ScrollController();
    _scrollControllerMonth = ScrollController();

    var cmonth = DateFormat('MMM').format(DateTime(DateTime.now().month));
    print(cmonth);
    // double _position =  index * (_width + 2 * _horizontalPadding)
    //   + (_selectedWidth+_horizontalPadding);
    if (_scrollControllerMonth.hasClients) {
      _scrollControllerMonth.animateTo(100.0,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 5,
              title: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Calendar',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.autorenew,
                      color: Theme.of(context).textTheme.caption.color,
                      size: 27,
                    ),
                    onPressed: () => _onRefresh(context, model)),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 0, top: 7, bottom: 7),
                  child: OutlineButton(
                    highlightedBorderColor:
                        Theme.of(context).textTheme.caption.color,
                    color: Theme.of(context).textTheme.caption.color,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _dropdownValues
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (String value) {
                          setState(() => _selectedview = value);
                        },
                        isExpanded: false,
                        value: _selectedview,
                      ),
                    ),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ],
              centerTitle: true,
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.post_event);
                },
                child: new Icon(Icons.add, size: 40, color: Colors.black),
              ),
            ),
            body: _selectedview == "Day"
                ? Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  onTap: () {
                                    setState(() {
                                      currentDate = DateTime(currentDate.year,
                                          currentDate.month, 0);
                                      setListOfDays(currentDate);
                                      print(currentDate);
                                    });
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                DateFormat('MMMM, yyyy').format(currentDate),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  onTap: () {
                                    setState(() {
                                      currentDate = DateTime(currentDate.year,
                                          currentDate.month + 2, 0);
                                      setListOfDays(currentDate);
                                      print(currentDate);
                                    });
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60.0,
                        child:
                            //////////////////////////////////////////////////////////////////
                            ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollControllerDay,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          itemCount: daysList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return currentDate.month != daysList[index].month
                                ? null
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedday = daysList[index];
                                        print(selectedday);
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            DateFormat('EEE')
                                                .format(daysList[index]),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: daysList[index] ==
                                                        selectedday
                                                    ? Color(0xFFE46472)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            DateFormat('dd')
                                                .format(daysList[index]),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: daysList[index] ==
                                                        selectedday
                                                    ? Color(0xFFE46472)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                        ///////////////////////////////////////////////////////////////
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 1,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "Events on " +
                            DateFormat('EEE-MMMM dd, yyyy').format(selectedday),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 1,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: model.isLoading || model.loadingFailed
                            ? _loadingIndicator
                            : ListView(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                  for (var i = 0;
                                      i < model.allEvents?.length;
                                      i++)
                                    if (model.allEvents[i].finish_time
                                            .isAfter(DateTime.now()) &&
                                        model.allEvents[i].start_time.day ==
                                            selectedday.day &&
                                        model.allEvents[i].start_time.month ==
                                            selectedday.month &&
                                        model.allEvents[i].start_time.year ==
                                            selectedday.year) ...[
                                      EventTileGeneral(true, i, "info_page")
                                      //EventTileCalendar(true, i, "info_page")
                                    ]
                                ],
                              ),
                      ),
                    ],
                  )
                : _selectedview == "Month"
                    ? Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      onTap: () {
                                        setState(() {
                                          currentMonth =
                                              DateTime(currentMonth.year, 0, 0);
                                          setListOfMonths(currentMonth);

                                          print(currentMonth);
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    DateFormat('yyyy').format(currentMonth),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      onTap: () {
                                        setState(() {
                                          currentMonth = DateTime(
                                              currentMonth.year + 2, 0, 0);
                                          setListOfMonths(currentMonth);

                                          print(currentMonth);
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 35.0,
                            child:
                                /////////////////////////////////////////////////////////////////////
                                ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              scrollDirection: Axis.horizontal,
                              controller: _scrollControllerMonth,
                              itemCount: monthsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedmonth = monthsList[index];
                                      print(selectedmonth);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 5, right: 5),
                                    child: Container(
                                      width: 35,
                                      child: Text(
                                        DateFormat('MMM')
                                            .format(monthsList[index]),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: monthsList[index].month ==
                                                        selectedmonth.month &&
                                                    monthsList[index].year ==
                                                        selectedmonth.year
                                                ? Color(0xFFE46472)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            ///////////////////////////////////////////////////////////////
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 1,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            "Events in " +
                                DateFormat('MMMM,yyyy').format(selectedmonth),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 1,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: model.isLoading || model.loadingFailed
                                ? _loadingIndicator
                                : ListView(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (var i = 0;
                                          i < model.allEvents?.length;
                                          i++)
                                        if (model.allEvents[i].finish_time
                                                .isAfter(DateTime.now()) &&
                                            model.allEvents[i].start_time
                                                    .month ==
                                                selectedmonth.month &&
                                            model.allEvents[i].start_time
                                                    .year ==
                                                selectedmonth.year) ...[
                                          EventTileGeneral(true, i, "info_page")
                                          //EventTileCalendar(true, i, "info_page")
                                        ]
                                    ],
                                  ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      onTap: () {
                                        setState(() {
                                          currentYear =
                                              DateTime(currentYear.year, 0, 0);
                                          print(currentYear);
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    DateFormat('yyyy').format(currentYear),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      onTap: () {
                                        setState(() {
                                          currentYear = DateTime(
                                              currentYear.year + 2, 0, 0);
                                          print(currentYear);
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 1,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            "Events in " +
                                DateFormat('yyyy').format(currentYear),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color:
                                    Theme.of(context).textTheme.caption.color),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 1,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: model.isLoading || model.loadingFailed
                                ? _loadingIndicator
                                : ListView(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (var i = 0;
                                          i < model.allEvents?.length;
                                          i++)
                                        if (model.allEvents[i].finish_time
                                                .isAfter(DateTime.now()) &&
                                            model.allEvents[i].start_time
                                                    .year ==
                                                currentYear.year) ...[
                                          EventTileGeneral(true, i, "info_page")
                                          //EventTileCalendar(true, i, "info_page")
                                        ]
                                    ],
                                  ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
