import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
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
    this.setState(() => form.add((json.encode(<String, dynamic>{
          "title": dfw.title,
          "field": dfw.field,
          "options": dfw.options
        })).toString()));
    print(form);
    this.setState(() => listDynamic
        .add(new DynamicFormWidget(dfw.title, dfw.field, dfw.options)));
    setState(() {
      data = [];
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    setState(() {});
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
            listDynamic.add(new DynamicFormWidget("Email", "short_text", [])));
        setState(() {
          data = [];
        });
      });
      setState(() {
        form.add((json.encode(<String, dynamic>{
          "title": "Name",
          "field": "short_text",
          "options": data
        })).toString());
        this.setState(() =>
            listDynamic.add(new DynamicFormWidget("Name", "short_text", [])));
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
            "title": item['title'],
            "field": item['field'],
            "options": item['options']
          })).toString()));

      this.setState(() => reg_form.add(
            Field(
              title: item['title'],
              field: item['field'],
              options: item['options'],
            ),
          ));
    }
    for (final item in reg_form) {
      print(item);
      print(item.title);
      String title = item.title;
      String field = item.field;
      List options = item.options;
      this.setState(
          () => listDynamic.add(new DynamicFormWidget(title, field, options)));
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
          onPressed: () => showDialog(
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
                      DynamicFormTile(Icons.short_text, "Short Text", "", () {
                        dynamicFormItems(context, "short_text",
                            (DynamicFormWidget dfw) {
                          addField(dfw);
                        });
                      }),
                      DynamicFormTile(Icons.subject, "Paragraph", "", () {
                        dynamicFormItems(context, "paragraph",
                            (DynamicFormWidget dfw) {
                          addField(dfw);
                        });
                      }),
                      Divider(
                        thickness: 1,
                      ),
                      DynamicFormTile(
                          Icons.arrow_drop_down_circle, "Dropdown", "", () {
                        dynamicFormItems(context, "dropdown",
                            (DynamicFormWidget dfw) {
                          addField(dfw);
                        });
                      }),
                      DynamicFormTile(Icons.check_box, "Checkboxes", "", () {
                        dynamicFormItems(context, "checkboxes",
                            (DynamicFormWidget dfw) {
                          addField(dfw);
                        });
                      }),
                      DynamicFormTile(
                          Icons.radio_button_checked, "Radio Buttons", "", () {
                        dynamicFormItems(context, "radiobuttons",
                            (DynamicFormWidget dfw) {
                          addField(dfw);
                        });
                      }),
                      Divider(
                        thickness: 1,
                      ),
                      DynamicFormTile(Icons.calendar_today, "DateTime", "", () {
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
                    ],
                  ),
                )
              ],
            ),
          ),
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
                                  "title": "College",
                                  "field": "short_text",
                                  "options": data
                                })).toString());
                                this.setState(() => listDynamic.add(
                                    new DynamicFormWidget(
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
                                    new DynamicFormWidget(
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
                                Navigator.of(context).pop(true);
                              },
                              icon: Icon(Icons.save),
                              label: Text("Save Form"),
                            ),
                      /* RButton('Save Form', 10, () {
                              widget.form_fields(form);
                              Navigator.of(context).pop(true);
                            }),*/
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
