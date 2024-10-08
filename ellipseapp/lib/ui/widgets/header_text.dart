import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(left: 16, top: 16),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'ProductSans',
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
