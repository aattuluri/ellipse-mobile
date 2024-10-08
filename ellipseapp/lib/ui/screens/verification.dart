import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class OtpPageEmailVerify extends StatefulWidget {
  final String email, type;
  OtpPageEmailVerify(this.email, this.type);
  @override
  OtpPageEmailVerifyState createState() => OtpPageEmailVerifyState();
}

class OtpPageEmailVerifyState extends State<OtpPageEmailVerify>
    with TickerProviderStateMixin {
  bool isLoading = false;
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();

  TextEditingController currController = new TextEditingController();
  void loadingTrue() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingFalse() {
    setState(() {
      isLoading = false;
    });
  }

  void matchOtp_reset_password() async {
    setState(() {
      isLoading = true;
    });
    String otp = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text;

    print(otp);
    var response = await httpPostWithoutHeaders(
      '${Url.URL}/api/users/emailverified_forgot_password?otp=$otp',
      {'email': '${widget.email}', 'otp': '$otp'},
    );
    if (response.statusCode == 200) {
      var route = new MaterialPageRoute(
          builder: (BuildContext context) => ResetPassword("enter_password"));
      Navigator.of(context).push(route);
      flutterToast(
          context, 'OTP Verification Successful', 2, ToastGravity.CENTER);
      setState(() {
        isLoading = false;
      });
    } else {
      messageDialog(context, 'Incorrect OTP');
      setState(() {
        isLoading = false;
      });
    }
  }

  void matchOtp_email_verify() async {
    String otp = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text;
    print(otp);
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/users/emailverified',
      jsonEncode(<dynamic, dynamic>{'email': '$prefEmail', 'otp': '$otp'}),
    );
    if (response.statusCode == 300) {
      Navigator.pushNamed(context, Routes.initialization);
    } else if (response.statusCode == 404) {
      flutterToast(context, 'Incorrect OTP', 2, ToastGravity.CENTER);
    }
  }

  send_otp() async {
    var response1 = await httpPostWithHeaders(
      '${Url.URL}/api/users/emailverify?email=${widget.email}',
      jsonEncode(<dynamic, dynamic>{
        "email": "",
      }),
    );
    if (response1.statusCode == 200) {
      print("sent otp to your mail");
    } else {
      print(response1.body);
    }
  }

  @override
  void initState() {
    loadPref();

    super.initState();
    currController = controller1;
    send_otp();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
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
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return isLoading
        ? LoaderCircular('Loading')
        : SafeArea(
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
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () async {
                      resetPref();
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
                            Column(
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
                            ),
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
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
                                      Text(
                                        "Re-send OTP to Email",
                                        style: TextStyle(fontSize: 19.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Click here to Re-send OTP to Email",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                        flex: 60,
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GridView.count(
                                crossAxisCount: 6,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                children: List<Container>.generate(
                                    6,
                                    (int index) =>
                                        Container(child: widgetList[index]))),
                          ]),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 10.0,
                                    right: 5.0,
                                    bottom: 0.0),
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
                                    left: 5.0,
                                    top: 7.0,
                                    right: 5.0,
                                    bottom: 0.0),
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
                                    left: 5.0,
                                    top: 7.0,
                                    right: 5.0,
                                    bottom: 0.0),
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
                                    left: 5.0,
                                    top: 7.0,
                                    right: 5.0,
                                    bottom: 0.0),
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
                                        if (widget.type ==
                                            "email_verification") {
                                          matchOtp_email_verify();
                                        } else if (widget.type ==
                                            "reset_password") {
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
    setState(() {
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
        currController = controller4;
      }
    });
  }

  void deleteText() {
    setState(() {
      if (currController == controller1) {
        controller1.text = "";
        currController = controller1;
      } else if (currController == controller2) {
        controller2.text = "";
        currController = controller1;
      } else if (currController == controller3) {
        controller3.text = "";
        currController = controller2;
      } else if (currController == controller4) {
        controller4.text = "";
        currController = controller3;
      }
    });
  }
}

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  bool isLoading = false;
  String _college;
  String image_url;
  var _designationController = new TextEditingController();
  var _bioController = new TextEditingController();
  var _collegeNameController = new TextEditingController();
  bool male = false;
  bool female = false;
  next() async {
    String gender = male
        ? "Male"
        : female
            ? "Female"
            : null;
    if (prefId.isNullOrEmpty() ||
        _college.isNullOrEmpty() ||
        _bioController.isNullOrEmpty() ||
        _designationController.isNullOrEmpty() ||
        gender.isNullOrEmpty()) {
      messageDialog(context, "Required fields can not be empty");
    } else {
      setState(() {
        isLoading = true;
      });
      var response = await httpPostWithHeaders(
        '${Url.URL}/api/users/userdetails',
        jsonEncode(<dynamic, dynamic>{
          'id': "$prefId",
          "college_id": "$_college",
          'bio': _bioController.text,
          'designation': _designationController.text,
          'gender': gender
        }),
      );

      if (response.statusCode == 200) {
        if (!_imageFile.isNullOrEmpty()) {
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
              redirect();
              print("Image Uploaded");
            }
          } catch (e) {
            print(e);
            return null;
          }
          redirect();
        }
        redirect();
      } else {
        redirect();
        print(response.body);
      }
    }
  }

  redirect() async {
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamed(context, Routes.initialization);
  }

  @override
  // To store the file provided by the image_picker
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: source, imageQuality: 70);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
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

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Consumer<DataRepository>(
          builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text("Fill Profile"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () async {
                  resetPref();
                  Navigator.pushNamed(context, Routes.signin);
                },
              ),
            ),
            body: isLoading
                ? LoaderCircular('Updating')
                : SingleChildScrollView(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          "Profile Picture(Optional)",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          _imageFile == null
                                              ? Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  child: NoProfilePic(),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 3.0,
                                                          offset:
                                                              Offset(0, 4.0),
                                                          color:
                                                              Colors.black38),
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
                                                          offset:
                                                              Offset(0, 4.0),
                                                          color:
                                                              Colors.black38),
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
                                              color: Colors.grey,
                                              fontSize: 16.0),
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
                                                          const BorderRadius
                                                                  .all(
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                          const BorderRadius
                                                                  .all(
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                              color: Colors.grey,
                                              fontSize: 16.0),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              margin: const EdgeInsets.only(
                                                  left: 00.0, right: 10.0),
                                            ),
                                            new Expanded(
                                              child: TextFormField(
                                                  controller:
                                                      _collegeNameController,
                                                  readOnly: true,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color,
                                                  ),
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .arrow_drop_down_sharp),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Select College'),
                                                  onTap: () {
                                                    showDropdownSearchDialog(
                                                        context: context,
                                                        items:
                                                            model.collegesData,
                                                        addEnabled: false,
                                                        onChanged: (String key,
                                                            String value) {
                                                          setState(() {
                                                            _college =
                                                                key.toString();
                                                            _collegeNameController =
                                                                TextEditingController(
                                                                    text:
                                                                        value);
                                                          });
                                                        });
                                                  }),
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
                                              color: Colors.grey,
                                              fontSize: 16.0),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              margin: const EdgeInsets.only(
                                                  left: 00.0, right: 10.0),
                                            ),
                                            new Expanded(
                                              child: TextFormField(
                                                  controller:
                                                      _designationController,
                                                  readOnly: true,
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
                                                      suffixIcon: Icon(Icons
                                                          .arrow_drop_down_sharp),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Select Designation'),
                                                  onTap: () {
                                                    showDropdownSearchDialog(
                                                        context: context,
                                                        items: model
                                                            .designationsData,
                                                        addEnabled: false,
                                                        onChanged: (String key,
                                                            String value) {
                                                          setState(() {
                                                            _designationController =
                                                                TextEditingController(
                                                                    text:
                                                                        value);
                                                          });
                                                        });
                                                  }),
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
                                              color: Colors.grey,
                                              fontSize: 16.0),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              margin: const EdgeInsets.only(
                                                  left: 00.0, right: 10.0),
                                            ),
                                            new Expanded(
                                              child: TextFormField(
                                                maxLines: 5,
                                                controller: _bioController,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
      ),
    );
  }
}
