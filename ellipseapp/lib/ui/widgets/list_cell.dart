import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:row_collection/row_collection.dart';

class ListCell extends StatelessWidget {
  final Widget leading, trailing;
  final String title, subtitle;
  final VoidCallback onTap;
  final EdgeInsets contentPadding;

  const ListCell({
    this.leading,
    this.trailing,
    @required this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
  });

  factory ListCell.svg({
    @required BuildContext context,
    @required String image,
    Widget trailing,
    @required String title,
    String subtitle,
    VoidCallback onTap,
  }) {
    return ListCell(
      leading: SvgPicture.asset(
        image,
        colorBlendMode: BlendMode.srcATop,
        width: 40,
        height: 40,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black45
            : null,
      ),
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  factory ListCell.icon({
    @required IconData icon,
    Widget trailing,
    @required String title,
    String subtitle,
    VoidCallback onTap,
  }) {
    return ListCell(
      leading: Icon(icon),
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
          ),
          if (subtitle != null) Separator.spacer(space: 4),
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
            ),
      trailing: trailing,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }
}
