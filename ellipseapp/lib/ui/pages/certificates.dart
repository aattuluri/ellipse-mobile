import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
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
          actions: [
            IconButton(
                icon: Icon(
                  LineIcons.refresh,
                  color: Theme.of(context).textTheme.caption.color,
                  size: 27,
                ),
                onPressed: () {
                  context.read<EventsRepository>().refreshData();
                }),
          ],
          centerTitle: true,
        ),
        body: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: model.allRegistrations.length,
            itemBuilder: (BuildContext context, int index) {
              final eventIndex = context
                  .read<EventsRepository>()
                  .getEventIndex(model.allRegistrations[index].event_id);
              final Events _event =
                  context.watch<EventsRepository>().getEvent(eventIndex);
              return CertificateTile(
                  _event, model.allRegistrations[index], () {});
            }),
      ),
    );
  }
}

class CertificateTile extends StatelessWidget {
  final Events _event;
  final Registrations _reg;
  final Function onTap;
  const CertificateTile(this._event, this._reg, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _event.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        _reg.certificateStatus == "generated"
                            ? RaisedButton.icon(
                                onPressed: () {
                                  "${Url.URL}/api/user/certificate?id=${_reg.certificateUrl.toString()}"
                                      .launchUrl;
/*
                      Navigator.pushNamed(context, Routes.pdfView,
                          arguments: {
                            'title': "heh",
                            'link':
                                "${Url.URL}/api/image?id=${model.allRegistrations[index].certificateUrl.toString()}"
                          });*/
                                },
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                icon: Icon(
                                  LineIcons.download,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                label: Text(
                                  "Download",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              )
                            : Chip(label: Text("Not Generated"))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
