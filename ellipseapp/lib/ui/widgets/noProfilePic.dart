import 'package:flutter/material.dart';

class NoProfilePic extends StatelessWidget {
  const NoProfilePic();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person,
      size: 25,
    );
  }
}

class NoProfilePicChat extends StatelessWidget {
  const NoProfilePicChat();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).textTheme.caption.color,
      ),
      child: Center(
        child: Icon(Icons.person,
            size: 25, color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}
