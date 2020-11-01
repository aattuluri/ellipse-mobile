import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
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
    context.read<UserDetailsRepository>().refreshData();
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
                          child: InkWell(
                            onTap: _userdetails.profile_pic.isNullOrEmpty()
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
                                                _userdetails.profile_pic
                                                        .isNullOrEmpty()
                                                    ? NoProfilePic()
                                                    : FadeInImage(
                                                        image: NetworkImage(
                                                            "${Url.URL}/api/image?id=${_userdetails.profile_pic}"),
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
                              child: _userdetails.profile_pic.isNullOrEmpty()
                                  ? NoProfilePic()
                                  : FadeInImage(
                                      image: NetworkImage(
                                          "${Url.URL}/api/image?id=${_userdetails.profile_pic}"),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.edit_profile);
                            },
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      AutoSizeText("Edit Profile"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.person_pin,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.username,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.person_outline,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.wc,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.gender,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.email,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.email,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          /*
                        ListTile(
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              //Theme.of(context).accentColor,
                            ),
                            child: Center(
                              child: Icon(Icons.phone,
                                  size: 25,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Mobile Number",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ProductSans',
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Separator.spacer(space: 4),
                            ],
                          ),
                          subtitle: Text(
                            "+91 7995057295",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'ProductSans',
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                          ),
                          // trailing: trailing,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          onTap: () {},
                        ),
                        */
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.account_balance,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Your College",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.college_name,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.accessibility,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Bio",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.bio,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                //Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Icon(Icons.work,
                                    size: 25,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Designation",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Separator.spacer(space: 4),
                              ],
                            ),
                            subtitle: Text(
                              _userdetails.designation,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProductSans',
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            // trailing: trailing,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            onTap: () {},
                          ),
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
