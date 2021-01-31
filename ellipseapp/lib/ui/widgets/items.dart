import 'package:flutter/material.dart';

class IconTab {
  IconTab({
    this.name,
    this.icon,
  });

  final String name;
  final IconData icon;
}

class BottomSheetItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const BottomSheetItem(this.text, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      leading: Icon(
        icon,
      ),
      title: Text(
        text,
        maxLines: 1,
      ),
    );
  }
}

class PopupMenuOption extends StatelessWidget {
  final IconData icon;
  final String text;
  const PopupMenuOption(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          Text(text),
        ],
      ),
    );
  }
}

class ChatDateItem extends StatelessWidget {
  final String text;

  const ChatDateItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.7,
        child: Chip(
          label: Text(text),
        ),
      ),
    );
    /*Row(children: <Widget>[
      Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Divider(),
      )),
      Text(text),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Divider(),
      )),
    ]);*/
  }
}
