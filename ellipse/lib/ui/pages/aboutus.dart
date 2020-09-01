import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/index.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "Our Team",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(child: Particles(3)),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AboutUsItem(
                        "",
                        "Gunasekhar A",
                        "Developer",
                        "(Flutter Developer,Web Developer)",
                        "gunasekhar158@gmail.com",
                        "VIT University,Vellore",
                        () {}),
                    AboutUsItem(
                        "",
                        "Lalith Sagar P",
                        "Developer",
                        "(IOS Developer,Web Developer)",
                        "lalithpunepalli@gmail.com",
                        "VIT University,Vellore",
                        () {}),
                    AboutUsItem(
                        "",
                        "Anil Kumar A",
                        "Financer",
                        "(-------------------------------------------)",
                        "anilcs0405@gmail.com",
                        "--------------",
                        () {}),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsItem extends StatelessWidget {
  final String image;
  final String name;
  final String type;
  final String skills;
  final String email;
  final String address;
  final Function onTap;
  const AboutUsItem(this.image, this.name, this.type, this.skills, this.email,
      this.address, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: <Widget>[
              Text(
                type,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9D9D9),
                    backgroundImage: NetworkImage(image),
                    radius: 36.0,
                  ),
                  */
                  RichText(
                    text: TextSpan(
                      text: name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\n' + skills,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: '\n' + address,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
