import 'package:flutter/material.dart';

class EventGridTile extends StatelessWidget {
  final String text1, text2;
  final IconData icon;
  final Function onTap;
  const EventGridTile(this.icon, this.text1, this.text2, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.caption.color,
              ),
              borderRadius: BorderRadius.circular(10.0)),
          child: Center(
            child: Row(
              children: [
                Icon(icon,
                    size: 40,
                    color: Theme.of(context)
                        .textTheme
                        .caption
                        .color
                        .withOpacity(0.8)),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text(
                    text1,
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.caption.color,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
