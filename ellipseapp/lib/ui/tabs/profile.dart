import 'package:auto_size_text/auto_size_text.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{profileTabSettings},
      );
    });
    loadPref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsRepository>(
        builder: (context, userdetails, child) {
      final UserDetails _userdetails =
          context.watch<UserDetailsRepository>().getUserDetails(0);
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 5,
          title: Text(
            "Profile",
            style: TextStyle(color: Theme.of(context).textTheme.caption.color),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            featureDiscoveryOverlay(
              context,
              featureId: profileTabSettings,
              contentLocation: ContentLocation.below,
              tapTarget: const Icon(LineIcons.cog),
              title: 'Settings',
              description: 'Click here to open settings',
              child: IconButton(
                tooltip: 'Settings',
                splashRadius: 20,
                icon: Icon(Icons.settings),
                onPressed: () async {
                  Navigator.pushNamed(context, Routes.settings);
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: userdetails.isLoading || userdetails.loadingFailed
            ? LoaderCircular("Loading Profile")
            : ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: GestureDetector(
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
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.view_profile);
                                    },
                                    child: Container(
                                      height: 55,
                                      width: 55,
                                      child: _userdetails.profilePic
                                              .isNullOrEmpty()
                                          ? NoProfilePic()
                                          : FadeInImage(
                                              image: NetworkImage(
                                                  "${Url.URL}/api/image?id=${_userdetails.profilePic}"),
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
                                        _userdetails.collegeName,
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: EventGridTile(
                        Icons.add, "Post Event", "Add your event", () {
                      Navigator.pushNamed(context, Routes.post_event);
                    }),
                  ),
                  ProfileViewItem(
                      Icons.event_available, 'Registered Events', true, () {
                    Navigator.pushNamed(context, Routes.registered_events);
                  }),
                  ProfileViewItem(Icons.event, 'Posted Events', true, () {
                    Navigator.pushNamed(context, Routes.my_events);
                  }),
                  ProfileViewItem(LineIcons.certificate, 'Certificates', true,
                      () async {
                    Navigator.pushNamed(context, Routes.certificates);
                  }),
                ],
              ),
      );
    });
  }
}

class ProfileViewItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final Function onTap;

  const ProfileViewItem(this.icon, this.text, this.hasNavigation, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: GestureDetector(
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
