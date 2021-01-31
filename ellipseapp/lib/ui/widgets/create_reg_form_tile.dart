import 'package:flutter/material.dart';

class DynamicFormTile extends StatelessWidget {
  final String text1, text2;
  final IconData icon;
  final Function onTap;
  const DynamicFormTile(this.icon, this.text1, this.text2, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 20),
                  child: Icon(icon, size: 33),
                ),
                Text(
                  text1,
                  style: TextStyle(fontSize: 20.0),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
