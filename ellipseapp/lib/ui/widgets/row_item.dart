import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  final String title, description;

  const RowText(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(description),
      ],
    );
    //RowText(title, description);
    /*RowItem.text(
      title,
      description,
      titleStyle: TextStyle(fontSize: 15),
      descriptionStyle: TextStyle(
        fontSize: 15,
        color: Theme.of(context).textTheme.caption.color,
      ),
    );*/
  }
}
