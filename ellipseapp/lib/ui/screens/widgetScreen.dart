import 'package:flutter/material.dart';

class WidgetScreen extends StatefulWidget {
  final String title;
  final Widget widget;
  WidgetScreen(this.title, this.widget);
  @override
  _WidgetScreenState createState() => _WidgetScreenState();
}

class _WidgetScreenState extends State<WidgetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.title),
        elevation: 5,
        centerTitle: true,
      ),
      body: widget.widget,
    );
  }
}
