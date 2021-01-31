import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';

class Filters extends StatefulWidget {
  const Filters({Key key, this.onApplyClick}) : super(key: key);
  final Function(List) onApplyClick;

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> filters = [];
  bool all = true;
  bool online = true;
  bool offline = true;
  bool paid = true;
  bool free = true;
  @override
  void initState() {
    loadPref();
    setState(() {
      filters = Provider.of<DataProvider>(context, listen: false).filters;
    });
    setState(() {
      all = filters.contains("Offline") &&
          filters.contains("Online") &&
          filters.contains("Free") &&
          filters.contains("Paid");
      online = filters.contains("Online");
      offline = filters.contains("Offline");
      paid = filters.contains("Paid");
      free = filters.contains("Free");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).textTheme.caption.color,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
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
                            'Filters',
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
                                                      filters.remove('Offline');
                                                      filters.remove('Online');
                                                      filters.remove('Free');
                                                      filters.remove('Paid');
                                                      filters = filters
                                                          .toSet()
                                                          .toList();
                                                    })
                                                  : setState(() {
                                                      all = true;
                                                      online = true;
                                                      offline = true;
                                                      paid = true;
                                                      free = true;
                                                      filters.add('Offline');
                                                      filters.add('Online');
                                                      filters.add('Free');
                                                      filters.add('Paid');
                                                      filters = filters
                                                          .toSet()
                                                          .toList();
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
                                                      this.setState(() =>
                                                          filters.remove(
                                                              "Offline"));

                                                      offline = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      this.setState(() =>
                                                          filters
                                                              .add("Offline"));
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
                                                      this.setState(() =>
                                                          filters.remove(
                                                              "Online"));
                                                      online = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      this.setState(() =>
                                                          filters
                                                              .add("Online"));
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
                                                      this.setState(() =>
                                                          filters
                                                              .remove("Free"));
                                                      free = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      this.setState(() =>
                                                          filters.add("Free"));
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
                                                      this.setState(() =>
                                                          filters
                                                              .remove("Paid"));
                                                      paid = false;
                                                      all = false;
                                                    })
                                                  : setState(() {
                                                      this.setState(() =>
                                                          filters.add("Paid"));
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
                                            prefCollegeName,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color),
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          activeColor: filters
                                                  .contains(prefCollegeId)
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                              : Colors.grey.withOpacity(0.6),
                                          onChanged: (bool value) {
                                            setState(() {
                                              if (!filters
                                                  .contains(prefCollegeId)) {
                                                filters.add(prefCollegeId);
                                              }
                                            });
                                            /*
                                            setState(() {
                                              myCollege = value;
                                            });
                                            if (allColleges == true &&
                                                value == true) {
                                              setState(() {
                                                filters.add(prefCollegeId);
                                                allColleges = false;
                                              });
                                            }
                                            if (allColleges == false &&
                                                value == false) {
                                              setState(() {
                                                filters.remove(prefCollegeId);
                                                allColleges = true;
                                              });
                                            }
                                            */
                                          },
                                          value:
                                              filters.contains(prefCollegeId),
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
                                          activeColor: !filters
                                                  .contains(prefCollegeId)
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color
                                              : Colors.grey.withOpacity(0.6),
                                          onChanged: (bool value) {
                                            setState(() {
                                              if (filters
                                                  .contains(prefCollegeId)) {
                                                filters.remove(prefCollegeId);
                                              }
                                            });
                                            /*
                                            setState(() {
                                              allColleges = value;
                                            });
                                            if (myCollege == true &&
                                                value == true) {
                                              setState(() {
                                                filters.remove(prefCollegeId);
                                                myCollege = false;
                                              });
                                            }
                                            if (myCollege == false &&
                                                value == false) {
                                              setState(() {
                                                filters.add(prefCollegeId);
                                                myCollege = true;
                                              });
                                            }*/
                                          },
                                          value:
                                              !filters.contains(prefCollegeId),
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
                        widget.onApplyClick(filters);
                        Navigator.of(context).pop(true);
                      } catch (e) {
                        print(e);
                      }
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
