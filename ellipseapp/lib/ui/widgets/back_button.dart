import 'package:flutter/material.dart';

class BackButtonMore extends StatelessWidget {
  final String text;
  final Function onTap;

  const BackButtonMore(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.chevron_left),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
