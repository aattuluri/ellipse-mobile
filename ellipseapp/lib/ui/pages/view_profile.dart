import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key key}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return Consumer<UserDetailsRepository>(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            elevation: 4,
            title: Text(
              "Profile",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: Theme.of(context).textTheme.caption.color),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(540),
                          child: GestureDetector(
                            onTap: _userdetails.profilePic.isNullOrEmpty()
                                ? () {}
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.7),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _userdetails.profilePic
                                                        .isNullOrEmpty()
                                                    ? NoProfilePic()
                                                    : FadeInImage(
                                                        image: NetworkImage(
                                                            "${Url.URL}/api/image?id=${_userdetails.profilePic}"),
                                                        placeholder: AssetImage(
                                                            'assets/icons/loading.gif'),
                                                      ),
                                                SizedBox(height: 10),
                                                FloatingActionButton(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  tooltip: 'Increment',
                                                  child: Icon(Icons.close,
                                                      size: 30),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                            child: Container(
                              height: 60,
                              width: 60,
                              child: _userdetails.profilePic.isNullOrEmpty()
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
                      SizedBox(width: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _userdetails.name,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          Text(_userdetails.email),
                          SizedBox(height: 10.0),
                          OutlinedIconButton(
                            text: "Edit Profile",
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.pushNamed(context, Routes.edit_profile);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    elevation: 7.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ProfileListTile("Username", _userdetails.username,
                              Icons.person_pin),
                          ProfileListTile(
                              "Name", _userdetails.name, Icons.person_outline),
                          if (!_userdetails.gender.isNullOrEmpty()) ...[
                            ProfileListTile(
                                "Gender", _userdetails.gender, Icons.wc),
                          ],
                          ProfileListTile(
                              "Email", _userdetails.email, Icons.email),
                          ProfileListTile("Your College",
                              _userdetails.collegeName, Icons.account_balance),
                          if (!_userdetails.bio.isNullOrEmpty()) ...[
                            ProfileListTile(
                                "Bio", _userdetails.bio, Icons.accessibility),
                          ],
                          if (!_userdetails.designation.isNullOrEmpty()) ...[
                            ProfileListTile("Designation",
                                _userdetails.designation, Icons.work),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
