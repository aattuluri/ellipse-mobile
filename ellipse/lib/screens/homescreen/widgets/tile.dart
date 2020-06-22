import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../components/colors.dart';
import '../../../components/neumorphic_components/widgets.dart';

class ModeTile1 extends StatelessWidget {
  const ModeTile1({
    Key key,
    @required this.name,
    @required this.indicatorColor,
    @required this.minutes,
    this.margin,
    this.pressed,
    this.onTap,
    this.disabled,
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final String name;
  final int minutes;
  final bool pressed;
  final Color indicatorColor;
  final GestureTapCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      width: 50,
      height: 500,
      disabled: disabled,
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
        bottom: 15,
      ),
      pressed: pressed,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Indicator1(
              color: indicatorColor,
            ),
            Expanded(child: Container()),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              '$minutes HOURS',
              style: TextStyle(
                fontSize: 13,
                color: CustomColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator1 extends StatelessWidget {
  const _Indicator1({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      padding: EdgeInsets.all(4.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color.withAlpha(70),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
      ),
    );
  }
}
