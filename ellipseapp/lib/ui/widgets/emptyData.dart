import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;

  const EmptyData(this.title, this.subtitle, this.icon);

  @override
  Widget build(BuildContext context) {
    return BigTip(
      title: Text(title),
      subtitle: Text(subtitle),
      action: Container(),
      actionCallback: () => Navigator.pop(context),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor,
          //Theme.of(context).accentColor,
        ),
        child: Center(
          child: Icon(icon,
              size: 45, color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
    );
  }
}
