import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';
import '../widgets/index.dart';

class DynamicFormWidget extends StatefulWidget {
  const DynamicFormWidget(
      {Key key,
      @required this.data,
      @required this.title,
      @required this.field,
      @required this.options,
      @required this.req,
      this.readOnly = false,
      this.callBack})
      : super(key: key);
  final dynamic data;
  final String title;
  final String field;
  final List<dynamic> options;
  final bool req;
  final bool readOnly;
  final Function(dynamic) callBack;
  @override
  _DynamicFormWidgetState createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  var controller = new TextEditingController();
  String fieldData;
  List<String> fieldList = [];
  File _file;
  PlatformFile f;
  loadData() async {
    if (!widget.data.toString().isNullOrEmpty()) {
      setState(() {
        switch (widget.field) {
          case "short_text":
            controller = TextEditingController(text: widget.data.toString());
            fieldData = widget.data.toString();
            break;
          case "paragraph":
            controller = TextEditingController(text: widget.data.toString());
            fieldData = widget.data.toString();
            break;
          case "dropdown":
            fieldData = widget.data.toString();
            break;
          case "checkboxes":
            fieldList = widget.data;
            break;
          case "radiobuttons":
            fieldData = widget.data.toString();
            break;
          case "date":
            controller = TextEditingController(text: widget.data.toString());
            fieldData = widget.data.toString();
            break;
          case "link":
            controller = TextEditingController(text: widget.data.toString());
            fieldData = widget.data.toString();
            break;
          default:
            break;
        }
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget req() {
    return widget.req
        ? Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  '* required',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field) {
      case "short_text":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextFormField(
                controller: controller,
                autofocus: false,
                readOnly: widget.readOnly,
                enableInteractiveSelection: true,
                onChanged: (value) {
                  setState(() {
                    fieldData = value;
                  });
                  widget.callBack(fieldData);
                },
                maxLines: 1,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
            req(),
          ],
        );
        break;
      case "paragraph":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextFormField(
                controller: controller,
                readOnly: widget.readOnly,
                autofocus: false,
                enableInteractiveSelection: true,
                onChanged: (value) {
                  setState(() {
                    fieldData = value;
                  });
                  widget.callBack(fieldData);
                },
                maxLines: 5,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
            req(),
          ],
        );
        break;
      case "dropdown":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Event Type"),
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        hint: Text(widget.title),
                        isExpanded: true,
                        value: fieldData,
                        items: widget.options
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (value) {
                          state.didChange(value);
                          setState(() {
                            fieldData = value;
                          });
                          widget.callBack(fieldData);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            req(),
          ],
        );
        break;
      case "checkboxes":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  ListView.builder(
                    itemCount: widget.options.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String clicked = widget.options[index].toString();
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (fieldList.contains("$clicked")) {
                              fieldList.remove("$clicked");
                            } else {
                              fieldList.add("$clicked");
                            }
                          });
                          widget.callBack(fieldList);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                fieldList.contains("$clicked")
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.options[index],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            req(),
          ],
        );
        break;
      case "radiobuttons":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  ListView.builder(
                    itemCount: widget.options.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String clicked = widget.options[index].toString();
                      return InkWell(
                        onTap: () {
                          setState(() {
                            fieldData = '$clicked';
                          });
                          widget.callBack(fieldData);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              fieldData == "$clicked"
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
                                width: 10,
                              ),
                              Text(
                                widget.options[index],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            req(),
          ],
        );
        break;
      case "date":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: DateTimePicker(
                controller: controller,
                readOnly: widget.readOnly,
                type: DateTimePickerType.dateTime,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.title,
                  hintText: widget.title,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontSize: 18.0,
                  ),
                ),
                dateMask: 'd MMMM, yyyy - hh:mm a',
                onChanged: (value) {
                  setState(() {
                    fieldData = value;
                  });
                  widget.callBack(fieldData);
                },
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                use24HourFormat: false,
              ),
            ),
            req(),
          ],
        );
        break;
      case "link":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextField(
                controller: controller,
                readOnly: widget.readOnly,
                autofocus: false,
                onChanged: (value) {
                  setState(() {
                    fieldData = value;
                  });
                  widget.callBack(fieldData);
                },
                maxLines: 2,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
            req(),
          ],
        );
        break;
      case "file":
        return Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title),
              Column(
                children: [
                  if (_file != null && f != null) ...[
                    ListTile(
                        title: Text(f.name),
                        subtitle: Text(f.extension + ' File'),
                        leading: IconButton(
                            icon: Icon(
                              Icons.insert_drive_file,
                            ),
                            onPressed: () async {})),
                  ],
                  if (widget.data != null) ...[
                    RButton("open file",10,(){
                      "${Url.URL}/api/event/registration/get_file?id=${widget.data}".launchUrl;
                    }),
                  ],
                  OutlinedIconButton(
                    text: _file == null && widget.data ==null  ? "Pick an File" : widget.data !=null? "Change File":"Change File",
                    icon: Icons.insert_drive_file_outlined,
                    onTap: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          f = result.files.first;
                        });
                        setState(() {
                          _file = File(result.files.single.path);
                        });
                        widget.callBack(_file);
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                  req(),
                ],
              ),
            ],
          ),
        );
        break;
      default:
        return Container(
          height: 0,
          width: 0,
        );
        break;
    }
  }
}

dynamicFormItemDetails(BuildContext context, String type,
    Function(DynamicFormWidget) callBack) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            AddFormField(context, type, (DynamicFormWidget dfw) {
              callBack(dfw);
            })),
  );
}

class AddFormField extends StatefulWidget {
  final String type;
  final Function(DynamicFormWidget) callBack;
  const AddFormField(BuildContext context, this.type, this.callBack);

  @override
  _AddFormFieldState createState() => _AddFormFieldState();
}

class _AddFormFieldState extends State<AddFormField> {
  String title = "", field = '', option = "";
  bool required = true;
  List<String> data = [];

  @override
  void initState() {
    setState(() {
      field = widget.type;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 4,
          title: Text(
            "Add Field Data",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: field == "short_text" ||
                field == "paragraph" ||
                field == "dropdown" ||
                field == "checkboxes" ||
                field == "radiobuttons" ||
                field == "date" ||
                field == "link" ||
                field == "file"
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          title = value;
                        },
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        cursorColor: Theme.of(context).textTheme.caption.color,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Title/Question"),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      field == "dropdown" ||
                              field == "checkboxes" ||
                              field == "radiobuttons"
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  onChanged: (value) {
                                    option = value;
                                  },
                                  maxLines: 6,
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: field == "dropdown"
                                          ? 'Enter dropdown options separated by commas\n \n Eg:option1,option2,option3'
                                          : field == "checkboxes"
                                              ? 'Enter checkboxes options separated by commas\n \n Eg:option1,option2,option3'
                                              : field == "radiobuttons"
                                                  ? 'Enter radiobuttons options separated by commas\n \n Eg:option1,option2,option3'
                                                  : ""),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                field == "checkboxes"
                                    ? Text(
                                        "(Check Boxes enable User to select multiple options from provided options",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800),
                                      )
                                    : field == "radiobuttons"
                                        ? Text(
                                            "(Radio Buttons enable user to select only single option from provided options",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          )
                                        : Container(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            )
                          : Container(),
                      ///////////////Button////////////////////
                      InkWell(
                        onTap: () {
                          setState(() {
                            required = !required;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Icon(
                                required
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank,
                                color:
                                Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Required',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      RButton("Add", 10.0, () {
                        if (title.isNullOrEmpty()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Field"),
                                content: new Text(
                                    "Required fields can not be empty"),
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
                          List<String> opts = option.split(",");
                          data.addAll(opts.toSet().toList());
                          bool r = required;
                          widget.callBack(DynamicFormWidget(
                              req: r,
                              data: null,
                              title: title,
                              field: field,
                              options: data));
                        }
                      }),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }
}

dynamicFormItems(
    BuildContext context, Function(DynamicFormWidget) callBack) async {
  showDialog(
    context: context,
    builder: (_) => RoundDialog(
      title: "Fields",
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(
                thickness: 4,
              ),
              DynamicFormTile(Icons.short_text, "Short Text", "", () {
                dynamicFormItemDetails(context, "short_text",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              DynamicFormTile(Icons.subject, "Paragraph", "", () {
                dynamicFormItemDetails(context, "paragraph",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              Divider(
                thickness: 1,
              ),
              DynamicFormTile(Icons.arrow_drop_down_circle, "Dropdown", "", () {
                dynamicFormItemDetails(context, "dropdown",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              DynamicFormTile(Icons.check_box, "Checkboxes", "", () {
                dynamicFormItemDetails(context, "checkboxes",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              DynamicFormTile(Icons.radio_button_checked, "Radio Buttons", "",
                  () {
                dynamicFormItemDetails(context, "radiobuttons",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              Divider(
                thickness: 1,
              ),
              DynamicFormTile(Icons.calendar_today, "DateTime", "", () {
                dynamicFormItemDetails(context, "date",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              Divider(
                thickness: 1,
              ),
              DynamicFormTile(Icons.link, "Link", "", () {
                dynamicFormItemDetails(context, "link",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
              DynamicFormTile(Icons.file_copy_rounded, "File", "", () {
                dynamicFormItemDetails(context, "file",
                    (DynamicFormWidget dfw) {
                  callBack(dfw);
                });
              }),
            ],
          ),
        )
      ],
    ),
  );
}
