import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';

class Certificates extends StatefulWidget {
  @override
  _CertificatesState createState() => _CertificatesState();
}

class _CertificatesState extends State<Certificates> {
  @override
  void initState() {
    loadPref();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsRepository>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Certificates"),
          elevation: 5,
          centerTitle: true,
        ),
        body: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: model.allRegistrations.length,
            itemBuilder: (BuildContext context, int index) {
              return model.allRegistrations[index].certificateStatus ==
                      "generated"
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
                        //final response = await http.get(
                        //   "${Url.URL}/api/event/get_event_name?eventId=${model.allRegistrations[index].event_id.toString()}");
                        // var resBody = json.decode(response.body.toString());
                        Navigator.pushNamed(context, Routes.pdfView,
                            arguments: {
                              'title': "heh",
                              'link':
                                  "${Url.URL}/api/image?id=${model.allRegistrations[index].certificateUrl.toString()}"
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Chip(
                            label: Text(model
                                .allRegistrations[index].certificateUrl
                                .toString()),
                          ),
                        ],
                      ))
                  : SizedBox.shrink();
            }),
      ),
    );
  }
}
