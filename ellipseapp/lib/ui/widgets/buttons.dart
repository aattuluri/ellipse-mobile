import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const ChipButton(this.text, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(text),
      avatar: Icon(icon),
      shape: StadiumBorder(
          side:
              BorderSide(width: 0.5, color: Theme.of(context).iconTheme.color)),
      onPressed: onTap,
    );
  }
}

class RButton extends StatelessWidget {
  final String text;
  final double padding;
  final Function onTap;

  const RButton(this.text, this.padding, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
            elevation: 5,
            padding: EdgeInsets.all(padding),
            color: Theme.of(context).accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: onTap));
  }
}

class OutlinedTextButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const OutlinedTextButton(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          text,
        ),
        onPressed: onTap);
  }
}

class OutlinedIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const OutlinedIconButton({this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      onPressed: onTap,
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      icon: Icon(
        icon,
        size: 18,
      ),
      label: Text(text),
    );
  }
}
