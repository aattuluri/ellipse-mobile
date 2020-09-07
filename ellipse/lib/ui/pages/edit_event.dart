import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class EditEvent extends StatefulWidget {
  final int index;

  const EditEvent(this.index);
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  String token = "", id = "", email = "", college_id = "";
  final _key = new GlobalKey<FormState>();
  final List<String> _eventtypes = ["Technical", "Cultural"];
  List colleges = List();
  final List<String> _requirements = ["Laptop", "Internet"];
  final List<String> _themes = ["Coding", "Writing"];
  List<dynamic> selected_requirements = [];
  List<dynamic> selected_themes = [];
  bool o_allowed;
  String event_mode = "";
  String payment_type = "";
  String _college;
  String event_type;
  String theme;
  String requirement;
  String reg_mode;
  String selected = "";
  final _picker = ImagePicker();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
  }

  Future<List> getData() async {
    final response = await http.get("${Url.URL}/api/colleges");
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
    final pickedFile = await _picker.getImage(source: source, imageQuality: 70);
    // final File file = File(pickedFile.path);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  var _nameController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();
  var _event_typeController = new TextEditingController();
  var _reg_last_dateController = new TextEditingController();
  var _reg_linkController = new TextEditingController();
  var _event_modeController = new TextEditingController();
  var _payment_typeController = new TextEditingController();
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

  edit_event(String id, bool o_allowed_) async {
    if (_nameController.text.isNullOrEmpty() ||
        _descriptionController.text.isNullOrEmpty() ||
        isEmptyList(selected_requirements) ||
        isEmptyList(selected_themes) ||
        _start_timeController.text.isNullOrEmpty() ||
        _finish_timeController.text.isNullOrEmpty() ||
        _reg_last_dateController.text.isNullOrEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Post Event"),
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
      String e_m = event_mode != "" ? event_mode : _event_modeController.text;
      String p_t =
          payment_type != "" ? payment_type : _payment_typeController.text;
      String e_t = event_type == null ? _event_typeController.text : event_type;
      var response = await http.post(
        '${Url.URL}/api/updateevent',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          "eventId": id,
          "name": _nameController.text,
          "description": _descriptionController.text,
          "start_time": _start_timeController.text,
          "finish_time": _finish_timeController.text,
          "registration_end_time": _reg_last_dateController.text,
          "event_mode": "$e_m",
          "event_type": "$e_t",
          "reg_link": _reg_linkController.text,
          "fee": _registration_feeController.text,
          "about": _descriptionController.text,
          "fee_type": "$p_t",
          "o_allowed": o_allowed_,
          "requirements": selected_requirements,
          "tags": selected_themes,
          'venue_type': _venueController.text,
          'venue_college': _venueController.text,
          "venue": _venueController.text,
        }),
      );
      var jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        if (_imageFile != null) {
          Map<String, String> headers = {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json"
          };
          final mimeTypeData =
              lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8])
                  .split('/');
          print('Event Id');
          // Intilize the multipart request
          final imageUploadRequest = http.MultipartRequest(
              'POST', Uri.parse('${Url.URL}/api/event/uploadimage?id=$id'));
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
              Navigator.of(context).pop(true);
              setState(() {
                _imageFile = null;
              });
              setState(() {
                _isUploading = false;
              });
              print("Image Uploaded");
            }
          } catch (e) {
            print(e);
            return null;
          }
        } else {
          setState(() {
            _imageFile = null;
          });
          setState(() {
            _isUploading = false;
          });
          context.read<EventsRepository>().refreshData();
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _isUploading = false;
        });
        context.read<EventsRepository>().refreshData();
        Navigator.of(context).pop(true);
      }
    }
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
    _event_typeController = new TextEditingController(text: _event.event_type);
    _start_timeController =
        new TextEditingController(text: _event.start_time.toString());
    _finish_timeController =
        new TextEditingController(text: _event.finish_time.toString());
    _reg_last_dateController =
        new TextEditingController(text: _event.reg_last_date.toString());
    _reg_linkController = new TextEditingController(text: _event.reg_link);
    _registration_feeController =
        new TextEditingController(text: _event.registration_fee);
    _venueController = new TextEditingController(text: _event.venue);
    _platform_linkController =
        new TextEditingController(text: _event.platform_link);

    _event_modeController = new TextEditingController(text: _event.event_mode);
    _payment_typeController =
        new TextEditingController(text: _event.payment_type);
    this.setState(() => selected_requirements = _event.requirements);
    this.setState(() => selected_themes = _event.tags);

    return _isUploading
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
                  "Updating Event....",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )))
        : Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      CardPage1.body(
                        title: "Event Poster",
                        body: RowLayout(
                          children: <Widget>[
                            _imageFile == null
                                ? Center(
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          "${Url.URL}/api/image?id=${_event.imageUrl}"),
                                      placeholder: AssetImage(
                                          'assets/icons/loading.gif'),
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
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: OutlineButton(
                                onPressed: () => _openImagePickerModal(context),
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
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Name"),
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
                            cursorColor:
                                Theme.of(context).textTheme.caption.color,
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
                                    value:
                                        _event.o_allowed == true ? true : false,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    activeColor: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.2),
                                    checkColor: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                    value:
                                        _event.o_allowed == true ? false : true,
                                    onChanged: (value) {
                                      setState(() {
                                        o_allowed = false;
                                      });
                                    },
                                    activeColor: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.2),
                                    checkColor: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 5,
                                              right: 5),
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
                                                          selected_requirements
                                                              .add(selected
                                                                  .toString()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(Icons.add,
                                                        size: 25),
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
                                                children:
                                                    _requirements.map((item) {
                                                  return InkWell(
                                                    onTap: () {
                                                      this.setState(() =>
                                                          selected_requirements
                                                              .add(item
                                                                  .toString()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                selected_themes[index],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  this.setState(() =>
                                                      selected_themes
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
                                                              selected
                                                                  .toString()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(Icons.add,
                                                        size: 25),
                                                  ),
                                                  labelText: "Add Theme",
                                                  hintText:
                                                      "add your own theme",
                                                ),
                                                onChanged: (value) {
                                                  selected = value;
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Select themes from below list"),
                                              Column(
                                                children: _themes.map((item) {
                                                  return InkWell(
                                                    onTap: () {
                                                      this.setState(() =>
                                                          selected_themes.add(
                                                              item.toString()));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    event_mode = "Offline";
                                  });
                                },
                                child: Row(children: <Widget>[
                                  (event_mode == "" &&
                                              _event_modeController.text ==
                                                  "Offline") ||
                                          (event_mode == "Offline")
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                  SizedBox(
                                    width: 5,
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
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    event_mode = "Online";
                                  });
                                },
                                child: Row(children: <Widget>[
                                  (event_mode == "" &&
                                              _event_modeController.text ==
                                                  "Online") ||
                                          (event_mode == "Online")
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                  SizedBox(
                                    width: 5,
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
                              ),
                            ],
                          ),
                        ]),
                      ),
                      (event_mode == "" &&
                                  _event_modeController.text == "Offline") ||
                              (event_mode == "Offline")
                          ? CardPage1.body(
                              title: "Venue",
                              body: RowLayout(children: <Widget>[
                                TextFormField(
                                  onSaved: (e) => e,
                                  controller: _venueController,
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
                                      labelText: "Venue"),
                                  maxLines: 5,
                                ),
                              ]),
                            )
                          : (event_mode == "" &&
                                      _event_modeController.text ==
                                          "Offline") ||
                                  (event_mode == "Online")
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
                                      cursorColor: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Platform"),
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
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    payment_type = "Free";
                                  });
                                },
                                child: Row(children: <Widget>[
                                  (payment_type == "" &&
                                              _payment_typeController.text ==
                                                  "Free") ||
                                          (payment_type == "Free")
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                  SizedBox(
                                    width: 5,
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
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    payment_type = "Paid";
                                  });
                                },
                                child: Row(children: <Widget>[
                                  (payment_type == "" &&
                                              _payment_typeController.text ==
                                                  "Paid") ||
                                          (payment_type == "Paid")
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                  SizedBox(
                                    width: 5,
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
                              ),
                            ],
                          ),
                          (payment_type == "" &&
                                      _payment_typeController.text == "Paid") ||
                                  (payment_type == "Paid")
                              ? TextFormField(
                                  onSaved: (e) => e,
                                  controller: _registration_feeController,
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Start time',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Finish time',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Registration last date',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            edit_event(_event.id, _event.o_allowed);
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
