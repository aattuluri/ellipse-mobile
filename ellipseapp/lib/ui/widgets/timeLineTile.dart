import 'package:flutter/material.dart';

import 'index.dart';

class TimeLineTile extends StatelessWidget {
  final int index;
  final String title;
  final String date;
  final bool isFirst;
  final bool isLast;
  const TimeLineTile(
      {this.index, this.title, this.date, this.isFirst, this.isLast});

  @override
  Widget build(BuildContext context) {
    return (index % 2) == 0
        ? TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.center,
            isFirst: isFirst,
            isLast: isLast,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              padding: EdgeInsets.all(8),
            ),
            startChild: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          )
        : TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.center,
            isFirst: isFirst,
            isLast: isLast,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              padding: EdgeInsets.all(8),
            ),
            endChild: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          );
  }
}
