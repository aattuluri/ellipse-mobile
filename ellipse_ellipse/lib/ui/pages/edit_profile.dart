import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ellipseellipse/util/routes.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:core';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _key = new GlobalKey<FormState>();
  bool isloading = false;
  String token = "", id = "", email = "", college_id = "";
  String designation;
  final List<String> _designations = ["Student", "Club"];
  var _nameController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _usernameController = new TextEditingController();
  var _phonenoController = new TextEditingController();
  var _designationController = new TextEditingController();
  var _bioController = new TextEditingController();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
  }

  @override
  // To store the file provided by the image_picker
  File _imageFile;

  // To track the file uploading state
  bool _isUploading = false;

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source, imageQuality: 10);
    // Compress plugin

    setState(() {
      _imageFile = image;
    });

    // Closes the bottom sheet
    Navigator.pop(context);
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Select an image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.caption.color),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text(
                    'Use Camera',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text(
                    'Use Gallery',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  edit_profile() async {
    http.Response response = await http.post(
      '${Url.URL}/api/users/updateprofile',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': _nameController.text,
        'username': _usernameController.text,
        'bio': _bioController.text,
        'gender': 'Male',
        'designation': designation,
        'college_id': college_id
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    _nameController = TextEditingController(text: _userdetails.name);
    _emailController = TextEditingController(text: _userdetails.email);
    _usernameController =
        new TextEditingController(text: _userdetails.username);
    _phonenoController = new TextEditingController(text: _userdetails.bio);
    _designationController =
        new TextEditingController(text: _userdetails.designation);
    _bioController = new TextEditingController(text: _userdetails.bio);

    return isloading
        ? SafeArea(
            child: Scaffold(
                body: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                Text(
                  "Updating password....",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )))
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                iconTheme: Theme.of(context).iconTheme,
                elevation: 4,
                title: Text(
                  "Edit Profile",
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: RowLayout(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10.0),
                              _imageFile != null
                                  ? Container(
                                      height: 120.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3.0,
                                              offset: Offset(0, 4.0),
                                              color: Colors.black38),
                                        ],
                                        image: DecorationImage(
                                          image: FileImage(
                                            _imageFile,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 100.0,
                                      height: 100.0,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${Url.URL}/api/image?id=${_userdetails.profile_pic}",
                                            placeholder: (context, url) =>
                                                Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Icon(
                                                Icons.image,
                                                size: 80,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                      )),
                              SizedBox(width: 30.0),
                              OutlineButton(
                                onPressed: () {
                                  _openImagePickerModal(context);
                                },
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    width: 1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_a_photo,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Change Profile Pic',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Userame"),
                          maxLines: 1,
                        ),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Name"),
                          maxLines: 1,
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Email"),
                          maxLines: 1,
                        ),
                        TextFormField(
                          controller: _phonenoController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mobile Number"),
                          maxLines: 1,
                        ),
                        TextFormField(
                          controller: _bioController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "Bio"),
                          maxLines: 6,
                        ),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Designation"),
                              child: new DropdownButtonHideUnderline(
                                child: Expanded(
                                  child: new DropdownButton(
                                    hint: Text(_userdetails.designation),
                                    isExpanded: true,
                                    value: designation,
                                    isDense: true,
                                    items: _designations
                                        .map((value) => DropdownMenuItem(
                                              child: Text(value),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        designation = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                          width: 200,
                          height: 50,
                          margin: EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(0.3),
                            onPressed: () {
                              setState(() {
                                isloading = true;
                              });
                              edit_profile();
                              setState(() {
                                isloading = false;
                              });
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
