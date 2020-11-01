import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:rxdart/subjects.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../../util/routes.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

double ourMap(v, start1, stop1, start2, stop2) {
  return (v - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}

class PostEvent extends StatefulWidget {
  @override
  _PostEventState createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  List reg_form = [];
  // List<Field1> fetched_form = [];
  final List<String> _eventtypes = ["Technical", "Cultural"];
  final List<String> _requirements = ["Laptop", "Internet"];
  final List<String> _themes = ["Coding", "Writing"];
  final List<String> _venueTypes = ["College", "Other"];
  List fetched_form;
  List colleges = List();
  List<String> selected_requirements = [];
  List<String> selected_themes = [];
  bool _isUploading = false;
  bool offline = false;
  bool online = false;
  bool free = false;
  bool paid = false;
  bool o_allowed = false;
  bool link = false;
  bool form = false;
  String event_mode;
  String payment_type;
  String _college;
  String _venueType;
  String event_type;
  String theme;
  String reg_mode = "";
  String requirement;
  String selected = "";

  Future<List> getData() async {
    final response = await http.get("${Url.URL}/api/colleges");
    var resBody = json.decode(response.body.toString());

    setState(() {
      colleges = resBody;
    });
  }

  final _picker = ImagePicker();
  final int initPage = 0;
  PageController _pageController;
  List<String> tabs = ['Step-1', 'Step-2', 'Step-3', 'Step-4'];

  Stream<int> get currentPage$ => _currentPageSubject.stream;
  Sink<int> get currentPageSink => _currentPageSubject.sink;
  BehaviorSubject<int> _currentPageSubject;

  Alignment _dragAlignment;
  AnimationController _controller;
  Animation<Alignment> _animation;

  @override
  void initState() {
    getData();
    loadPref();
    super.initState();
    _currentPageSubject = BehaviorSubject<int>.seeded(initPage);
    _pageController = PageController(initialPage: initPage);
    _dragAlignment = Alignment(ourMap(initPage, 0, tabs.length - 1, -1, 1), 0);

    _controller = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..addListener(() {
        setState(() {
          _dragAlignment = _animation.value;
        });
      });

    currentPage$.listen((int page) {
      _runAnimation(
        _dragAlignment,
        Alignment(ourMap(page, 0, tabs.length - 1, -1, 1), 0),
      );
    });
  }

  @override
  void dispose() {
    _currentPageSubject.close();
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(Alignment oldA, Alignment newA) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: oldA,
        end: newA,
      ),
    );
    _controller.reset();
    _controller.forward();
  }

  // To store the file provided by the image_picker
  File _imageFile;

  // To track the file uploading state

  void _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 70);
    //final File file = File(pickedFile.path);
    //File file = await FilePicker.getFile(type: FileType.image);
    setState(() {
      _imageFile = File(pickedFile.path);
      //_imageFile = file;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  var _nameController = new TextEditingController();
  var _aboutController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();
  var _reg_last_dateController = new TextEditingController();
  var _reg_linkController = new TextEditingController();
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

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://ellipseapp.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse('https://ellipseapp.page.link/event/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.guna0027.ellipse',
        minimumVersion: 1,
      ),
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }

  post_event() async {
    if (_imageFile == null ||
        _nameController.text.isNullOrEmpty() ||
        _descriptionController.text.isNullOrEmpty() ||
        _aboutController.text.isNullOrEmpty() ||
        event_type.isNullOrEmpty() ||
        // isEmptyList(selected_requirements) ||
        // isEmptyList(selected_themes) ||
        _start_timeController.text.isNullOrEmpty() ||
        _finish_timeController.text.isNullOrEmpty() ||
        _reg_last_dateController.text.isNullOrEmpty() ||
        !o_allowed.isSelected() ||
        reg_mode.isNullOrEmpty() ||
        event_mode.isNullOrEmpty() ||
        payment_type.isNullOrEmpty()) {
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
      http.Response response = await http.post(
        '${Url.URL}/api/events',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefToken'
        },
        body: jsonEncode(<String, dynamic>{
          "poster_url": null,
          "user_id": "$prefId",
          "college_id": "$_college",
          "name": _nameController.text,
          "description": _descriptionController.text,
          "about": _aboutController.text,
          "event_type": "$event_type",
          "event_mode": "$event_mode",
          "fee_type": "$payment_type",
          "venue": _venueController.text,
          "venue_type": _venueType.isNullOrEmpty() ? "" : _venueType,
          "fee": _registration_feeController.text,
          "requirements": selected_requirements,
          "tags": selected_themes,
          "platform_details": _platform_detailsController.text,
          "o_allowed": o_allowed,
          "start_time":
              DateTime.parse(_start_timeController.text).toUtc().toString(),
          "finish_time":
              DateTime.parse(_finish_timeController.text).toUtc().toString(),
          "registration_end_time":
              DateTime.parse(_reg_last_dateController.text).toUtc().toString(),
          "reg_link": _reg_linkController.text,
          "reg_mode": reg_mode,
          "reg_fields": reg_form
        }),
      );
      var jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print(jsonResponse['eventId']);
      String eventId = jsonResponse['eventId'];
      if (response.statusCode == 200) {
        Map<String, String> headers = {
          HttpHeaders.authorizationHeader: "Bearer $prefToken",
          HttpHeaders.contentTypeHeader: "application/json"
        };
        final mimeTypeData =
            lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8])
                .split('/');

        // Intilize the multipart request
        final imageUploadRequest = http.MultipartRequest(
            'POST', Uri.parse('${Url.URL}/api/event/uploadimage?id=$eventId'));
        imageUploadRequest.headers.addAll(headers);
        // Attach the file in the request
        final file = await http.MultipartFile.fromPath('image', _imageFile.path,
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
            setState(() {
              _imageFile = null;
            });
            // createDynamicLink(eventId);
            context.read<EventsRepository>().refreshData();
            Navigator.pushNamed(
              context,
              Routes.start,
              arguments: {'current_tab': 0},
            );
            setState(() {
              _isUploading = false;
            });
            alertDialog(
                context,
                "Post Event",
                "-Event posted successfully" +
                    "\n-Your event will be verified and accepted within few hours" +
                    "\n-Manage your events in posted events panel in your profile");
            print("Image Uploaded");
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return LoaderCircular(0.25, "Uploading");
    } else {
      return Consumer<DataRepository>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            elevation: 4,
            title: Text(
              "Post Event",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [],
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: _dragAlignment,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            double width = constraints.maxWidth;
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: double.infinity,
                                width: width / tabs.length,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // use animated widget
                      StreamBuilder(
                        stream: currentPage$,
                        builder: (context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return AnimatedAlign(
                              duration: kThemeAnimationDuration,
                              alignment: Alignment(
                                  ourMap(
                                      snapshot.data, 0, tabs.length - 1, -1, 1),
                                  0),
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  double width = constraints.maxWidth;
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: double.infinity,
                                      width: width / tabs.length,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: tabs.map((t) {
                            int index = tabs.indexOf(t);
                            return Expanded(
                              child: MaterialButton(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                color: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusElevation: 0.0,
                                hoverElevation: 0.0,
                                elevation: 0.0,
                                highlightElevation: 0.0,
                                child: StreamBuilder(
                                    stream: currentPage$,
                                    builder:
                                        (context, AsyncSnapshot<int> snapshot) {
                                      return AnimatedDefaultTextStyle(
                                        duration: kThemeAnimationDuration,
                                        style: TextStyle(
                                          inherit: true,
                                          color: snapshot.data == index
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        child: Text(t),
                                      );
                                    }),
                                onPressed: () {
                                  currentPageSink.add(index);
                                  _pageController.jumpToPage(index);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => currentPageSink.add(page),
                  children: <Widget>[
                    /////////////////////////////////////////////////////////////////////////////////////////////
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            CardPage.body(
                              title: "Event Poster",
                              body: RowLayout(
                                children: <Widget>[
                                  _imageFile == null
                                      ? Column(
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              size: 165,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Please select an image',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .color),
                                            ),
                                          ],
                                        )
                                      : Image.file(
                                          _imageFile,
                                          fit: BoxFit.cover,
                                          height: 300.0,
                                          alignment: Alignment.topCenter,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 10.0, right: 10.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            _imageFile == null
                                                ? 'Select Image'
                                                : 'Change Image',
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
                          ],
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            CardPage.body(
                              title: "Event Details",
                              body: RowLayout(children: <Widget>[
                                TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      this.setState(() => errors
                                          .add("Name field cannot be empty"));
                                      //return "Password field cannot be empty";
                                    }
                                    return null;
                                  },
                                  cursorColor:
                                      Theme.of(context).textTheme.caption.color,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Name"),
                                  maxLines: 1,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                          hint: Text("Select Event Type"),
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
                                FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "College"),
                                      child: new DropdownButtonHideUnderline(
                                        child: new DropdownButton(
                                          hint: Text("Select College"),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          value: o_allowed,
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
                                          tristate: false,
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
                                          value: !o_allowed,
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
                                          tristate: false,
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
                          ],
                        ),
                      ),
                    ),
                    ///////////////////////////////////////////////////////////////////////////////////////////
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
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
                                                    BorderRadius.circular(
                                                        15.0)),
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
                                                      selected_requirements[
                                                          index],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        this.setState(() =>
                                                            selected_requirements
                                                                .removeAt(
                                                                    index));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .color
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        child:
                                                            Icon(Icons.close),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      autocorrect: false,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: InkWell(
                                                          onTap: () {
                                                            this.setState(() =>
                                                                selected_requirements
                                                                    .add(selected
                                                                        .toString()));
                                                            Navigator.pop(
                                                                context);
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
                                                      children: model
                                                          .requirements
                                                          .map((item) {
                                                        return InkWell(
                                                          onTap: () {
                                                            this.setState(() =>
                                                                selected_requirements
                                                                    .add(item
                                                                        .toString()));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      new Text(
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
                                                    BorderRadius.circular(
                                                        15.0)),
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
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        this.setState(() =>
                                                            selected_themes
                                                                .removeAt(
                                                                    index));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .color
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        child:
                                                            Icon(Icons.close),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      autocorrect: false,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: InkWell(
                                                          onTap: () {
                                                            this.setState(() =>
                                                                selected_themes
                                                                    .add(selected
                                                                        .toString()));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Icon(Icons.add,
                                                              size: 25),
                                                        ),
                                                        labelText: "Add Tag",
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
                                                        "Select tags from below list"),
                                                    Column(
                                                      children: model.tags
                                                          .map((item) {
                                                        return InkWell(
                                                          onTap: () {
                                                            this.setState(() =>
                                                                selected_themes
                                                                    .add(item
                                                                        .toString()));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      new Text(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          value: offline,
                                          onChanged: (value) {
                                            if (offline == false) {
                                              setState(() {
                                                offline = true;
                                                online = false;
                                                event_mode = "Offline";
                                              });
                                            }
                                            //toggleCheckbox(value);
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
                                          hoverColor:
                                              Theme.of(context).primaryColor,
                                          focusColor:
                                              Theme.of(context).primaryColor,
                                          value: online,
                                          onChanged: (value) {
                                            if (online == false) {
                                              setState(() {
                                                online = true;
                                                offline = false;
                                                event_mode = "Online";
                                              });
                                            }
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
                            offline
                                ? CardPage.body(
                                    title: "Venue",
                                    body: RowLayout(children: <Widget>[
                                      FormField(
                                        builder: (FormFieldState state) {
                                          return InputDecorator(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Venue Type"),
                                            child:
                                                new DropdownButtonHideUnderline(
                                              child: new DropdownButton(
                                                hint: Text("Select Venue Type"),
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
                                      if (!_venueType.isNullOrEmpty()) ...[
                                        TextFormField(
                                          controller: _venueController,
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
                                              hintText: _venueType == "College"
                                                  ? "Room No,Building,College Name"
                                                  : "Room No,Building,Address",
                                              border: OutlineInputBorder(),
                                              labelText: "Venue"),
                                          maxLines: 5,
                                        ),
                                      ],
                                    ]),
                                  )
                                : online
                                    ? CardPage.body(
                                        title: "Platform",
                                        body: RowLayout(children: <Widget>[
                                          TextFormField(
                                            onSaved: (e) => e,
                                            controller:
                                                _platform_detailsController,
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
                                                labelText: "Details"),
                                            maxLines: 3,
                                          ),
                                        ]),
                                      )
                                    : Container(),
                            CardPage.body(
                              title: "Payment",
                              body: RowLayout(children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          value: free,
                                          onChanged: (value) {
                                            if (free == false) {
                                              setState(() {
                                                free = true;
                                                paid = false;
                                                payment_type = "Free";
                                              });
                                            }
                                            //toggleCheckbox(value);
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
                                          hoverColor:
                                              Theme.of(context).primaryColor,
                                          focusColor:
                                              Theme.of(context).primaryColor,
                                          value: paid,
                                          onChanged: (value) {
                                            if (paid == false) {
                                              setState(() {
                                                paid = true;
                                                free = false;
                                                payment_type = "Paid";
                                              });
                                            }
                                            //toggleCheckbox(value);
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
                                paid
                                    ? TextFormField(
                                        onSaved: (e) => e,
                                        controller: _registration_feeController,
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
                                            labelText:
                                                "Registration Fee(in Rs)"),
                                        maxLines: 1,
                                      )
                                    : Container(),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            CardPage.body(
                              title: "Date and Time Details",
                              body: RowLayout(
                                children: <Widget>[
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Registration Ends At",
                                      hintText: 'Registration Ends At',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    dateMask: 'd MMMM, yyyy - hh:mm a',
                                    controller: _reg_last_dateController,
                                    //initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    use24HourFormat: false,
                                    onChanged: (value) {
                                      if (DateTime.parse(value).isAfter(
                                          DateTime.parse(
                                              _finish_timeController.text))) {
                                        setState(() {
                                          // _reg_last_dateController.clear();
                                        });

                                        alertDialog(
                                            context,
                                            "Registration Ends At",
                                            "Registration end time should be before end time");
                                      }
                                    },
                                  ),
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Starts At',
                                      hintText: 'Starts At',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    dateMask: 'd MMMM, yyyy - hh:mm a',
                                    controller: _start_timeController,
                                    //initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    use24HourFormat: false,
                                    onChanged: (value) {
                                      if (DateTime.parse(value).isAfter(
                                          DateTime.parse(
                                              _finish_timeController.text))) {
                                        setState(() {
                                          //_start_timeController.clear();
                                        });

                                        alertDialog(context, "Starts At",
                                            "Start time should be before end time ");
                                      }
                                    },
                                  ),
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Ends At',
                                      hintText: 'Ends At',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    dateMask: 'd MMMM, yyyy - hh:mm a',
                                    controller: _finish_timeController,
                                    //initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    use24HourFormat: false,
                                    onChanged: (value) {
                                      if ((DateTime.parse(value).isBefore(
                                              DateTime.parse(
                                                  _start_timeController
                                                      .text))) ||
                                          (DateTime.parse(value).isBefore(
                                              DateTime.parse(
                                                  _reg_last_dateController
                                                      .text)))) {
                                        setState(() {
                                          //_finish_timeController.clear();
                                        });

                                        alertDialog(context, "Ends At",
                                            "End time should be after start time and registration end time");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CardPage.body(
                              body: RowLayout(children: <Widget>[
                                Text(
                                  'Event Registration Mode',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          value: link,
                                          onChanged: (value) {
                                            if (link == false) {
                                              setState(() {
                                                this.setState(
                                                    () => reg_mode = "link");
                                                link = true;
                                                form = false;
                                              });
                                            }
                                            //toggleCheckbox(value);
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
                                          tristate: false,
                                        ),
                                      ),
                                      Text(
                                        'Link',
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
                                          value: form,
                                          onChanged: (value) {
                                            if (form == false) {
                                              setState(() {
                                                this.setState(
                                                    () => reg_mode = "form");
                                                form = true;
                                                link = false;
                                              });
                                            }
                                            //toggleCheckbox(value);
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
                                          tristate: false,
                                        ),
                                      ),
                                      Text(
                                        'Create Form',
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
                            link
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
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.content_paste,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                            border: OutlineInputBorder(),
                                            labelText: "Registration Link"),
                                        maxLines: 5,
                                      ),
                                    ]),
                                  )
                                : Container(),
                            form
                                ? CardPage.body(
                                    title: "Event Registration Form",
                                    body: RowLayout(children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                      ),
                                      Text(
                                        reg_form.isNotEmpty
                                            ? 'Registartion Form Created'
                                            : 'Registartion Form Not Yet Created',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .color
                                                .withOpacity(0.9)),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var route = new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                //////////////////////////////////////////////////////////////////
                                                new CreateRegistrationForm(
                                              get_form: reg_form,
                                              form_fields: (List form_fields1) {
                                                setState(() {
                                                  reg_form.clear();
                                                });
                                                for (var item in form_fields1) {
                                                  //print(item);

                                                  var data = json.decode(item);
                                                  print(data);
                                                  print(data['title']);
                                                  print(data['field']);
                                                  print(data['options']);
                                                  this.setState(
                                                      () => reg_form.add(data));
                                                }
                                                print("below is your form");
                                                print(reg_form);
                                              },
                                            ),
                                            //////////////////////////////////////////////////////////////////////
                                          );
                                          Navigator.of(context).push(route);
                                        },
                                        child: Container(
                                          height: 40.0,
                                          width: 170.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .color,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.edit, size: 25),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                AutoSizeText(
                                                  reg_form.isNotEmpty
                                                      ? "Your Form"
                                                      : "Create Form",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                : Container(),
                            Container(
                                width: 200,
                                height: 50,
                                color: Theme.of(context).cardColor,
                                margin: EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                    color: Theme.of(context).cardColor,
                                    child: AutoSizeText(
                                      'Post Event',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (_imageFile == null) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text("Post Event"),
                                              content: new Text(
                                                  "Event Poster can not be empty"),
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
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        post_event();
                                      }
                                    })),
                          ],
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////////////
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
