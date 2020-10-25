import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final Icon icon;
  final int itemCount;
  final bool hideZero;
  final Color badgeColor;
  final Color itemColor;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final int maxCount;

  const IconBadge({
    Key key,
    @required this.icon,
    this.itemCount = 0,
    this.hideZero = false,
    this.badgeColor = Colors.red,
    this.itemColor = Colors.white,
    this.maxCount = 99,
    this.top = 0.0,
    this.right = 4.0,
    this.bottom,
    this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemCount == 0 && hideZero
        ? Container(
            width: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    icon,
                  ],
                ),
              ],
            ),
          )
        : Container(
            width: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    icon,
                  ],
                ),
                Positioned(
                  top: top,
                  right: right,
                  bottom: bottom,
                  left: left,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: badgeColor,
                    ),
                    alignment: Alignment.center,
                    child: itemCount > maxCount
                        ? Text(
                            '$maxCount+',
                            style: TextStyle(
                              color: itemColor,
                              fontSize: 12.0,
                            ),
                          )
                        : Text(
                            '$itemCount',
                            style: TextStyle(
                              color: itemColor,
                              fontSize: 12.0,
                            ),
                          ),
                  ),
                )
              ],
            ),
          );
  }
}
