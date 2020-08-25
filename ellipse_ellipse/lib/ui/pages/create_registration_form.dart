import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/index.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:core';
import '../../models/index.dart';

class DynamicWidget extends StatefulWidget {
  final String title, field;
  final List<dynamic> options;
  DynamicWidget(this.title, this.field, this.options);
  @override
  State createState() => new DynamicWidgetState();
}

class DynamicWidgetState extends State<DynamicWidget> {
  TextEditingController controller = new TextEditingController();
  String _selected_option;

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
                      child: Expanded(
                        child: new DropdownButton(
                          hint: Text("${widget.title}"),
                          isExpanded: true,
                          value: _selected_option,
                          isDense: true,
                          items: widget.options
                              .map((value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selected_option = newValue;
                              state.didChange(newValue);
                            });
                          },
                        ),
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
                              // Icons
                              //.check_box_outline_blank,
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
                              Icons.radio_button_off,
                              // Icons
                              //.check_box_outline_blank,
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
      case "date":
        return Column(
          children: [
            Container(
              margin: new EdgeInsets.symmetric(vertical: 8),
              child: new DateTimeField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                ),
                cursorColor: Theme.of(context).textTheme.caption.color,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: widget.title,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontSize: 18.0,
                  ),
                ),
                format: DateFormat("yyyy-MM-dd HH:mm"),
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
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.paste,
                          size: 25,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(),
                    hintText: widget.title),
              ),
            ),
          ],
        );
        break;
    }
  }
}

class CreateRegistrationForm extends StatefulWidget {
  const CreateRegistrationForm({Key key, this.form_fields, this.get_form})
      : super(key: key);
  final List get_form;
  final Function(List) form_fields;

  @override
  _CreateRegistrationFormState createState() => _CreateRegistrationFormState();
}

class _CreateRegistrationFormState extends State<CreateRegistrationForm>
    with TickerProviderStateMixin {
  String title = "", field = "", option = "";
  bool s_name = false;
  bool s_email = false;
  bool s_college = false;
  ScrollController scrollController;
  List<DynamicWidget> listDynamic = [];
  //List<String> options = [];
  List<String> data = [];
  List<Field1> reg_form = [];
  List form = [];
  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  void bottom_sheet(String type) {
    field = type;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return field == "short_text" ||
                  field == "paragraph" ||
                  field == "dropdown" ||
                  field == "checkboxes" ||
                  field == "radiobuttons" ||
                  field == "date" ||
                  field == "link"
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Container(
                            height: 5,
                            width: 50,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
                          cursorColor:
                              Theme.of(context).textTheme.caption.color,
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
                            print(option.split(","));
                            List<String> opts = option.split(",");
                            data.addAll(opts);
                            this.setState(() => form.add((json
                                    .encode(<String, dynamic>{
                                  "title": title,
                                  "field": field,
                                  "options": data
                                })).toString()));
                            print(form);
                            this.setState(() => listDynamic
                                .add(new DynamicWidget(title, field, data)));
                            setState(() {
                              data = [];
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent + 1000,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeOut,
                            );
                          },
                          child: Container(
                            height: 40.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
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
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    setState(() {
      //s_name = false;
      // s_email = false;
      // s_college = false;
    });
    print("saved form");
    print(widget.get_form);
    if (widget.get_form.isEmpty) {
      setState(() {
        form.add((json.encode(<String, dynamic>{
          "title": "Email",
          "field": "short_text",
          "options": data
        })).toString());
        this.setState(() =>
            listDynamic.add(new DynamicWidget("Email", "short_text", [])));
        setState(() {
          data = [];
        });
        //s_email = !s_email;
      });
      setState(() {
        form.add((json.encode(<String, dynamic>{
          "title": "Name",
          "field": "short_text",
          "options": data
        })).toString());
        this.setState(
            () => listDynamic.add(new DynamicWidget("Name", "short_text", [])));
        setState(() {
          data = [];
        });
        //s_name = !s_name;
      });
    } else {
      setState(() {
        reg_form.clear();
      });
    }

    for (final item in widget.get_form) {
      this.setState(() => form.add((json.encode(<String, dynamic>{
            "title": item['title'],
            "field": item['field'],
            "options": item['options']
          })).toString()));

      this.setState(() => reg_form.add(
            Field1(
              title: item['title'],
              field: item['field'],
              options: item['options'],
            ),
          ));
    }
    ///////////////////////////////////
    for (final item in reg_form) {
      print(item);
      print(item.title);
      String title = item.title;
      String field = item.field;
      List options = item.options;
      this.setState(
          () => listDynamic.add(new DynamicWidget(title, field, options)));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          // automaticallyImplyLeading: false,
          title: Text(
            "Create Registration Form",
            style: TextStyle(fontSize: 19.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(bottom: 30, right: 10),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => RoundDialog(
                  title: "Fields",
                  children: <Widget>[
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(
                            thickness: 4,
                          ),
                          CreateRegFormTile(Icons.short_text, "Short Text", "",
                              () {
                            bottom_sheet("short_text");
                          }),
                          CreateRegFormTile(Icons.subject, "Paragraph", "", () {
                            bottom_sheet("paragraph");
                          }),
                          Divider(
                            thickness: 1,
                          ),
                          CreateRegFormTile(
                              Icons.arrow_drop_down_circle, "Dropdown", "", () {
                            bottom_sheet("dropdown");
                          }),
                          CreateRegFormTile(Icons.check_box, "Checkboxes", "",
                              () {
                            bottom_sheet("checkboxes");
                          }),
                          CreateRegFormTile(
                              Icons.radio_button_checked, "Radio Buttons", "",
                              () {
                            bottom_sheet("radiobuttons");
                          }),
                          Divider(
                            thickness: 1,
                          ),
                          CreateRegFormTile(
                              Icons.calendar_today, "DateTime", "", () {
                            bottom_sheet("date");
                          }),
                          /*
                          CreateRegFormTile(Icons.alarm, "Time", "", () {
                            bottom_sheet("time");
                          }),
                          */
                          Divider(
                            thickness: 1,
                          ),
                          CreateRegFormTile(Icons.link, "Link", "", () {
                            bottom_sheet("link");
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              child: Container(
                height: 40.0,
                width: 145.0,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_comment, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Add Field",
                        style: TextStyle(fontSize: 19.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: CardPage1.body(
                  title: "Choose below fields if you need",
                  body: RowLayout(children: <Widget>[
                    Wrap(
                      spacing: 4,
                      children: [
                        /*
                        InputChip(
                            label: Text('Name'),
                            selected: s_name,
                            onPressed: () {
                              setState(() {
                                form.add((json.encode(<String, dynamic>{
                                  "title": "Name",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicWidget(
                                        "Name", "short_text", [])));
                                setState(() {
                                  data = [];
                                });
                                //s_name = !s_name;
                              });
                            }),
                            */

                        InputChip(
                            label: Text('College'),
                            selected: s_college,
                            onPressed: () {
                              setState(() {
                                //s_college = !s_college;
                                form.add((json.encode(<String, dynamic>{
                                  "title": "College",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicWidget(
                                        "College", "short_text", [])));
                                setState(() {
                                  data = [];
                                });
                              });
                            }),
                        InputChip(
                            label: Text("Year of Study"),
                            selected: s_email,
                            onPressed: () {
                              setState(() {
                                form.add((json.encode(<String, dynamic>{
                                  "title": "Year of Study",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicWidget(
                                        "Year of Study", "short_text", [])));
                                setState(() {
                                  data = [];
                                });
                                //s_email = !s_email;
                              });
                            }),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                    ),
                  ]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: CardPage1.body(
                  title: "Form",
                  body: RowLayout(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listDynamic.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                listDynamic[index],
                                Row(
                                  children: [
                                    Spacer(),
                                    index == 0 || index == 1
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              this.setState(() =>
                                                  listDynamic.removeAt(index));
                                              this.setState(
                                                  () => form.removeAt(index));
                                            },
                                            child:
                                                Icon(Icons.delete, size: 25)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                        ),
                      ),
                      listDynamic.isEmpty
                          ? Container()
                          : Center(
                              child: Container(
                                width: 150,
                                height: 50,
                                margin: EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.2),
                                    child: Text(
                                      'Save Form',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      ////////////////////////////////////////////////////////////////////////////////
                                      widget.form_fields(form);
                                      Navigator.of(context).pop(true);
                                    }),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
