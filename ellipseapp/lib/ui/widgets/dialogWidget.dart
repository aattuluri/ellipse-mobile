import 'package:flutter/material.dart';

void showDialogWidget({BuildContext context, String title, Widget child}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => DialogWidget(
            title: title,
            child: child,
          ));
}

class DialogWidget extends StatefulWidget {
  final String title;
  final Widget child;

  DialogWidget({this.title, this.child});
  @override
  State createState() => new DialogWidgetState();
}

class DialogWidgetState extends State<DialogWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: widget.child,
      /*Container(
        //height: h * 0.5,
        //width: w * 0.8,
        /*constraints: BoxConstraints(
            minHeight: h * 0.8,
            minWidth: w * 0.8,
            maxHeight: h * 0.8,
            maxWidth: w * 0.8),*/
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(widget.title),
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: Theme.of(context).cardColor,
              centerTitle: true,
            ),
            widget.child
          ],
        ),
      ),*/
    );
  }
}
