import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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
  List colleges = List();
  final List<String> _requirements = ["Laptop", "Internet"];
  final List<String> _themes = ["Coding", "Writing"];
  List<dynamic> selected_requirements = [];
  List<dynamic> selected_themes = [];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;
  bool isChecked8 = false;
  bool o_allowed;
  String event_mode;
  String payment_type;
  String _college;
  String event_type;
  String theme;
  String requirement;
  String reg_mode;
  String selected = "";
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
      colleges = resBody;
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

  edit_event(String id) async {
    http.Response response = await http.post(
      '${Url.URL}/api/updateevent',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "eventId": id,
        "user_id": "$id",
        "college_id": "$_college",
        "name": _nameController.text,
        "description": _descriptionController.text,
        "event_type": "$event_type",
        "event_mode": "$event_mode",
        "fee_type": "$payment_type",
        "venue": _venueController.text,
        "fee": _registration_feeController.text,
        "requirements": selected_requirements,
        "tags": selected_themes,
        "o_allowed": o_allowed,
        "start_time": _start_timeController.text,
        "finish_time": _finish_timeController.text,
        "registration_end_time": _reg_last_dateController.text,
        "reg_link": _reg_linkController.text,
        "reg_mode": reg_mode
      }),
    );
    var jsonResponse = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(jsonResponse['eventId']);
    String eventId = jsonResponse['eventId'];
    if (response.statusCode == 200) {}
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
    this.setState(() => selected_requirements = _event.requirements);
    this.setState(() => selected_themes = _event.tags);
    setState(() {
      if (_event.event_mode == "Offline") {
        isChecked1 = true;
        isChecked2 = false;
      } else if (_event.event_mode == "Online") {
        isChecked2 = true;
        isChecked1 = false;
      } else {}
    });
    setState(() {
      if (_event.payment_type == "Free") {
        isChecked3 = true;
        isChecked4 = false;
      } else if (_event.payment_type == "Paid") {
        isChecked4 = true;
        isChecked3 = false;
      } else {}
    });
    return Scaffold(
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
                          ? Center(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Url.URL}/api/image?id=${_event.imageUrl}",
                                filterQuality: FilterQuality.high,
                                fadeInDuration: Duration(milliseconds: 1000),
                                placeholder: (context, url) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Icon(
                                    Icons.error,
                                    size: 80,
                                  ),
                                ),
                              ),
                            )
                          : Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                              height: 300.0,
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width,
                            ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        child: OutlineButton(
                          onPressed: () => _openImagePickerModal(context),
                          borderSide: BorderSide(
                              color: Theme.of(context).textTheme.caption.color,
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
                                'Change Poster',
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
                                hint: Text(_event.college_name),
                                isExpanded: true,
                                value: _college,
                                isDense: true,
                                items: colleges.map((item) {
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
                                  o_allowed = true;
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
                                  o_allowed = false;
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
                  title: "Requirements",
                  body: RowLayout(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selected_requirements.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5, right: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          selected_requirements[index],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            this.setState(() =>
                                                selected_requirements
                                                    .removeAt(index));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      ),
                      InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => RoundDialog(
                                title: "Add Requirement",
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      children: [
                                        TextField(
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                this.setState(() =>
                                                    selected_requirements.add(
                                                        selected.toString()));
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.add, size: 25),
                                            ),
                                            labelText: "Add Requirement",
                                            hintText:
                                                "add your own requirement",
                                          ),
                                          onChanged: (value) {
                                            selected = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Select requirements from below list"),
                                        Column(
                                          children: _requirements.map((item) {
                                            return InkWell(
                                              onTap: () {
                                                this.setState(() =>
                                                    selected_requirements
                                                        .add(item.toString()));
                                                Navigator.pop(context);
                                              },
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: new Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                          )),
                    ],
                  ),
                ),
                CardPage1.body(
                  title: "Themes",
                  body: RowLayout(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selected_themes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5, right: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          selected_themes[index],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            this.setState(() => selected_themes
                                                .removeAt(index));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      ),
                      InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => RoundDialog(
                                title: "Add Theme",
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      children: [
                                        TextField(
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                this.setState(() =>
                                                    selected_themes.add(
                                                        selected.toString()));
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.add, size: 25),
                                            ),
                                            labelText: "Add Theme",
                                            hintText: "add your own theme",
                                          ),
                                          onChanged: (value) {
                                            selected = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Select themes from below list"),
                                        Column(
                                          children: _themes.map((item) {
                                            return InkWell(
                                              onTap: () {
                                                this.setState(() =>
                                                    selected_themes
                                                        .add(item.toString()));
                                                Navigator.pop(context);
                                              },
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: new Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                          )),
                    ],
                  ),
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
                                setState(() {
                                  isChecked1 = true;
                                  isChecked2 = false;
                                  event_mode = "Online";
                                });
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
                                setState(() {
                                  isChecked2 = true;
                                  isChecked1 = false;
                                  event_mode = "Offline";
                                });
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
                              color: Theme.of(context).textTheme.caption.color,
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
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                setState(() {
                                  isChecked3 = true;
                                  isChecked4 = false;
                                  payment_type = "Free";
                                });
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
                                setState(() {
                                  isChecked4 = true;
                                  isChecked3 = false;
                                  payment_type = "Paid";
                                });
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
                              color: Theme.of(context).textTheme.caption.color,
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
                        cursorColor: Theme.of(context).textTheme.caption.color,
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
                        cursorColor: Theme.of(context).textTheme.caption.color,
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
                        cursorColor: Theme.of(context).textTheme.caption.color,
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
                _event.reg_mode == "link"
                    ? CardPage1.body(
                        title: "Event Registration Link",
                        body: RowLayout(children: <Widget>[
                          TextFormField(
                            onSaved: (e) => e,
                            controller: _reg_linkController,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Registration Link"),
                            maxLines: 5,
                          ),
                        ]),
                      )
                    : Container(),
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
                    onPressed: () {
                      edit_event(_event.id);
                    },
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
    );
  }
}
