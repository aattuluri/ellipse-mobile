import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../util/routes.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class PostEvent extends StatefulWidget {
  @override
  _PostEventState createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isLoading = false;
  List reg_form = [];
  final List<String> _venueTypes = ["College", "Other"];
  List fetched_form;
  bool hasRounds = false;
  List rounds = [];
  List<RoundModel> roundsUi = [];
  Map<String, dynamic> colleges = {};
  List<String> selected_requirements = [];
  List<Map<String, dynamic>> prizes = [];
  List<String> selected_themes = [];
  bool isUploading = false;
  bool offline = false;
  bool online = false;
  bool free = false;
  bool paid = false;
  bool o_allowed = false;
  bool team = false;
  bool link = false;
  bool form = false;
  String event_mode;
  String payment_type;
  String _college;
  String _venueType;
  String theme;
  String reg_mode = "";

  final _picker = ImagePicker();

  @override
  void initState() {
    loadPref();
    setState(() {
      _college = prefCollegeId;
      _collegeNameController.text = prefCollegeName;
    });
    print('_college');
    print(_college);
    tabController = new TabController(
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // To store the file provided by the image_picker
  File _imageFile;

  // To track the file uploading state
  void _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 70);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  var _nameController = new TextEditingController();

  var _aboutController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _eventTypeController = new TextEditingController();
  var _start_timeController = new TextEditingController();
  var _finish_timeController = new TextEditingController();
  var _reg_last_dateController = new TextEditingController();
  var _reg_linkController = new TextEditingController();
  var _registration_feeController = new TextEditingController();
  var _collegeNameController = new TextEditingController();
  var _venueController = new TextEditingController();
  var _platform_detailsController = new TextEditingController();
  var _minTeamSizeController = new TextEditingController();
  var _maxTeamSizeController = new TextEditingController();
  var _rulesController = new TextEditingController();
  var _themesController = new TextEditingController();

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

/*
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
*/
  post_event() async {
    if (_imageFile == null ||
        _nameController.text.isNullOrEmpty() ||
        _descriptionController.text.isNullOrEmpty() ||
        _aboutController.text.isNullOrEmpty() ||
        _eventTypeController.isNullOrEmpty() ||
        _collegeNameController.isNullOrEmpty() ||
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
        isUploading = true;
      });
      var response = await httpPostWithHeaders(
        '${Url.URL}/api/events',
        jsonEncode(<String, dynamic>{
          "poster_url": null,
          "user_id": "$prefId",
          "college_id": "$_college",
          "name": _nameController.text,
          "description": _descriptionController.text,
          "about": _aboutController.text,
          "event_type": _eventTypeController.text,
          "event_mode": "$event_mode",
          "fee_type": "$payment_type",
          "venue": _venueController.text,
          "venue_type": _venueType.isNullOrEmpty() ? "" : _venueType,
          "fee": _registration_feeController.text.toString(),
          "requirements": selected_requirements,
          "tags": selected_themes,
          "platform_details": _platform_detailsController.text,
          "o_allowed": o_allowed,
          "isTeamed": team,
          "rounds": rounds,
          "prizes": prizes,
          "themes": _themesController.text,
          "team_size": <String, dynamic>{
            'min_team_size': _minTeamSizeController.text,
            'max_team_size': _maxTeamSizeController.text
          },
          "start_time":
              DateTime.parse(_start_timeController.text).toUtc().toString(),
          "finish_time":
              DateTime.parse(_finish_timeController.text).toUtc().toString(),
          "registration_end_time":
              DateTime.parse(_reg_last_dateController.text).toUtc().toString(),
          "reg_link": _reg_linkController.text,
          "rules": _rulesController.text,
          "reg_mode": reg_mode,
          "reg_fields": reg_form
        }),
      );

      var jsonResponse = json.decode(response.body);
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
            context.read<EventsRepository>().init();
            Navigator.pushNamed(
              context,
              Routes.start,
              arguments: {'currentTab': 0},
            );
            setState(() {
              isUploading = false;
            });
            messageDialog(context, 'Event Posted successfully');
            print("Image Uploaded");
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  addPrize() async {
    String title, price, description;
    showDialog(
      context: context,
      builder: (context) => RoundDialog(
        title: "Add Prize",
        children: <Widget>[
          RowLayout(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                ),
                cursorColor: Theme.of(context).textTheme.caption.color,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Title"),
                onChanged: (value) {
                  title = value;
                },
                maxLines: 1,
              ),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                ),
                cursorColor: Theme.of(context).textTheme.caption.color,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Price"),
                onChanged: (value) {
                  price = value;
                },
                maxLines: 1,
              ),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                ),
                cursorColor: Theme.of(context).textTheme.caption.color,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Description"),
                onChanged: (value) {
                  description = value;
                },
                maxLines: 2,
              ),
              OutlinedIconButton(
                text: 'Add',
                icon: Icons.save,
                onTap: () {
                  setState(() {
                    prizes.add(<String, dynamic>{
                      'title': title,
                      'prize': price,
                      'desc': description
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isUploading) {
      return LoaderCircular("Uploading");
    } else if (isLoading) {
      return LoaderCircular("Loading");
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
            actions: [
              FlatButton(
                color: Theme.of(context).cardColor,
                child: Text(
                  'POST\nEVENT',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_imageFile == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("Post Event"),
                          content: new Text("Event Poster can not be empty"),
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
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    post_event();
                  }
                },
              ),
            ],
            bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    text: 'Step-1',
                  ),
                  Tab(
                    text: 'Step-2',
                  ),
                  Tab(
                    text: 'Step-3',
                  ),
                  Tab(
                    text: 'Step-4',
                  ),
                  Tab(
                    text: 'Step-5',
                  )
                ]),
            centerTitle: true,
          ),
          body: TabBarView(
            controller: tabController,
            // scrollDirection: Axis.horizontal,
            //onPageChanged: (page) => currentPageSink.add(page),
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
                                    width: MediaQuery.of(context).size.width,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 10.0, right: 10.0),
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
                      CardPage.body(
                        title: "Event",
                        body: RowLayout(
                          children: <Widget>[
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
                              controller: _descriptionController,
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Description"),
                              maxLines: 6,
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
                              color: Theme.of(context).textTheme.caption.color,
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
                              controller: _eventTypeController,
                              readOnly: true,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                  border: OutlineInputBorder(),
                                  labelText: "Event Type",
                                  hintText: 'Select Event Type'),
                              onTap: () {
                                showDropdownSearchDialog(
                                    context: context,
                                    items: model.eventTypesData,
                                    addEnabled: false,
                                    onChanged: (String key, String value) {
                                      setState(() {
                                        _eventTypeController =
                                            TextEditingController(text: value);
                                      });
                                    });
                              }),
                          TextFormField(
                              controller: _collegeNameController,
                              readOnly: true,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                  border: OutlineInputBorder(),
                                  labelText: "College",
                                  hintText: 'Select College'),
                              onTap: () {
                                showDropdownSearchDialog(
                                    context: context,
                                    items: model.collegesData,
                                    addEnabled: false,
                                    onChanged: (String key, String value) {
                                      setState(() {
                                        _college = key.toString();
                                        _collegeNameController =
                                            TextEditingController(text: value);
                                      });
                                    });
                              }),
                        ]),
                      ),
                      CardPage.body(
                        body: RowLayout(children: <Widget>[
                          Text(
                            'Participation',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.9)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: <Widget>[
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
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
                                  'Open for all',
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
                                AutoSizeText(
                                  'Only for \n' + prefCollegeName,
                                  minFontSize: 5,
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
                        body: RowLayout(children: <Widget>[
                          Text(
                            'Participation',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .color
                                    .withOpacity(0.9)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: <Widget>[
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
                                    value: !team,
                                    onChanged: (value) {
                                      setState(() {
                                        team = false;
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
                                  'Individual',
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
                                    value: team,
                                    onChanged: (value) {
                                      setState(() {
                                        team = true;
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
                                  'Team',
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
                          if (team) ...[
                            RowLayout(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  controller: _minTeamSizeController,
                                  cursorColor:
                                      Theme.of(context).textTheme.caption.color,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Minimum team size"),
                                  maxLines: 1,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  controller: _maxTeamSizeController,
                                  cursorColor:
                                      Theme.of(context).textTheme.caption.color,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Maximum team size"),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ]),
                      ),
                      CardPage.body(
                        title: "Prerequisites",
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
                                  showDropdownSearchDialog(
                                      context: context,
                                      items: model.requirementsData,
                                      addEnabled: true,
                                      onChanged: (String key, String value) {
                                        this.setState(() =>
                                            selected_requirements
                                                .add(value.toString()));
                                      });
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
                                  showDropdownSearchDialog(
                                      context: context,
                                      items: model.tagsData,
                                      addEnabled: true,
                                      onChanged: (String key, String value) {
                                        this.setState(() => selected_themes
                                            .add(value.toString()));
                                      });
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
                        title: "Prizes",
                        body: RowLayout(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                            ),
                            for (var i = 0; i < prizes.length; i++) ...[
                              ListTile(
                                title: Text(prizes[i]['title']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Amount : " + prizes[i]['prize']),
                                    Text(prizes[i]['desc']),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      prizes.removeAt(i);
                                    });
                                  },
                                ),
                              ),
                            ],
                            InkWell(
                                onTap: () {
                                  addPrize();
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
                        title: "Themes",
                        body: RowLayout(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color:
                                Theme.of(context).textTheme.caption.color,
                              ),
                              controller: _themesController,
                              cursorColor:
                              Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Themes"),
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                      CardPage.body(
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
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
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
                      CardPage.body(
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
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
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
                                      child: new DropdownButtonHideUnderline(
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
                                      controller: _platform_detailsController,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: <Widget>[
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
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
                                    hoverColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
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
                                OutlinedIconButton(
                                  text: reg_form.isNotEmpty
                                      ? "Your Form"
                                      : "Create Form",
                                  icon: Icons.format_align_justify,
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
                                            var data = json.decode(item);
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
                                ),
                              ]),
                            )
                          : Container(),
                      if (form) ...[
                        CardPage.body(
                          title: "Rounds",
                          body: RowLayout(children: <Widget>[
                            Row(children: <Widget>[
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  hoverColor: Theme.of(context).primaryColor,
                                  focusColor: Theme.of(context).primaryColor,
                                  value: hasRounds,
                                  onChanged: (value) {
                                    setState(() {
                                      hasRounds = value;
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
                                'Event has Rounds',
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
                            for (var i = 0; i < roundsUi.length; i++) ...[
                              ListTile(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventRounds(
                                              type: 'edit',
                                              data: roundsUi[i],
                                              title:
                                                  roundsUi[i].title.toString(),
                                              callBack: (RoundModel round,
                                                  Map<String, dynamic> data) {
                                                setState(() {
                                                  rounds[i] = data;
                                                });
                                                setState(() {
                                                  roundsUi[i] = round;
                                                });
                                              },
                                            )),
                                  );
                                },
                                title: Text(roundsUi[i].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(roundsUi[i].description),
                                    Text('StartTime : ' +
                                        roundsUi[i].startDate.toString()),
                                    Text('EndTime : ' +
                                        roundsUi[i].endDate.toString()),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      roundsUi.remove(roundsUi[i]);
                                      rounds.removeAt(i);
                                    });
                                  },
                                ),
                              ),
                            ],
                            if (hasRounds) ...[
                              OutlinedIconButton(
                                text: 'Add Round ' +
                                    ((rounds.length) + 1).toString(),
                                icon: Icons.add,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventRounds(
                                              type: 'new',
                                              title: ((rounds.length) + 1)
                                                  .toString(),
                                              callBack: (RoundModel round,
                                                  Map<String, dynamic> data) {
                                                setState(() {
                                                  rounds.add(data);
                                                });
                                                setState(() {
                                                  roundsUi.add(round);
                                                });
                                              },
                                            )),
                                  );
                                },
                              ),
                            ]
                          ]),
                        ),
                      ],
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
                        title: "Rules and regulations",
                        body: RowLayout(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              controller: _rulesController,
                              cursorColor:
                                  Theme.of(context).textTheme.caption.color,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Rules"),
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
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
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                  messageDialog(context,
                                      'Registration end time should be before end time');
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
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                  messageDialog(context,
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
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                                            _start_timeController.text))) ||
                                    (DateTime.parse(value).isBefore(
                                        DateTime.parse(
                                            _reg_last_dateController.text)))) {
                                  setState(() {
                                    //_finish_timeController.clear();
                                  });
                                  messageDialog(context,
                                      "End time should be after start time and registration end time");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Acceptance('By posting the event,I accept the ', false),
                       RButton('Post Event', 15, () {
                         if (_imageFile == null) {
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: new Text("Post Event"),
                                 content: new Text("Event Poster can not be empty"),
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
                           SystemChannels.textInput.invokeMethod('TextInput.hide');
                           post_event();
                         }
                       }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
