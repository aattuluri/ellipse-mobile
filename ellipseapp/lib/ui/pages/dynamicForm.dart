import 'dart:core';
import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';
import '../widgets/index.dart';

dynamicFormItems(BuildContext context, String type,
    Function(DynamicFormWidget) callBack) async {
  String title = "", field = "", option = "";
  List<String> data = [];
  DynamicFormWidget d;
  field = type;
  generalSheet(context,
      title: 'Fil Details',
      child: field == "short_text" ||
              field == "paragraph" ||
              field == "dropdown" ||
              field == "checkboxes" ||
              field == "radiobuttons" ||
              field == "date" ||
              field == "link"
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Add Title/Question to be displayed',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 30,
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
                      height: 20,
                    ),
                    field == "dropdown" ||
                            field == "checkboxes" ||
                            field == "radiobuttons"
                        ? Column(
                            children: [
                              Text(
                                'Add Options',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                onChanged: (value) {
                                  option = value;
                                },
                                maxLines: 6,
                                // controller: controller,
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
                                          "(Radio Buttons enable user to select single option from provided options",
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
                          print(option.split(","));
                          List<String> opts = option.split(",");
                          data.addAll(opts);
                          //d = DynamicFormWidget(title, field, data);
                          // return DynamicFormWidget(title, field, data);
                          callBack(DynamicFormWidget(title, field, data));
                        }
                      },
                      child: Container(
                        height: 40.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(fontSize: 19.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          : Container());
}

class DynamicFormWidget extends StatefulWidget {
  final String title, field;
  final List<dynamic> options;
  DynamicFormWidget(this.title, this.field, this.options);
  @override
  State createState() => new DynamicFormWidgetState();
}

class DynamicFormWidgetState extends State<DynamicFormWidget> {
  TextEditingController controller = new TextEditingController();
  String selectedOption;

  @override
  void initState() {
    print("${widget.title}");
    print("${widget.field}");
    print(widget.options);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field) {
      case "short_text":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextField(
                autofocus: false,
                enableInteractiveSelection: true,
                controller: controller,
                maxLines: 1,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
          ],
        );
        break;
      case "paragraph":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextField(
                autofocus: false,
                enableInteractiveSelection: true,
                controller: controller,
                maxLines: 5,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
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
                        hint: Text("${widget.title}"),
                        isExpanded: true,
                        value: selectedOption,
                        isDense: true,
                        items: widget.options
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = newValue;
                            state.didChange(newValue);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
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
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.check_box_outline_blank,
                              color: Theme.of(context).textTheme.caption.color,
                              //: Colors.grey
                              //.withOpacity(0.6),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.options[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
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
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.radio_button_unchecked,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.options[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        );
        break;
      case "date":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: DateTimePicker(
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
                controller: controller,
                //initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                use24HourFormat: false,
              ),
            ),
          ],
        );
        break;
      case "link":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new TextField(
                autofocus: false,
                enableInteractiveSelection: true,
                controller: controller,
                maxLines: 2,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(), hintText: widget.title),
              ),
            ),
          ],
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
