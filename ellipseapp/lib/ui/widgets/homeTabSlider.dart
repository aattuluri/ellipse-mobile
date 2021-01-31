import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';

class HomeTabSlider extends StatelessWidget {
  final String imgUrl;
  final Function onTap;
  const HomeTabSlider({@required this.imgUrl, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Card(
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            child: FadeInImage(
              width: width * 0.9,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 500),
              image: NetworkImage("${Url.URL}/api/image?id=$imgUrl"),
              placeholder: AssetImage('assets/icons/loading.gif'),
            ),
          ),
        ),
        /* Positioned(
          bottom: 5,
          left: 10,
          right: 10,
          child: Text('tjgglrth'),
        )*/
      ],
    );
    /*Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Card(
        child: Container(
          width: width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold)),
              Text("Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
    */
  }
}
