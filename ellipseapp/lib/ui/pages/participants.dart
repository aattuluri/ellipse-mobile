import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';

class Participants extends StatefulWidget {
  final String eventId;
  Participants(this.eventId);
  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants>
    with TickerProviderStateMixin {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  bool expanded = false;
  bool isloading = false;
  List<List<String>> keys = [];
  List<List<dynamic>> values = [];
  List<dynamic> participants = [];
  List<List<FilledData>> filledData = [];
  loadRegisteredEvents() async {
    final Events _event =
        context.read<EventsRepository>().event(widget.eventId);
    setState(() {
      isloading = true;
    });
    String eventId = widget.eventId.trim().toString();
    var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/registeredEvents?id=$eventId");
    if (response.statusCode == 200) {
      setState(() {
        participants = json.decode(response.body);
      });
      List<Registrations> registrations = (json.decode(response.body) as List)
          .map((data) => Registrations.fromJson(data))
          .toList();
      for (var i = 0; i < registrations.length; i++) {
        setState(() {
          filledData
              .add(registrations[i].parseFilledData(_event.parseRegFields()));
        });
      }
      print('filledData');
      print(filledData);
      for (var i = 0; i < participants.length; i++) {
        Map<String, dynamic> data = participants[i]['data'];
        setState(() {
          keys.add(data.keys.toList());
          values.add(data.values.toList());
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    loadPref();
    loadRegisteredEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "Export",
        onPressed: () async {
          generalSheet(
            context,
            title: "Export As",
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BottomSheetItem("Excel Sheet", LineIcons.file_excel_o,
                    () async {
                  if (participants.isNotEmpty) {
                    try {
                      var excel = Excel.createExcel();
                      Map<String, dynamic> d = participants[0]['data'];
                      List<String> keys = d.keys.toList();
                      excel.appendRow('Sheet1', keys);
                      for (var i = 0; i < participants.length; i++) {
                        Map<String, dynamic> data = participants[i]['data'];
                        List<dynamic> values = data.values.toList();
                        excel.appendRow('Sheet1', values);
                      }
                      excel.encode().then((onValue) async {
                        final Directory directory = await pathProvider
                            .getApplicationDocumentsDirectory();
                        final String path = directory.path;
                        final File file = File('$path/participants.xlsx');
                        await file.writeAsBytes(onValue, flush: true);
                        await OpenFile.open('$path/participants.xlsx');
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    flutterToast(context, 'No participants for your event', 2,
                        ToastGravity.BOTTOM);
                  }
                }),
                Divider(height: 1),
                BottomSheetItem("CSV File", Icons.insert_drive_file_outlined,
                    () async {
                  List<List<String>> csvData = [];
                  Map<String, dynamic> d = participants[0]['data'];
                  List<String> keys = d.keys.toList();
                  csvData.add(keys);
                  for (var i = 0; i < participants.length; i++) {
                    Map<String, dynamic> data = participants[i]['data'];
                    List<String> val = [];
                    List<dynamic> values = data.values.toList();
                    for (var i = 0; i < values.length; i++) {
                      val.add(values[i].toString());
                    }
                    csvData.add(val);
                  }
                  String csv = ListToCsvConverter().convert(csvData);
                  final Directory directory =
                      await pathProvider.getApplicationDocumentsDirectory();
                  final String path = directory.path;
                  final File file = File('$path/participants.csv');
                  await file.writeAsString(csv, flush: true);
                  await OpenFile.open('$path/participants.csv');
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        },
        child: Icon(Icons.input),
      ),
      body: isloading
          ? LoaderCircular("Loading")
          : participants.isEmpty
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: EmptyData(
                      'No Participants\nRegistered', "", LineIcons.users),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Scrollbar(
                    controller: _scrollController1,
                    isAlwaysShown: true,
                    thickness: 5,
                    radius: Radius.circular(50),
                    child: SingleChildScrollView(
                      controller: _scrollController1,
                      scrollDirection: Axis.horizontal,
                      child: Scrollbar(
                        controller: _scrollController2,
                        isAlwaysShown: true,
                        thickness: 5,
                        radius: Radius.circular(50),
                        child: SingleChildScrollView(
                          controller: _scrollController2,
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 20.0,
                            horizontalMargin: 15.0,
                            columns: <DataColumn>[
                              for (var i = 0; i < filledData[0].length; i++) ...[
                                DataColumn(
                                  label: Text(
                                    filledData[0][i].key.toString(),
                                    maxLines: 2,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                            rows: <DataRow>[
                              for (var i = 0; i < filledData.length; i++) ...[
                                DataRow(
                                  cells: <DataCell>[
                                    for (var j = 0;
                                    j < filledData[i].length;
                                    j++) ...[
                                      if(filledData[i][j].field=='file' && !filledData[i][j].value.toString().isNullOrEmpty() )...[
                                        DataCell(
                                          RButton("open file",10,(){
                                           // print(filledData[i][j].value);
                                            "${Url.URL}/api/event/registration/get_file?id=${filledData[i][j].value.toString()}".launchUrl;
                                          }),
                                        ),
                                      ]
                                      else...[ DataCell(
                                        Text(
                                          filledData[i][j].key=='Email'?"****************@gmail.com":filledData[i][j].value.toString() ?? " ",
                                          maxLines: 2,
                                        ),
                                      ),]

                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
