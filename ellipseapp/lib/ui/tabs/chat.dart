import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with TickerProviderStateMixin {
  TabController tabController;
  bool isSearching = false;
  List<Teams> myTeams = [];
  bool teamsLoading = false;
  final List tabs = [
    IconTab(name: "Events", icon: Icons.event),
    IconTab(name: "Teams", icon: Icons.people_outline),
  ];
  loadTeams() async {
    setState(() {
      teamsLoading = true;
    });
    var response =
        await httpGetWithHeaders("${Url.URL}/api/user/get_all_teams");
    if (response.statusCode == 200) {
      myTeams = [
        for (final item in json.decode(response.body)) Teams.fromJson(item)
      ];
      print(myTeams.toString());
    }
    setState(() {
      teamsLoading = false;
    });
  }

  @override
  void initState() {
    loadPref();
    tabController = new TabController(
      length: tabs.length,
      vsync: this,
    );
    loadTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EventsRepository, SearchProvider>(
        builder: (context, model, search, child) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 5,
          title: isSearching
              ? SearchAppBar(
                  hintText: 'Search',
                  onChanged: (value) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .changeSearchText(value);
                  },
                )
              : Text(
                  "My Chats",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color),
                ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: tabs.map((tab) {
              return Tab(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 18,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        tab.name,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: isSearching
              ? [
                  TextButton(
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .reset();
                        setState(() {
                          isSearching = false;
                        });
                      },
                      child: Text('Cancel'))
                ]
              : [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
                ],
        ),
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              ///////Tab1///////
              model.isLoading
                  ? LoaderCircular("Loading Events")
                  : ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < model.allEvents.length; i++) ...[
                          if ((model.allEvents[i].registered ||
                                  model.allEvents[i].regMode == 'link') &&
                              (!isSearching ||
                                  model.allEvents[i].name
                                      .toLowerCase()
                                      .contains(search.searchText
                                          .toLowerCase()
                                          .trim()))) ...[
                            ListTile(
                              title: Text(
                                model.allEvents[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                                maxLines: 2,
                              ),
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                child: FadeInImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      "${Url.URL}/api/image?id=${model.allEvents[i].imageUrl}"),
                                  placeholder:
                                      AssetImage('assets/icons/loading.gif'),
                                ),
                              ),
                              trailing:
                                  Icon(Icons.keyboard_arrow_right_outlined),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.widgetScreen,
                                  arguments: {
                                    'title': model.allEvents[i].name,
                                    'widget': ChatScreen(
                                        type: 'eventChat',
                                        id: model.allEvents[i].eventId)
                                  },
                                );
                              },
                            ),
                          ]
                        ]
                      ],
                    ),
              ///////Tab2///////
              teamsLoading
                  ? LoaderCircular("Loading")
                  : ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < myTeams.length; i++) ...[
                          if (!isSearching ||
                              myTeams[i].name.toLowerCase().contains(
                                  search.searchText.toLowerCase().trim())) ...[
                            ListTile(
                              title: Text(
                                myTeams[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                                maxLines: 2,
                              ),
                              subtitle: Text(
                                  myTeams[i].members.length.toString() +
                                      ' members in team'),
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).accentColor,
                                ),
                                child: Center(
                                  child: Text(
                                    myTeams[i]
                                        .name
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: 20,
                                      fontFamily: 'ProductSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              trailing:
                                  Icon(Icons.keyboard_arrow_right_outlined),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.widgetScreen,
                                  arguments: {
                                    'title': myTeams[i].name,
                                    'widget': ChatScreen(
                                        type: 'teamChat', id: myTeams[i].teamId)
                                  },
                                );
                              },
                            ),
                          ],
                        ]
                      ],
                    ),
              ///////Tab3///////
              // Container(),
            ]),
      );
    });
  }
}
