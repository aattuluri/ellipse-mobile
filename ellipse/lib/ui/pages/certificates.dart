import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';

class Certificates extends StatefulWidget {
  @override
  _CertificatesState createState() => _CertificatesState();
}

class _CertificatesState extends State<Certificates> {
  List<dynamic> registered = [];
  bool isloading = false;
  loadRegEvents() async {
    context.read<EventsRepository>().refreshData();
    setState(() {
      isloading = true;
    });
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $prefToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };
    var response = await http.get(
        "${Url.URL}/api/user/registeredEvents?id=$prefId",
        headers: headers);
    print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        registered = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
    print(registered);
  }

  @override
  void initState() {
    loadPref();
    loadRegEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Certificates"),
        elevation: 5,
        centerTitle: true,
      ),
      body: isloading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    Text(
                      "Fetching Details....",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: registered.length,
              itemBuilder: (BuildContext context, int index) {
                print(registered[index]['certificate_url'].toString());
                return registered[index]['certificate_status'] == "generated"
                    //&& !registered[index]['certificate_url'].isNullOrEmpty()
                    ? InkWell(
                        onTap: () async {
                          /*
                          final _eventIndex = context
                              .read<EventsRepository>()
                              .getEventIndex(
                                  registered[index]['event_id'].toString());
                          final Events _event = context
                              .watch<EventsRepository>()
                              .getEvents(_eventIndex);
                          */
                          final response = await http.get(
                              "${Url.URL}/api/event/get_event_name?eventId=${registered[index]['event_id'].toString()}");
                          var resBody = json.decode(response.body.toString());
                          Navigator.pushNamed(context, Routes.pdfView,
                              arguments: {
                                'title': resBody.toString(),
                                'link':
                                    "${Url.URL}/api/image?id=${registered[index]['certificate_url'].toString()}"
                              });
                        },
                        child: Chip(
                          label: Text(
                              registered[index]['certificate_url'].toString()),
                        ))
                    : SizedBox.shrink();
              }),
    );
  }
}
