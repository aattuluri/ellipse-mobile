import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../widgets/index.dart';

class PostedEvents extends StatefulWidget {
  @override
  _PostedEventsState createState() => _PostedEventsState();
}

class _PostedEventsState extends State<PostedEvents> {
  bool isSearching = false;
  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EventsRepository, SearchProvider>(
        builder: (context, event, search, child) {
      return SafeArea(
        child: Scaffold(
          appBar: isSearching
              ? AppBar(
                  title: SearchAppBar(
                    hintText: 'Search',
                    onChanged: (value) {
                      Provider.of<SearchProvider>(context, listen: false)
                          .changeSearchText(value);
                    },
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Provider.of<SearchProvider>(context, listen: false)
                              .reset();
                          setState(() {
                            isSearching = false;
                          });
                        },
                        child: Text('Cancel'))
                  ],
                )
              : AppBar(
                  iconTheme: Theme.of(context).iconTheme,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 4,
                  title: Text(
                    "Posted Events",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(
                          LineIcons.refresh,
                        ),
                        onPressed: () {
                          context.read<EventsRepository>().init();
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                    )
                  ],
                  centerTitle: true,
                ),
          body: event.isLoading
              ? LoaderCircular("Loading Events")
              : event.postedEvents.isEmpty
                  ? EmptyData(
                      'No Posted Events',
                      "You have not posted any event",
                      Icons.event_busy_outlined)
                  : ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < event.postedEvents.length; i++) ...[
                          if (!isSearching ||
                              event.postedEvents[i].name.toLowerCase().contains(
                                  search.searchText.toLowerCase().trim())) ...[
                            EventTileAdmin(event.postedEvents[i])
                          ],
                        ],
                      ],
                    ),
        ),
      );
    });
  }
}
