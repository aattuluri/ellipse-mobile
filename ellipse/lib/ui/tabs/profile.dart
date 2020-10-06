import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    loadPref();
    context.read<UserDetailsRepository>().refreshData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsRepository>(builder: (context, model, child) {
      final UserDetails _userdetails =
          context.watch<UserDetailsRepository>().getUserDetails(0);
      return SimplePage2(
        body: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
              child: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
            ),
            AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  final Animation<double> animation =
                      Tween<double>(begin: 0.1, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController.forward();
                  return FadeTransition(
                    opacity: animation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.view_profile);
                        },
                        child: Card(
                          color: Theme.of(context).cardColor.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 10.0),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(540),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routes.view_profile);
                                      },
                                      child: Container(
                                        height: 55,
                                        width: 55,
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              "${Url.URL}/api/image?id=${_userdetails.profile_pic}"),
                                          placeholder: AssetImage(
                                              'assets/icons/loading.gif'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AutoSizeText(
                                      _userdetails.name,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    AutoSizeText(
                                      _userdetails.email,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_balance,
                                          size: 20.0,
                                        ),
                                        SizedBox(width: 4.0),
                                        AutoSizeText(
                                          _userdetails.college_name,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            SettingsMainViewItem(Icons.edit, 'Edit Profile', true, () {
              Navigator.pushNamed(context, Routes.edit_profile);
            }),
            SettingsMainViewItem(
                Icons.event_available, 'Registered Events', true, () {
              Navigator.pushNamed(context, Routes.registered_events);
            }),
            SettingsMainViewItem(Icons.event, 'Posted Events', true, () {
              Navigator.pushNamed(context, Routes.my_events);
            }),
          ],
        ),
      );
    });
  }
}

class SettingsMainViewItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final Function onTap;

  const SettingsMainViewItem(
      this.icon, this.text, this.hasNavigation, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).cardColor.withOpacity(0.9),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                this.icon,
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Spacer(),
              if (this.hasNavigation)
                Icon(
                  Icons.chevron_right,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
