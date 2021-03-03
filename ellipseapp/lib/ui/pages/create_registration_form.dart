import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../widgets/index.dart';
import 'index.dart';

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
  List<DynamicFormWidget> listDynamic = [];
  List<String> data = [];
  List<Field> reg_form = [];
  List form = [];
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
      this.setState(() => form.add((json.encode(<String, dynamic>{
            'req': dfw.req,
            "title": dfw.title,
            "field": dfw.field,
            "options": dfw.options
          })).toString()));
      //print(form);
      this.setState(() => listDynamic.add(new DynamicFormWidget(
            req: dfw.req,
            data: null,
            title: dfw.title,
            field: dfw.field,
            options: dfw.options,
          )));
      setState(() {
        data = [];
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else{
      messageDialog(context, 'Form Item with same title exists');
    }
  }

  @override
  void initState() {
    setState(() {});
    print("saved form");
    print(widget.get_form);
    if (widget.get_form.isEmpty) {
      setState(() {
        form.add((json.encode(<String, dynamic>{
          'req': true,
          "title": "Email",
          "field": "short_text",
          "options": data
        })).toString());
        this.setState(() => listDynamic.add(new DynamicFormWidget(
            req: true,
            data: null,
            title: "Email",
            field: "short_text",
            options: [])));
        setState(() {
          data = [];
        });
      });
      setState(() {
        form.add((json.encode(<String, dynamic>{
          'req': true,
          "title": "Name",
          "field": "short_text",
          "options": data
        })).toString());
        this.setState(() => listDynamic.add(new DynamicFormWidget(
            req: true,
            data: null,
            title: "Name",
            field: "short_text",
            options: [])));
        setState(() {
          data = [];
        });
      });
    } else {
      setState(() {
        reg_form.clear();
      });
    }

    for (final item in widget.get_form) {
      this.setState(() => form.add((json.encode(<String, dynamic>{
            'req': item['req'],
            "title": item['title'],
            "field": item['field'],
            "options": item['options']
          })).toString()));

      this.setState(() => reg_form.add(
            Field(
              req: item['req'],
              title: item['title'],
              field: item['field'],
              options: item['options'],
            ),
          ));
    }
    for (final item in reg_form) {
      bool req = item.req;
      String title = item.title;
      String field = item.field;
      List options = item.options;
      this.setState(() => listDynamic.add(new DynamicFormWidget(
          req: req, data: null, title: title, field: field, options: options)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            "Create Registration Form",
            style: TextStyle(fontSize: 19.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'Add Field',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            dynamicFormItems(context, (DynamicFormWidget dfw) {
              addField(dfw);
            });
          },
          icon: Icon(Icons.playlist_add_outlined),
          label: Text("Add Field"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: CardPage.body(
                  title: "Choose below fields if you need",
                  body: RowLayout(children: <Widget>[
                    Wrap(
                      spacing: 4,
                      children: [
                        InputChip(
                            label: Text("College"),
                            selected: s_college,
                            onPressed: () {
                              setState(() {
                                form.add((json.encode(<String, dynamic>{
                                  "req": true,
                                  "title": "College",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicFormWidget(
                                        req: true,
                                        data: null,
                                        title: "College",
                                        field: "short_text",
                                        options: [])));
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
                                  'req': true,
                                  "title": "Year of Study",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicFormWidget(
                                        req: true,
                                        data: null,
                                        title: "Year of Study",
                                        field: "short_text",
                                        options: [])));
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
                child: CardPage.body(
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
                          scrollDirection: Axis.vertical,
                        ),
                      ),
                      listDynamic.isEmpty
                          ? Container()
                          : FloatingActionButton.extended(
                              heroTag: 'Save Form',
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              onPressed: () {
                                widget.form_fields(form);
                                //print(form);
                                Navigator.of(context).pop(true);
                              },
                              icon: Icon(Icons.save),
                              label: Text("Save Form"),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              )
            ],
          ),
        ),
      ),
    );
  }
}
