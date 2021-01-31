import 'package:flutter/material.dart';

void showDialogWidget({BuildContext context, String title, Widget child}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => Dialog(
            title: title,
            child: child,
          ));
}

class Dialog extends StatefulWidget {
  final String title;
  final Widget child;

  Dialog({this.title, this.child});
  @override
  State createState() => new DialogState();
}

class DialogState extends State<Dialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 100),
      curve: Curves.bounceIn,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Material(
          // shape: RoundedRectangleBorder(
          //  borderRadius: BorderRadius.circular(10.0),
          // ),
          color: Theme.of(context).cardColor,
          // borderRadius: BorderRadius.all(Radius.circular(10)),
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
        ),
      ),
    );
  }
}
