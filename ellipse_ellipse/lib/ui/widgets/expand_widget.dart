import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';

/// Wrapper of the [ExpandText] widget.
class TextExpand extends StatelessWidget {
  final String text;
  final int lines;

  const TextExpand(this.text, {this.lines = 4});

  factory TextExpand.small(String text) {
    return TextExpand(text, lines: 6);
  }

  @override
  Widget build(BuildContext context) {
    return ExpandText(
      text,
      maxLines: lines,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Theme.of(context).textTheme.caption.color,
        fontSize: 15,
      ),
    );
  }
}

/// Wrapper of the [ShowChild] widget.
class ExpandList extends StatelessWidget {
  final Widget child;

  const ExpandList(this.child);

  @override
  Widget build(BuildContext context) {
    return ShowChild(
      indicator: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "SHOW ALL PAYLOAD",
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'ProductSans',
            color: Theme.of(context).textTheme.caption.color,
          ),
        ),
      ),
      child: child,
    );
  }
}
