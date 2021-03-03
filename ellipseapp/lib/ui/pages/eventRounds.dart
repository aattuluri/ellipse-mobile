import 'dart:core';
import 'dart:ui';

import 'package:EllipseApp/ui/pages/dynamicForm.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class EventRounds extends StatefulWidget {
  const EventRounds(
      {Key key,
      @required this.type,
      this.data,
      @required this.title,
      this.callBack})
      : super(key: key);

  final String title, type;
  final RoundModel data;
  final Function(RoundModel, Map<String, dynamic>) callBack;
  @override
  _EventRoundsState createState() => _EventRoundsState();
}

class _EventRoundsState extends State<EventRounds>
    with TickerProviderStateMixin {
  List<DynamicFormWidget> listDynamic = [];
  bool hasLink = true;
  bool hasForm = true;
  List<Map<String, dynamic>> form = [];
  var titleController = new TextEditingController();
  var descriptionController = new TextEditingController();
  var linkController = new TextEditingController();
  var startDateController = new TextEditingController();
  var endDateController = new TextEditingController();
  loadData() async {
    setState(() {
      titleController = new TextEditingController(text: widget.data.title);
      descriptionController =
          new TextEditingController(text: widget.data.description);
      linkController = new TextEditingController(text: widget.data.link);
      startDateController =
          new TextEditingController(text: widget.data.startDate.toString());
      endDateController =
          new TextEditingController(text: widget.data.endDate.toString());
      if (!widget.data.link.isNullOrEmpty()) {
        hasLink = true;
      } else {
        hasLink = false;
      }
    });
    for (final item in widget.data.fields) {
      print(item);
      FormFieldModel fF = item;
      setState(() {
        form.add(<String, dynamic>{
          'req': fF.required,
          "title": fF.title,
          "field": fF.field,
          "options": fF.options
        });
        listDynamic.add(new DynamicFormWidget(
            req: fF.required,
            data: null,
            title: fF.title,
            field: fF.field,
            options: fF.options));
      });
      setState(() {});
    }
    print(form);
    print(listDynamic);
  }

  @override
  void initState() {
    loadPref();
    setState(() {
      titleController.text = 'Round ' + widget.title;
    });
    if (widget.type == 'edit') {
      loadData();
    } else {}

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  addField(DynamicFormWidget dfw) async {
    bool valid = true;
    for (var i = 0; i < listDynamic.length; i++) {
      if (listDynamic[i].title == dfw.title) {
        setState(() {
          valid = false;
        });
        break;
      } else {
        setState(() {
          valid = true;
        });
      }
    }
    if (valid) {
      this.setState(() => listDynamic.add(new DynamicFormWidget(
          req: dfw.req,
          data: null,
          title: dfw.title,
          field: dfw.field,
          options: dfw.options)));
      setState(() {
        form.add(<String, dynamic>{
          "req": dfw.req,
          "title": dfw.title,
          "field": dfw.field,
          "options": dfw.options
        });
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      messageDialog(context, 'Form Item with same title exists');
    }
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
                  readOnly: true,
                  controller: titleController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  controller: descriptionController,
                  cursorColor: Theme.of(context).textTheme.caption.color,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Description"),
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    hintText: 'Start Date',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 18.0,
                    ),
                  ),
                  dateMask: 'd MMMM, yyyy - hh:mm a',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  use24HourFormat: false,
                  onChanged: (value) {
                    print(DateTime.parse(value));
                  },
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  controller: endDateController,
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
                  onChanged: (value) {
                    print(DateTime.parse(value));
                  },
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
                      dynamicFormItems(context, (DynamicFormWidget dfw) {
                        addField(dfw);
                      });
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
                                      form.removeAt(index);
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
                          linkController.clear();
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
                    controller: linkController,
                    cursorColor: Theme.of(context).textTheme.caption.color,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Link"),
                    maxLines: 3,
                  ),
                ],
                RButton('Save Round ' + widget.title, 10, () {
                  if (titleController.text.isNullOrEmpty() ||
                      descriptionController.text.isNullOrEmpty() ||
                      (hasLink && linkController.text.isNullOrEmpty()) ||
                      (hasForm && form.isEmpty) ||
                      startDateController.text.isNullOrEmpty() ||
                      endDateController.text.isNullOrEmpty()) {
                    messageDialog(context, 'All fields should be filled');
                  } else {
                    Object data = <String, dynamic>{
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'start_date': DateTime.parse(startDateController.text).toUtc().toIso8601String().toString(),
                      'end_date': DateTime.parse(endDateController.text).toUtc().toIso8601String().toString(),
                      'link': linkController.text,
                      'fields': form
                    };
                    widget.callBack(
                        RoundModel.fromJson(<String, dynamic>{
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'start_date':
                              DateTime.parse(startDateController.text),
                          'end_date': DateTime.parse(endDateController.text),
                          'link': linkController.text,
                          'fields': []
                        }),
                       data);
                    print(form);
                    Navigator.of(context).pop(true);
                  }
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
