import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  const Filters({Key key, this.onApplyClick}) : super(key: key);

  final Function(bool, bool, bool, bool, bool, bool, bool) onApplyClick;

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  double distValue = 50.0;
  bool mycollege = true;
  bool allcolleges = false;
  bool all = true;
  bool online = true;
  bool offline = true;
  bool paid = true;
  bool free = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Theme.of(context).textTheme.caption.color,
              size: 27,
            ),
          ),
          elevation: 4,
          title: Text(
            "Filters",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 1,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 8),
                          child: Text(
                            'Filter by type',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width > 360
                                        ? 18
                                        : 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            onTap: () {
                                              all
                                                  ? setState(() {
                                                      all = false;
                                                      online = false;
                                                      offline = false;
                                                      paid = false;
                                                      free = false;
                                                    })
                                                  : setState(() {
                                                      all = true;
                                                      online = true;
                                                      offline = true;
                                                      paid = true;
                                                      free = true;
                                                    });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    all
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: all
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            onTap: () {
                                              offline
                                                  ? setState(() {
                                                      offline = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      offline = true;
                                                    });
                                              online && offline && free && paid
                                                  ? setState(() {
                                                      all = true;
                                                    })
                                                  : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    offline
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: offline
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Offline",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            onTap: () {
                                              online
                                                  ? setState(() {
                                                      online = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      online = true;
                                                    });
                                              online && offline && free && paid
                                                  ? setState(() {
                                                      all = true;
                                                    })
                                                  : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    online
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: online
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Online",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            onTap: () {
                                              free
                                                  ? setState(() {
                                                      free = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      free = true;
                                                    });
                                              online && offline && free && paid
                                                  ? setState(() {
                                                      all = true;
                                                    })
                                                  : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    free
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: free
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Free",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            onTap: () {
                                              paid
                                                  ? setState(() {
                                                      paid = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      paid = true;
                                                    });
                                              online && offline && free && paid
                                                  ? setState(() {
                                                      all = true;
                                                    })
                                                  : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    paid
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: paid
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color
                                                        : Colors.grey
                                                            .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Paid",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        )
                      ],
                    ),
                    ///////////////////////////////////////////////////////////////////////////////////////
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 8),
                          child: Text(
                            'Filter by college',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width > 360
                                        ? 18
                                        : 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "My College",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: mycollege
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                              : Colors.grey.withOpacity(0.6),
                                          onChanged: (bool value) {
                                            setState(() {
                                              mycollege = value;
                                            });
                                            if (allcolleges == true &&
                                                value == true) {
                                              setState(() {
                                                allcolleges = false;
                                              });
                                            }
                                            if (allcolleges == false &&
                                                value == false) {
                                              setState(() {
                                                allcolleges = true;
                                              });
                                            }
                                          },
                                          value: mycollege,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "All Colleges",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: allcolleges
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                              : Colors.grey.withOpacity(0.6),
                                          onChanged: (bool value) {
                                            setState(() {
                                              allcolleges = value;
                                            });
                                            if (mycollege == true &&
                                                value == true) {
                                              setState(() {
                                                mycollege = false;
                                              });
                                            }
                                            if (mycollege == false &&
                                                value == false) {
                                              setState(() {
                                                mycollege = true;
                                              });
                                            }
                                          },
                                          value: allcolleges,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textTheme
                      .caption
                      .color
                      .withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      try {
                        widget.onApplyClick(all, offline, online, free, paid,
                            mycollege, allcolleges);
                        Navigator.pop(context);
                      } catch (_) {}
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
