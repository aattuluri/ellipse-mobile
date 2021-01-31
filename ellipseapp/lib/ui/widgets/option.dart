import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  const Option(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          icon,
          color: Theme.of(context).textTheme.caption.color,
          size: 27,
        ),
        onPressed: onTap);
  }
}
