import 'dart:convert';
import 'package:row_collection/row_collection.dart';
import 'package:rxdart/subjects.dart';
import '../../util/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../widgets/index.dart';
import '../../util/index.dart';

double ourMap(v, start1, stop1, start2, stop2) {
  return (v - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}

class PostEvent extends StatefulWidget {
  @override
  _PostEventState createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent>
    with SingleTickerProviderStateMixin {
  final _key = new GlobalKey<FormState>();
  final List<String> _eventtypes = ["Technical", "Cultural"];
  String id = "", token = "";
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
    setState(() {
      id = preferences.getString("id");
      token = preferences.getString("token");
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
    getPref();
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

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_imageFile != null) {
      // If image_url is picked by the user then show a upload btn

      btnWidget = Container(
        width: 200,
        height: 50,
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text(
            'Post Event',
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            if (isChecked1) {
              setState(() {
                event_mode = "Offline";
              });
            }
            if (isChecked2) {
              setState(() {
                event_mode = "Online";
              });
            }
            if (isChecked5) {
              setState(() {
                o_allowed = "Yes";
              });
            }
            if (isChecked6) {
              setState(() {
                o_allowed = "No";
              });
            }
            if (isChecked3) {
              setState(() {
                payment_type = "Free";
              });
            }
            if (isChecked4) {
              setState(() {
                payment_type = "Paid";
              });
            }
            String image_url = base64Encode(_imageFile.readAsBytesSync());
            add_event(
              image_url,
              id,
              _college,
              _nameController.text.trim(),
              _descriptionController.text.trim(),
              event_type,
              event_mode,
              payment_type,
              _venueController.text.trim(),
              _registration_feeController.text.trim(),
              _platform_linkController.text.trim(),
              o_allowed,
              _start_timeController.text.trim(),
              _finish_timeController.text.trim(),
              _reg_last_dateController.text.trim(),
              _reg_linkController.text.trim(),
            );

            Navigator.pushNamed(context, Routes.start);
          },
          color: Theme.of(context).cardColor,
          textColor: Theme.of(context).textTheme.caption.color,
        ),
      );
    } else {}
    return btnWidget;
  }

  void add_event(
      String image_url,
      String user_id,
      String _college,
      String _nameController,
      String _descriptionController,
      String event_type,
      String event_mode,
      String payment_type,
      String _venueController,
      String _registration_feeController,
      String _platform_linkController,
      String o_allowed,
      String _start_timeController,
      String _finish_timeController,
      String _reg_last_dateController,
      String _reg_linkController) async {
    String myUrl = "${Url.URL}/events";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json'
    }, body: {
      "image_url": "$image_url",
      "user_id": "$user_id",
      "college_id": "$_college",
      "name": "$_nameController",
      "description": "$_descriptionController",
      "event_type": "$event_type",
      "event_mode": "$event_mode",
      "payment_type": "$payment_type",
      "venue": "$_venueController",
      "registration_fee": "$_registration_feeController",
      "platform_link": "$_platform_linkController",
      "o_allowed": "$o_allowed",
      "start_time": "$_start_timeController",
      "finish_time": "$_finish_timeController",
      "reg_last_date": "$_reg_last_dateController",
      "reg_link": "$_reg_linkController"
    });
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
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
              child: Form(
                key: _key,
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
                            CardPage1.body(
                              title: "Event Poster",
                              body: RowLayout(
                                children: <Widget>[
                                  _imageFile == null
                                      ? Text(
                                          'Please select an image',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color),
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
                                        top: 40.0, left: 10.0, right: 10.0),
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
                            CardPage1.body(
                              title: "Event Details",
                              body: RowLayout(children: <Widget>[
                                TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
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
                                        child: Expanded(
                                          child: new DropdownButton(
                                            hint: Text("Select Event Type"),
                                            isExpanded: true,
                                            value: event_type,
                                            isDense: true,
                                            items: _eventtypes
                                                .map(
                                                    (value) => DropdownMenuItem(
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
                                            hint: Text("Select College"),
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
                                          value: isChecked5,
                                          onChanged: (value) {
                                            if (isChecked5 == false) {
                                              setState(() {
                                                isChecked5 = true;
                                                isChecked6 = false;
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
                                          value: isChecked6,
                                          onChanged: (value) {
                                            if (isChecked6 == false) {
                                              setState(() {
                                                isChecked6 = true;
                                                isChecked5 = false;
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
                            CardPage1.body(
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
                            isChecked1
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
                                        cursorColor: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
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
                                            controller:
                                                _platform_linkController,
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
                                isChecked4
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
                            CardPage1.body(
                              title: "Date and Time Details",
                              body: RowLayout(
                                children: <Widget>[
                                  DateTimeField(
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
                                      hintText: 'Start time',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
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
                                    onShowPicker:
                                        (context, currentValue) async {
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
                                        return DateTimeField.combine(
                                            date, time);
                                      } else {
                                        return currentValue;
                                      }
                                    },
                                  ),
                                  DateTimeField(
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
                                      hintText: 'Finish time',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
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
                                    onShowPicker:
                                        (context, currentValue) async {
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
                                        return DateTimeField.combine(
                                            date, time);
                                      } else {
                                        return currentValue;
                                      }
                                    },
                                  ),
                                  DateTimeField(
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
                                      hintText: 'Registration last date',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color,
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
                                    onShowPicker:
                                        (context, currentValue) async {
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
                                        return DateTimeField.combine(
                                            date, time);
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
                            ),
                            _buildUploadBtn(),
                          ],
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////////////////////////
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
