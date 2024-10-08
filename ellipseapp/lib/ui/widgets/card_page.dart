import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import 'index.dart';

class CardPage extends StatelessWidget {
  final Widget body;

  const CardPage(this.body);

  factory CardPage.card({
    Widget leading,
    Widget subtitle,
  }) {
    return CardPage(
      Row(
        children: [
          if (leading != null) leading,
          Expanded(
            child: RowLayout(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 5,
              children: <Widget>[
                subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }

  factory CardPage.header({
    Widget leading,
    Widget subtitle,
    @required String title,
    @required String details,
  }) {
    return CardPage(
      RowLayout(children: <Widget>[
        Row(children: <Widget>[
          if (leading != null) leading,
          Expanded(
            child: RowLayout(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 5,
              children: <Widget>[
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) subtitle,
              ],
            ),
          ),
        ]),
        Separator.divider(),
        TextExpand(details)
      ]),
    );
  }

  factory CardPage.body({
    String title,
    @required Widget body,
  }) {
    return CardPage(
      RowLayout(
        children: <Widget>[
          if (title != null)
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          body
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        /*
        side: BorderSide(
          color: context.watch<ThemeProvider>().theme == Themes.black
              ? Theme.of(context).dividerColor
              : Colors.transparent,
        ),*/
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}
