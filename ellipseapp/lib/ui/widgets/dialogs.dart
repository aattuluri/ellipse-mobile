import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ContextExtension on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get paddingTop => MediaQuery.of(this).padding.top;
}

Future alertDialog(BuildContext context, String title, String content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future flutterToast(
    BuildContext context, String msg, int time, ToastGravity gravity) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      textColor: Theme.of(context).scaffoldBackgroundColor,
      timeInSecForIosWeb: time,
      backgroundColor: Theme.of(context).textTheme.caption.color);
}

Future generalDialog(BuildContext context,
        {Widget title, Widget content, List<Widget> actions}) async =>
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animaiton, secondaryAnimation) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: context.brightness == Brightness.light
              ? Color.fromRGBO(113, 113, 113, 1)
              : Color.fromRGBO(15, 15, 15, 1),
        ),
        child: AlertDialog(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.all(20),
            title: Center(child: title),
            content: content,
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            actions: actions),
      ),
    );

Future generalSheet(BuildContext context, {Widget child, String title}) async =>
    await showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      elevation: 2,
      context: context,
      builder: (context) {
        final statusHeight = MediaQuery.of(context).padding.top;
        return SafeArea(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: context.height - statusHeight - 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 25,
                  margin: EdgeInsets.only(top: 10.0, bottom: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.3)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 50, right: 50, top: 6.0, bottom: 15),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Flexible(child: SingleChildScrollView(child: child)),
              ],
            ),
          ),
        );
      },
    );

class RoundDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const RoundDialog({
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'ProductSans',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      children: children,
    );
  }
}

Future messageDialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 2.5,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new AlertDialog(
          content: Text(text),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    },
  );
}
