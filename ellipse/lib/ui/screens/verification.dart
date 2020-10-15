import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constants.dart' as Constants;
import '../../util/index.dart';
import '../screens/index.dart';

class OtpPageEmailVerify extends StatefulWidget {
  final String email, type;
  OtpPageEmailVerify(this.email, this.type);
  @override
  OtpPageEmailVerifyState createState() => OtpPageEmailVerifyState();
}

class OtpPageEmailVerifyState extends State<OtpPageEmailVerify>
    with TickerProviderStateMixin {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();

  TextEditingController currController = new TextEditingController();

  //String token = "", id = "", email = "", verification_email = "";
  bool email_sent = false;

  /* getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
      id = preferences.getString("id");
      token = preferences.getString("token");
    });
  }*/

  void matchOtp_reset_password() async {
    String otp = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text;
    print(otp);
    http.Response response = await http.post(
      '${Url.URL}/api/users/emailverified_forgot_password?otp=$otp',
      body: {'email': '${widget.email}', 'otp': '$otp'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var route = new MaterialPageRoute(
          builder: (BuildContext context) => ResetPassword("enter_password"));
      Navigator.of(context).push(route);
    } else {
      print(response.body);
    }
  }

  void matchOtp_email_verify() async {
    String otp = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text;
    print(otp);
    http.Response response = await http.post(
      '${Url.URL}/api/users/emailverified',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefToken'
      },
      body:
          jsonEncode(<dynamic, dynamic>{'email': '$prefEmail', 'otp': '$otp'}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 300) {
      Navigator.pushNamed(context, Routes.initialization);
    } else {
      print(response.body);
    }
  }

  send_otp() async {
    http.Response response1 = await http.post(
      '${Url.URL}/api/users/emailverify?email=${widget.email}',
      body: jsonEncode(<dynamic, dynamic>{
        "email": "",
      }),
    );
    print('Response status: ${response1.statusCode}');
    print('Response body: ${response1.body}');

    if (response1.statusCode == 200) {
      print("sent otp to your mail");
      setState(() {
        email_sent = true;
      });
    } else {
      print(response1.body);
    }
  }

  @override
  void initState() {
    loadPref();
    //getPref();
    super.initState();
    currController = controller1;
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                border: new Border.all(
                    width: 1.0,
                    color: Theme.of(context).textTheme.caption.color),
                borderRadius: new BorderRadius.circular(4.0)),
            child: new TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Theme.of(context).textTheme.caption.color),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Theme.of(context).textTheme.caption.color),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Theme.of(context).textTheme.caption.color),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Theme.of(context).textTheme.caption.color),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller5,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border.all(
                  width: 1.0, color: Theme.of(context).textTheme.caption.color),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller6,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text("OTP Verification"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                setState(() {
                  preferences.setString("token", "");
                  preferences.setString("id", "");
                  preferences.setString("email", "");
                  preferences.setBool(Constants.LOGGED_IN, false);
                });
                Navigator.pushNamed(context, Routes.signin);
              },
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      email_sent
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Verify your OTP",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 4.0, right: 16.0),
                                  child: Text(
                                    "Please type the verification code sent to your mail",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 2.0, right: 30.0),
                                  child: Text(
                                    widget.email,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          send_otp();
                        },
                        child: Container(
                          height: 40.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.send, size: 25),
                                SizedBox(
                                  width: 10,
                                ),
                                email_sent
                                    ? Text(
                                        "Re-send OTP to Email",
                                        style: TextStyle(fontSize: 19.0),
                                      )
                                    : Text(
                                        "Send OTP to Email",
                                        style: TextStyle(fontSize: 19.0),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 60,
                ),
                Flexible(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GridView.count(
                            crossAxisCount: 8,
                            mainAxisSpacing: 10.0,
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            children: List<Container>.generate(
                                8,
                                (int index) =>
                                    Container(child: widgetList[index]))),
                      ]),
                  flex: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 10.0, right: 5.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("1");
                                },
                                child: Text("1",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("2");
                                },
                                child: Text("2",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("3");
                                },
                                child: Text("3",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("4");
                                },
                                child: Text("4",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("5");
                                },
                                child: Text("5",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("6");
                                },
                                child: Text("6",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("7");
                                },
                                child: Text("7",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("8");
                                },
                                child: Text("8",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("9");
                                },
                                child: Text("9",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  deleteText();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 35,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("0");
                                },
                                child: Text("0",
                                    style: TextStyle(
                                        fontSize: 37.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (widget.type == "email_verification") {
                                    matchOtp_email_verify();
                                  } else if (widget.type == "reset_password") {
                                    matchOtp_reset_password();
                                  }
                                },
                                child: Icon(
                                  Icons.check_circle_outline,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  flex: 90,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller5;
    }

    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller6;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller5;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }
}

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  bool isLoading = false;
  List data = List();
  String _college;
  String image_url;
  String designation, bio;
  bool male = false;
  bool female = false;
  final List<String> _designations = [
    "Student",
    "Faculty",
    "Club",
    "Institution"
  ];
  next() async {
    String gender = male ? "Male" : female ? "Female" : null;
    if (_imageFile == null ||
        prefId.isNullOrEmpty() ||
        _college.isNullOrEmpty() ||
        bio.isNullOrEmpty() ||
        designation.isNullOrEmpty() ||
        gender.isNullOrEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Profile fill"),
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
        isLoading = true;
      });
      http.Response response = await http.post(
        '${Url.URL}/api/users/userdetails',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefToken'
        },
        body: jsonEncode(<dynamic, dynamic>{
          'id': "$prefId",
          "college_id": "$_college",
          'bio': "$bio",
          'designation': "$designation",
          'gender': gender
        }),
      );
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
            'POST', Uri.parse('${Url.URL}/api/users/uploadimage?id=$prefId'));
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
            Navigator.pushNamed(context, Routes.initialization);
            setState(() {
              _isUploading = false;
            });
            print("Image Uploaded");
          }
        } catch (e) {
          print(e);
          return null;
        }
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(
          context,
          Routes.start,
          arguments: {'current_tab': 0, 'load': true},
        );
      } else {
        print(response.body);
      }
    }
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

  Future<List> getData() async {
    final response = await http.get("${Url.URL}/api/colleges");
    var resBody = json.decode(response.body.toString());
    setState(() {
      data = resBody;
    });
  }

  @override
  void initState() {
    loadPref();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
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
                  "Saving your profile....",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )))
        : SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Profile Picture",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _imageFile == null
                                            ? Container(
                                                height: 150.0,
                                                width: 150.0,
                                                child: Icon(
                                                  Icons.add_a_photo,
                                                  size: 65,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 3.0,
                                                        offset: Offset(0, 4.0),
                                                        color: Colors.black38),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                height: 120.0,
                                                width: 120.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
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
                                        Padding(
                                          padding: EdgeInsets.only(top: 60.0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.add_a_photo,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              _openImagePickerModal(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Gender",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                    onTap: () {
                                                      setState(() {
                                                        male = true;
                                                        female = false;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            male
                                                                ? Icons
                                                                    .check_box
                                                                : Icons
                                                                    .check_box_outline_blank,
                                                            color: male
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .color
                                                                : Colors.grey
                                                                    .withOpacity(
                                                                        0.6),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "Male",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .color),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                    onTap: () {
                                                      setState(() {
                                                        female = true;
                                                        male = false;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            female
                                                                ? Icons
                                                                    .check_box
                                                                : Icons
                                                                    .check_box_outline_blank,
                                                            color: female
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .color
                                                                : Colors.grey
                                                                    .withOpacity(
                                                                        0.6),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "Female",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .color),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "College",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Icon(
                                              Icons.account_balance,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(
                                                left: 00.0, right: 10.0),
                                          ),
                                          new Expanded(
                                            child: FormField(
                                              builder: (FormFieldState state) {
                                                return InputDecorator(
                                                  decoration: InputDecoration(
                                                    hintText: "Select College",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  child:
                                                      new DropdownButtonHideUnderline(
                                                    child: new DropdownButton(
                                                      hint: Text(
                                                          "Select College"),
                                                      isExpanded: true,
                                                      value: _college,
                                                      isDense: true,
                                                      items: data.map((item) {
                                                        return new DropdownMenuItem(
                                                          child: new Text(
                                                            item['name'],
                                                          ),
                                                          value: item['_id']
                                                              .toString(),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _college = newValue;
                                                          state.didChange(
                                                              newValue);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Designation",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Icon(
                                              Icons.accessibility_new,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(
                                                left: 00.0, right: 10.0),
                                          ),
                                          new Expanded(
                                            child: FormField(
                                              builder: (FormFieldState state) {
                                                return InputDecorator(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Select Designation",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  child:
                                                      new DropdownButtonHideUnderline(
                                                    child: new DropdownButton(
                                                      hint: Text(
                                                          "Select Designation"),
                                                      isExpanded: true,
                                                      value: designation,
                                                      isDense: true,
                                                      items: _designations
                                                          .map((value) =>
                                                              DropdownMenuItem(
                                                                child:
                                                                    Text(value),
                                                                value: value,
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          designation =
                                                              newValue;
                                                          state.didChange(
                                                              newValue);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Bio",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Icon(
                                              Icons.account_circle,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(
                                                left: 00.0, right: 10.0),
                                          ),
                                          new Expanded(
                                            child: TextFormField(
                                              maxLines: 5,
                                              onChanged: (value) {
                                                bio = value;
                                              },
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Enter your bio',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        splashColor: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.6),
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color
                                            .withOpacity(0.5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: new Row(
                                            children: <Widget>[
                                              new Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text(
                                                  "CONTINUE",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor),
                                                ),
                                              ),
                                              new Expanded(
                                                child: Container(),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              )
                                            ],
                                          ),
                                        ),
                                        onPressed: () async {
                                          next();
                                          //Navigator.pushNamed(
                                          // context,
                                          // Routes.start,
                                          // arguments: {'currebt_tab': 1},
                                          //);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
