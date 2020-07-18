import 'dart:async';
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../util/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../models/index.dart';
import 'package:http/http.dart' as http;
import '../../util/index.dart';

class EditEvent extends StatefulWidget {
  final int index;

  const EditEvent(this.index);
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  String token = "", id = "", email = "", college = "";
  final _key = new GlobalKey<FormState>();
  final List<String> _eventtypes = ["Technical", "Cultural"];
  List data = List();

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;
  bool isChecked8 = false;
  String event_mode;
  String payment_type;
  String _college;
  String event_type;
  String o_allowed;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("eveid", "");
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college = preferences.getString("college");
    });
  }

  Future<List> getData() async {
    final response = await http.get("${Url.URL}/colleges");
    //return json.decode(response.body);
    var resBody = json.decode(response.body.toString());

    setState(() {
      data = resBody;
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

  var _nameController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();
  var _reg_last_dateController = new TextEditingController();
  var _reg_linkController = new TextEditingController();
  var _registration_feeController = new TextEditingController();
  var _venueController = new TextEditingController();
  var _platform_linkController = new TextEditingController();
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

  @override
  void initState() {
    getPref();
    getData();
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    _nameController = TextEditingController(text: _event.name);
    _descriptionController =
        new TextEditingController(text: _event.description);
    _start_timeController = new TextEditingController(text: _event.start_time);
    _finish_timeController =
        new TextEditingController(text: _event.finish_time);
    _reg_last_dateController =
        new TextEditingController(text: _event.reg_last_date);
    _reg_linkController = new TextEditingController(text: _event.reg_link);
    _registration_feeController =
        new TextEditingController(text: _event.registration_fee);
    _venueController = new TextEditingController(text: _event.venue);
    _platform_linkController =
        new TextEditingController(text: _event.platform_link);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 4,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ),
          title: Text(
            "Edit Event",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CardPage1.body(
                    title: "Event Poster",
                    body: RowLayout(
                      children: <Widget>[
                        _imageFile == null
                            ? Image.memory(
                                base64Decode(_event.imageUrl.toString()))
                            : Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                                height: 300.0,
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width,
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: OutlineButton(
                            onPressed: () => _openImagePickerModal(context),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                width: 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_a_photo,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Change Image',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CardPage1.body(
                    title: "Event Details",
                    body: RowLayout(children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please enter name";
                          }
                        },
                        onSaved: (e) => e,
                        controller: _nameController,
                        cursorColor: Theme.of(context).textTheme.caption.color,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Name"),
                        maxLines: 1,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please enter description";
                          }
                        },
                        onSaved: (e) => e,
                        controller: _descriptionController,
                        cursorColor: Theme.of(context).textTheme.caption.color,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description"),
                        maxLines: 6,
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Event Type"),
                            child: new DropdownButtonHideUnderline(
                              child: Expanded(
                                child: new DropdownButton(
                                  hint: Text(_event.event_type),
                                  isExpanded: true,
                                  value: event_type,
                                  isDense: true,
                                  items: _eventtypes
                                      .map((value) => DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          ))
                                      .toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      event_type = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "College"),
                            child: new DropdownButtonHideUnderline(
                              child: Expanded(
                                child: new DropdownButton(
                                  hint: Text(_event.college_id),
                                  isExpanded: true,
                                  value: _college,
                                  isDense: true,
                                  items: data.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                        item['name'],
                                      ),
                                      value: item['_id'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _college = newValue;
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
                  CardPage1.body(
                    body: RowLayout(children: <Widget>[
                      Text(
                        'Other college students allowed?',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Theme.of(context)
                                .textTheme
                                .caption
                                .color
                                .withOpacity(0.9)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked5,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked5 = true;
                                    isChecked6 = false;
                                  });
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            Text(
                              'Yes',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked6,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked6 = true;
                                    isChecked5 = false;
                                  });
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            Text(
                              'No',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                        ],
                      ),
                    ]),
                  ),
                  CardPage1.body(
                    title: "Mode",
                    body: RowLayout(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked1,
                                onChanged: (value) {
                                  if (isChecked1 == false) {
                                    setState(() {
                                      isChecked1 = true;
                                      isChecked2 = false;
                                    });
                                  }
                                  //toggleCheckbox(value);
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                                tristate: false,
                              ),
                            ),
                            Text(
                              'Offline',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked2,
                                onChanged: (value) {
                                  if (isChecked2 == false) {
                                    setState(() {
                                      isChecked2 = true;
                                      isChecked1 = false;
                                    });
                                  }
                                  //toggleCheckbox(value);
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                                tristate: false,
                              ),
                            ),
                            Text(
                              'Online',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                        ],
                      ),
                    ]),
                  ),
                  isChecked1
                      ? CardPage1.body(
                          title: "Venue",
                          body: RowLayout(children: <Widget>[
                            TextFormField(
                              onSaved: (e) => e,
                              controller: _venueController,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Venue"),
                              maxLines: 5,
                            ),
                          ]),
                        )
                      : isChecked2
                          ? CardPage1.body(
                              title: "Platform",
                              body: RowLayout(children: <Widget>[
                                TextFormField(
                                  onSaved: (e) => e,
                                  controller: _platform_linkController,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  cursorColor:
                                      Theme.of(context).textTheme.caption.color,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Link"),
                                  maxLines: 3,
                                ),
                              ]),
                            )
                          : Container(),
                  CardPage1.body(
                    title: "Payment",
                    body: RowLayout(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked3,
                                onChanged: (value) {
                                  if (isChecked3 == false) {
                                    setState(() {
                                      isChecked3 = true;
                                      isChecked4 = false;
                                    });
                                  }
                                  //toggleCheckbox(value);
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                                tristate: false,
                              ),
                            ),
                            Text(
                              'Free',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                          Row(children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                value: isChecked4,
                                onChanged: (value) {
                                  if (isChecked4 == false) {
                                    setState(() {
                                      isChecked4 = true;
                                      isChecked3 = false;
                                    });
                                  }
                                  //toggleCheckbox(value);
                                },
                                activeColor: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.2),
                                checkColor:
                                    Theme.of(context).textTheme.caption.color,
                                tristate: false,
                              ),
                            ),
                            Text(
                              'Paid',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.9)),
                            ),
                          ]),
                        ],
                      ),
                      isChecked4
                          ? TextFormField(
                              onSaved: (e) => e,
                              controller: _registration_feeController,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Registration Fee(in Rs)"),
                              maxLines: 1,
                            )
                          : Container(),
                    ]),
                  ),
                  CardPage1.body(
                    title: "Date and Time Details",
                    body: RowLayout(
                      children: <Widget>[
                        DateTimeField(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Start time',
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                              fontSize: 18.0,
                            ),
                          ),
                          validator: (e) {
                            if (e == "") {
                              return "Please select start date";
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
                        DateTimeField(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Finish time',
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
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
                        DateTimeField(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Registration last date',
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                              fontSize: 18.0,
                            ),
                          ),
                          validator: (e) {
                            if (e == "") {
                              return "Please select registration last date";
                            }
                          },
                          onSaved: (e) => e,
                          controller: _reg_last_dateController,
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
                      ],
                    ),
                  ),
                  CardPage1.body(
                    title: "Event Registration Link",
                    body: RowLayout(children: <Widget>[
                      TextFormField(
                        onSaved: (e) => e,
                        controller: _reg_linkController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        cursorColor: Theme.of(context).textTheme.caption.color,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Registration Link"),
                        maxLines: 5,
                      ),
                    ]),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                      color: Theme.of(context).cardColor,
                      textColor: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
