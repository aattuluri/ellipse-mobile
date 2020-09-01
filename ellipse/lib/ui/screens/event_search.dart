import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';
import 'package:http/http.dart' as http;
import '../../repositories/index.dart';
import '../../models/index.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({Key key}) : super(key: key);

  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String token = "", id = "", email = "";
  String _searchText = "";
  final TextEditingController _searchQuery = new TextEditingController();
  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    getPref();
    _SearchListState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<EventsRepository>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            elevation: 4,
            title: TextField(
              controller: _searchQuery,
              autofocus: true,
              cursorColor: Theme.of(context).textTheme.caption.color,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _searchQuery.clear();
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.caption.color,
                    size: 27,
                  ),
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontSize: 23),
              ),
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 23.0),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [],
            centerTitle: true,
          ),
          body: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              for (var i = 0; i < model.allEvents?.length; i++)
                if (model.allEvents[i].name
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) ...[
                  EventSearchItem(
                      model.allEvents[i].imageUrl, model.allEvents[i].name, () {
                    Navigator.pushNamed(context, Routes.info_page,
                        arguments: {'index': i});
                  })
                ]
            ],
          ),
        ),
      ),
    );
  }
}
