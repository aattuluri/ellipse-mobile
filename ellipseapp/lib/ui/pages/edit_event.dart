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
  final _key = new GlobalKey<FormState>();
  final List<String> _eventtypes = ["Technical", "Cultural"];
  List colleges = List();
  final List<String> _requirements = ["Laptop", "Internet"];
  final List<String> _themes = ["Coding", "Writing"];
  final List<String> _venueTypes = ["College", "Other"];
  List<dynamic> selected_requirements = [];
  List<dynamic> selected_themes = [];
  bool o_allowed = null;
  String event_mode = "";
  String payment_type = "";
  String _college;
  String _venueType;
  String event_type;
  String theme;
  String requirement;
  String reg_mode;
  String selected = "";
  final _picker = ImagePicker();

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
  var _aboutController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();
  var _event_typeController = new TextEditingController();
  var _reg_last_dateController = new TextEditingController();
  var _reg_linkController = new TextEditingController();
  var _event_modeController = new TextEditingController();
  var _payment_typeController = new TextEditingController();
  var _registration_feeController = new TextEditingController();
  var _venueController = new TextEditingController();
  var _platform_detailsController = new TextEditingController();
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

  edit_event(String id, bool o_allowed_, venue_type) async {
    if (_nameController.text.isNullOrEmpty() ||
        _descriptionController.text.isNullOrEmpty() ||
        _aboutController.text.isNullOrEmpty() ||
        //isEmptyList(selected_requirements) ||
        //isEmptyList(selected_themes) ||
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
      bool o_a = o_allowed == null ? o_allowed_ : o_allowed;
      var response = await http.post(
        '${Url.URL}/api/updateevent',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefToken'
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
          "platform_details": _platform_detailsController.text,
          "about": _aboutController.text,
          "fee_type": "$p_t",
          "o_allowed": o_a,
          "requirements": selected_requirements,
          "tags": selected_themes,
          'venue_type': _venueType.isNullOrEmpty() ? venue_type : _venueType,
          'venue_college': "",
          "venue": _venueController.text,
        }),
      );
      var jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        if (_imageFile != null) {
          Map<String, String> headers = {
            HttpHeaders.authorizationHeader: "Bearer $prefToken",
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
    context.read<EventsRepository>().refreshData();
    Navigator.of(context).pop(true);
    alertDialog(context, "Edit Event",
        "-Event updated successfully\n-Refresh event to load updated event poster");
  }

  @override
  void initState() {
    loadPref();
    getData();
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvent(widget.index);
    _nameController = TextEditingController(text: _event.name);
    _descriptionController =
        new TextEditingController(text: _event.description);
    _aboutController = new TextEditingController(text: _event.about);
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
    _platform_detailsController =
        new TextEditingController(text: _event.platform_details);

    _event_modeController = new TextEditingController(text: _event.event_mode);
    _payment_typeController =
        new TextEditingController(text: _event.payment_type);
    this.setState(() => selected_requirements = _event.requirements);
    this.setState(() => selected_themes = _event.tags);

    return _isUploading
        ? LoaderCircular(0.25, "Uploading")
        : Consumer<DataRepository>(
            builder: (context, model, child) => Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        CardPage.body(
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
                                  onPressed: () =>
                                      _openImagePickerModal(context),
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
                        CardPage.body(
                          title: "Event Details",
                          body: RowLayout(children: <Widget>[
                            TextFormField(
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              controller: _aboutController,
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "About"),
                              maxLines: 6,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
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
                                      items: model.eventTypes
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

                            /*FormField(
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
                            ),*/
                          ]),
                        ),
                        CardPage.body(
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
                                      hoverColor:
                                          Theme.of(context).primaryColor,
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      value: o_allowed == null
                                          ? _event.o_allowed
                                          : o_allowed,
                                      onChanged: (value) {
                                        setState(() {
                                          o_allowed = true;
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
                                      hoverColor:
                                          Theme.of(context).primaryColor,
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      value: o_allowed == null
                                          ? !_event.o_allowed
                                          : !o_allowed,
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
                        CardPage.body(
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
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                            BorderRadius
                                                                .circular(
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
                                                    labelText:
                                                        "Add Requirement",
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
                                                  children: model.requirements
                                                      .map((item) {
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
                                                                    fontSize:
                                                                        20),
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
                        CardPage.body(
                          title: "Tags",
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
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                            BorderRadius
                                                                .circular(
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
                                        title: "Add Tag",
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
                                                    labelText: "Add Tag",
                                                    hintText:
                                                        "add your own tag",
                                                  ),
                                                  onChanged: (value) {
                                                    selected = value;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    "Select tags from below list"),
                                                Column(
                                                  children:
                                                      model.tags.map((item) {
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
                                                                    fontSize:
                                                                        20),
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
                        CardPage.body(
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
                        if ((event_mode == "" &&
                                _event_modeController.text == "Offline") ||
                            (event_mode == "Offline")) ...[
                          CardPage.body(
                            title: "Venue",
                            body: RowLayout(children: <Widget>[
                              FormField(
                                builder: (FormFieldState state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Venue Type"),
                                    child: new DropdownButtonHideUnderline(
                                      child: new DropdownButton(
                                        hint: Text(
                                            (!_event.venueType.isNullOrEmpty())
                                                ? _event.venueType
                                                : !_venueType.isNullOrEmpty()
                                                    ? _venueType
                                                    : "Select Venue Type"),
                                        isExpanded: true,
                                        value: _venueType,
                                        isDense: true,
                                        items: _venueTypes.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(
                                              item,
                                            ),
                                            value: item.toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _venueType = newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if ((!_event.venueType.isNullOrEmpty() &&
                                      (_event.venueType == "College" ||
                                          _event.venueType == "Other")) ||
                                  !_venueType.isNullOrEmpty()) ...[
                                TextFormField(
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
                                      hintText: _event.venueType == "College"
                                          ? "Room No,Building,College Name"
                                          : "Room No,Building,Address",
                                      border: OutlineInputBorder(),
                                      labelText: "Venue"),
                                  maxLines: 5,
                                ),
                              ],
                            ]),
                          ),
                        ],
                        if ((event_mode == "" &&
                                _event_modeController.text == "Online") ||
                            (event_mode == "Online")) ...[
                          CardPage.body(
                            title: "Platform",
                            body: RowLayout(children: <Widget>[
                              TextFormField(
                                onSaved: (e) => e,
                                controller: _platform_detailsController,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                                cursorColor:
                                    Theme.of(context).textTheme.caption.color,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Details"),
                                maxLines: 3,
                              ),
                            ]),
                          )
                        ],
                        CardPage.body(
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
                            if ((payment_type == "" &&
                                    _payment_typeController.text == "Paid") ||
                                (payment_type == "Paid")) ...[
                              TextFormField(
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
                            ],
                          ]),
                        ),
                        CardPage.body(
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
                                  labelText: 'Start time',
                                  hintText: 'Start time',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isBefore(DateTime.parse(
                                          _reg_last_dateController.text)) ||
                                      value.isAfter(DateTime.parse(
                                          _finish_timeController.text))) {
                                    _start_timeController.clear();
                                    alertDialog(context, "Start Date",
                                        "Start Date should be after reg end date and before finish date ");
                                  }
                                },
                                controller: _start_timeController,
                                format: format,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time)
                                        .toUtc();
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
                                  labelText: 'Finish time',
                                  hintText: 'Finish time',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isBefore(DateTime.parse(
                                          _start_timeController.text)) ||
                                      value.isBefore(DateTime.parse(
                                          _reg_last_dateController.text))) {
                                    _finish_timeController.clear();
                                    alertDialog(context, "End Date",
                                        "End Date should be after start date and reg end date");
                                  }
                                },
                                controller: _finish_timeController,
                                format: format,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
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
                                  labelText: "Registration last date",
                                  hintText: 'Registration last date',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 18.0,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isAfter(DateTime.parse(
                                          _start_timeController.text)) ||
                                      value.isAfter(DateTime.parse(
                                          _finish_timeController.text))) {
                                    _reg_last_dateController.clear();
                                    alertDialog(context, "Reg End Date",
                                        "Reg End Date should be before start time and end time");
                                  }
                                },
                                controller: _reg_last_dateController,
                                format: format,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
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
                            ? CardPage.body(
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
                                    cursorColor: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                              edit_event(_event.id, _event.o_allowed,
                                  _event.venueType);
                            },
                            color: Theme.of(context).cardColor,
                            textColor:
                                Theme.of(context).textTheme.caption.color,
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
