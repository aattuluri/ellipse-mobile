import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';

class ConnectionErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: Text('NETWORK ERROR'),
        subtitle: Text('You are not connected to internet'),
        action: Text(
          'Re-Connect',
          style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor),
        ),
        actionCallback: () =>
            Navigator.pushNamed(context, Routes.initialization),
        child: Icon(Icons.signal_cellular_connected_no_internet_4_bar),
      ),
    );
  }
}
