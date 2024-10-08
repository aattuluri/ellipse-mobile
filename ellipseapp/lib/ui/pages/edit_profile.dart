import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  bool isloading = false;
  final _picker = ImagePicker();
  var _nameController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _usernameController = new TextEditingController();
  var _phonenoController = new TextEditingController();
  var _bioController = new TextEditingController();
  var _designationController = new TextEditingController();

  @override
  // To store the file provided by the image_picker
  File _imageFile;

  // To track the file uploading state
  bool _isUploading = false;

  void _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 70);
    // final File file = File(pickedFile.path);

    setState(() {
      _imageFile = File(pickedFile.path);
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

  edit_profile(String gender_) async {
    if (_nameController.text.isNullOrEmpty() ||
        _usernameController.text.isNullOrEmpty() ||
        _emailController.isNullOrEmpty() ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Edit Profile"),
            content: new Text("Required fields can not be empty"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isUploading = true;
      });
      var response = await httpPostWithHeaders(
        '${Url.URL}/api/users/updateprofile',
        jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'username': _usernameController.text,
          'bio': _bioController.text,
          'gender': gender_,
          'designation': _designationController.text,
          'college_id': prefCollegeId
        }),
      );
      if (response.statusCode == 200) {
        if (_imageFile != null) {
          Map<String, String> headers = {
            HttpHeaders.authorizationHeader: "Bearer $prefToken",
            HttpHeaders.contentTypeHeader: "application/json"
          };
          final mimeTypeData =
              lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8])
                  .split('/');

          // Intilize the multipart request
          final imageUploadRequest = http.MultipartRequest(
              'POST', Uri.parse('${Url.URL}/api/users/uploadimage'));
          imageUploadRequest.headers.addAll(headers);
          // Attach the file in the request
          final file = await http.MultipartFile.fromPath(
              'image', _imageFile.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          // Explicitly pass the extension of the image with request body
          // Since image_picker has some bugs due which it mixes up
          // image extension with file name like this filenamejpge
          // Which creates some problem at the server side to manage
          // or verify the file extension
          imageUploadRequest.files.add(file);

          try {
            final streamedResponse = await imageUploadRequest.send();
            final response1 = await http.Response.fromStream(streamedResponse);
            if (response1.statusCode == 200) {
              context.read<UserDetailsRepository>().refreshData();
              Navigator.of(context).pop(true);
              setState(() {
                _isUploading = false;
              });
              print("Image Uploaded");
            }
          } catch (e) {
            print(e);
            return null;
          }
        } /////////////////////////////
        else {
          done();
        }
      } else {
        done();
      }
    }
  }

  done() async {
    setState(() {
      _isUploading = false;
    });
    context.read<UserDetailsRepository>().refreshData();
    Navigator.of(context).pop(true);
    messageDialog(context, 'Profile updated successfully');
  }

  loadFields() async {
    final UserDetails _userdetails =
        context.read<UserDetailsRepository>().getUserDetails(0);
    _nameController = TextEditingController(text: _userdetails.name);
    _emailController = TextEditingController(text: _userdetails.email);
    _usernameController =
        new TextEditingController(text: _userdetails.username);
    _phonenoController = new TextEditingController(text: _userdetails.bio);
    _bioController = new TextEditingController(text: _userdetails.bio);
    _designationController =
        new TextEditingController(text: _userdetails.designation);
  }

  @override
  void initState() {
    loadPref();
    loadFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return _isUploading
        ? LoaderCircular("Uploading")
        : Consumer<DataRepository>(
            builder: (context, model, child) => Scaffold(
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
                                      width: 80.0,
                                      height: 80.0,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(540),
                                          child: Container(
                                            height: 73,
                                            width: 73,
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
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
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
                                        borderRadius:
                                            BorderRadius.circular(540),
                                        child: InkWell(
                                          onTap: _userdetails.profilePic
                                                  .isNullOrEmpty()
                                              ? () {}
                                              : () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => Container(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor
                                                          .withOpacity(0.7),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              _userdetails
                                                                      .profilePic
                                                                      .isNullOrEmpty()
                                                                  ? NoProfilePic()
                                                                  : FadeInImage(
                                                                      image: NetworkImage(
                                                                          "${Url.URL}/api/image?id=${_userdetails.profilePic}"),
                                                                      placeholder:
                                                                          AssetImage(
                                                                              'assets/icons/loading.gif'),
                                                                    ),
                                                              SizedBox(
                                                                  height: 10),
                                                              FloatingActionButton(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                    Icons.close,
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
                                            height: 73,
                                            width: 73,
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
                              SizedBox(width: 10.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                    AutoSizeText(
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
                              labelText: "Username"),
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
                          enabled: false,
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
                        TextFormField(
                            controller: _designationController,
                            readOnly: true,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: OutlineInputBorder(),
                                labelText: "Designation",
                                hintText: 'Select Designation'),
                            onTap: () {
                              showDropdownSearchDialog(
                                  context: context,
                                  items: model.designationsData,
                                  addEnabled: false,
                                  onChanged: (String key, String value) {
                                    setState(() {
                                      _designationController =
                                          TextEditingController(text: value);
                                    });
                                  });
                            }),
                      ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RButton('Save', 13, () {
                      edit_profile(_userdetails.gender);
                    }),
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
