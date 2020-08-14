import 'package:flutter/material.dart';

class EventGridTile extends StatelessWidget {
  final String text1, text2;
  final IconData icon;
  const EventGridTile(this.icon, this.text1, this.text2);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).textTheme.caption.color,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon,
                  size: 43,
                  color: Theme.of(context)
                      .textTheme
                      .caption
                      .color
                      .withOpacity(0.8)),
              SizedBox(height: 15),
              Text(
                text1,
                style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.caption.color,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8),
              Text(
                text2,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.caption.color,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(10),
        height: 150.0);
  }
}
