import 'dart:core';
import 'dart:ui';

import 'package:EllipseApp/ui/pages/dynamicForm.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../widgets/index.dart';

class EventRounds extends StatefulWidget {
  const EventRounds({Key key, this.title, this.callBack}) : super(key: key);

  final String title;
  final Function(Round) callBack;
  @override
  _EventRoundsState createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds>
    with TickerProviderStateMixin {
  List<DynamicFormWidget> listDynamic = [];
  bool hasLink = true;
  bool hasForm = true;
  List form = [];
  var startDateController = new TextEditingController();
  var endDateController = new TextEditingController();
  String title = '', description = '', link = '';
  @override
  void initState() {
    loadPref();
    setState(() {
      title = 'Round ' + widget.title;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  addField(DynamicFormWidget dfw) async {
    this.setState(() => listDynamic
        .add(new DynamicFormWidget(dfw.title, dfw.field, dfw.options)));
    setState(() {
      form.add(<String, dynamic>{
        "title": dfw.title,
        "field": dfw.field,
        "options": dfw.options
      });
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          elevation: 4,
          title: Text(
            'Fill Round ' + widget.title + ' Details',
            style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: RowLayout(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: 'Round ' + widget.title,
                  readOnly: true,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                  onChanged: (value) {
                    title = value;
                  },
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
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Start Date',
                    hintText: 'Start Date',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 18.0,
                    ),
                  ),
                  dateMask: 'd MMMM, yyyy - hh:mm a',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  use24HourFormat: false,
                  onChanged: (value) {},
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'End Date',
                    hintText: 'End Date',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 18.0,
                    ),
                  ),
                  dateMask: 'd MMMM, yyyy - hh:mm a',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  use24HourFormat: false,
                  onChanged: (value) {},
                ),
                Row(children: <Widget>[
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      hoverColor: Theme.of(context).primaryColor,
                      focusColor: Theme.of(context).primaryColor,
                      value: hasForm,
                      onChanged: (value) {
                        setState(() {
                          hasForm = !hasForm;
                          listDynamic.clear();
                        });
                      },
                      activeColor: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.2),
                      checkColor: Theme.of(context).textTheme.caption.color,
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
                if (hasForm) ...[
                  OutlinedIconButton(
                    text: "Add Field",
                    icon: Icons.playlist_add_rounded,
                    onTap: () {
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
                                  DynamicFormTile(
                                      Icons.short_text, "Short Text", "", () {
                                    dynamicFormItems(context, "short_text",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  DynamicFormTile(
                                      Icons.subject, "Paragraph", "", () {
                                    dynamicFormItems(context, "paragraph",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  DynamicFormTile(Icons.arrow_drop_down_circle,
                                      "Dropdown", "", () {
                                    dynamicFormItems(context, "dropdown",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  DynamicFormTile(
                                      Icons.check_box, "Checkboxes", "", () {
                                    dynamicFormItems(context, "checkboxes",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  DynamicFormTile(Icons.radio_button_checked,
                                      "Radio Buttons", "", () {
                                    dynamicFormItems(context, "radiobuttons",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  DynamicFormTile(
                                      Icons.calendar_today, "DateTime", "", () {
                                    dynamicFormItems(context, "date",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  DynamicFormTile(Icons.link, "Link", "", () {
                                    dynamicFormItems(context, "link",
                                        (DynamicFormWidget dfw) {
                                      addField(dfw);
                                    });
                                  }),
                                  DynamicFormTile(
                                      Icons.file_copy_rounded, "File", "", () {
                                    dynamicFormItems(context, "file",
                                        (DynamicFormWidget dfw) {
                                      //addField(dfw);
                                    });
                                  }),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Center(child: Text('Form Fields')),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listDynamic.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          listDynamic[index],
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      listDynamic.removeAt(index);
                                    });
                                  },
                                  child: Icon(Icons.delete, size: 25)),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  ),
                ],
                Row(children: <Widget>[
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      hoverColor: Theme.of(context).primaryColor,
                      focusColor: Theme.of(context).primaryColor,
                      value: hasLink,
                      onChanged: (value) {
                        setState(() {
                          hasLink = !hasLink;
                          link = '';
                        });
                      },
                      activeColor: Theme.of(context)
                          .textTheme
                          .caption
                          .color
                          .withOpacity(0.2),
                      checkColor: Theme.of(context).textTheme.caption.color,
                      tristate: false,
                    ),
                  ),
                  Text(
                    'Provide Link',
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
                if (hasLink) ...[
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Link"),
                    maxLines: 3,
                    onChanged: (value) {
                      link = value;
                    },
                  ),
                ],
                RButton('Save Round ' + widget.title, 10, () {
                  widget.callBack(Round(
                      title: title,
                      description: description,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                      link: link,
                      fields: form));
                  Navigator.of(context).pop(true);
                }),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
