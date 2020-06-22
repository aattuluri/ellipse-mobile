import 'dart:convert';
import '../components/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import '../components/colors.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../screens/homescreen/home_screen.dart';
import '../utils/database_helper.dart';

class PostEvent extends StatefulWidget {
  @override
  _PostEventState createState() {
    return _PostEventState();
  }
}

class _PostEventState extends State<PostEvent> {
  final _key = new GlobalKey<FormState>();
  String id = "", token = "";
  DataBaseHelper databaseHelper = new DataBaseHelper();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      token = preferences.getString("token");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
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

  var _nameController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();

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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_imageFile != null &&
        _nameController.text != null &&
        _descriptionController.text != null) {
      // If image is picked by the user then show a upload btn

      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Post Event'),
          onPressed: () {
            String base64Image = base64Encode(_imageFile.readAsBytesSync());
            print(base64Image);
            String fileName = _imageFile.path.split("/").last;
            print(fileName);
            databaseHelper.add_event(
                base64Image,
                fileName,
                id,
                _nameController.text.trim(),
                _descriptionController.text.trim(),
                _start_timeController.text.trim(),
                _finish_timeController.text.trim());
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new HomeScreen(),
            ));
          },
          color: CustomColors.container,
          textColor: CustomColors.primaryTextColor,
        ),
      );
    } else {}
    return btnWidget;
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Container(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: CustomColors.primaryColor,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: CustomColors.primaryColor,
              elevation: 4,
              iconTheme: IconThemeData(color: CustomColors.icon),
              title: Text(
                "Post Event",
                style: TextStyle(
                    color: CustomColors.primaryTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 40.0, left: 10.0, right: 10.0),
                        child: OutlineButton(
                          onPressed: () => _openImagePickerModal(context),
                          borderSide: BorderSide(
                              color: CustomColors.primaryTextColor, width: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo,
                                color: CustomColors.icon,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Select Image',
                                style: TextStyle(color: CustomColors.icon),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _imageFile == null
                          ? Text(
                              'Please select an image',
                              style: TextStyle(color: CustomColors.icon),
                            )
                          : Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                              height: 300.0,
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width,
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: CustomColors.primaryTextColor,
                          ),
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please enter name";
                            }
                          },
                          onSaved: (e) => e,
                          controller: _nameController,
                          cursorColor: CustomColors.primaryTextColor,
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(
                              color: CustomColors.icon,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: CustomColors.primaryTextColor,
                          ),
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please enter description";
                            }
                          },
                          onSaved: (e) => e,
                          controller: _descriptionController,
                          cursorColor: CustomColors.primaryTextColor,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(
                              color: CustomColors.icon,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: DateTimeField(
                          style: TextStyle(
                            color: CustomColors.primaryTextColor,
                          ),
                          cursorColor: CustomColors.primaryTextColor,
                          decoration: InputDecoration(
                            hintText: 'Select date and time',
                            hintStyle: TextStyle(
                              color: CustomColors.icon,
                              fontSize: 18.0,
                            ),
                          ),
                          validator: (e) {
                            if (e == "") {
                              return "Please select finish date";
                            }
                          },
                          onSaved: (e) => e,
                          controller: _start_timeController,
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: DateTimeField(
                          style: TextStyle(
                            color: CustomColors.primaryTextColor,
                          ),
                          cursorColor: CustomColors.primaryTextColor,
                          decoration: InputDecoration(
                            hintText: 'Select date and time',
                            hintStyle: TextStyle(
                              color: CustomColors.icon,
                              fontSize: 18.0,
                            ),
                          ),
                          validator: (e) {
                            if (e == "") {
                              return "Please select finish time";
                            }
                          },
                          onSaved: (e) => e,
                          controller: _finish_timeController,
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ),
                      _buildUploadBtn(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
