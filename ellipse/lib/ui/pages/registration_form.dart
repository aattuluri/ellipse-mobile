import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

/*
class DynamicWidgetItem extends StatefulWidget {
  final String title, field;
  final List<dynamic> options;
  DynamicWidgetItem(this.title, this.field, this.options);
  @override
  State createState() => new DynamicWidgetItemState();
}

class DynamicWidgetItemState extends State<DynamicWidgetItem> {
  */
class DynamicWidgetItem extends StatelessWidget {
  final String title, field;
  final List<dynamic> options;

  DynamicWidgetItem(this.title, this.field, this.options);

  TextEditingController controller = new TextEditingController();
  dynamic filled;
  List<String> filled_list = [];
  List<String> filled_list_local = [];
  String _selected_option;
  String data;
  @override
  Widget build(BuildContext context) {
    switch (field) {
      case "short_text":
        return Container(
          margin: new EdgeInsets.symmetric(vertical: 8),
          child: new TextField(
            onChanged: (value) {
              filled = value;
            },
            controller: controller,
            autofocus: false,
            enableInteractiveSelection: true,
            maxLines: 1,
            decoration: new InputDecoration(
                border: OutlineInputBorder(), hintText: title),
          ),
        );
        break;
      case "paragraph":
        return Container(
          margin: new EdgeInsets.symmetric(vertical: 8),
          child: new TextField(
            autofocus: false,
            enableInteractiveSelection: true,
            onChanged: (value) {
              filled = value;
            },
            controller: controller,
            maxLines: 5,
            decoration: new InputDecoration(
                border: OutlineInputBorder(), hintText: title),
          ),
        );
        break;
      case "dropdown":
        return Container(
          margin: new EdgeInsets.symmetric(vertical: 8),
          child: new FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Event Type"),
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    hint: Text("${title}"),
                    isExpanded: true,
                    value: _selected_option,
                    isDense: true,
                    items: options
                        .map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      filled = newValue;
                      _selected_option = newValue;
                      state.didChange(newValue);
                    },
                  ),
                ),
              );
            },
          ),
        );
        break;
      case "checkboxes":
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            margin: new EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                ListView.builder(
                  itemCount: options.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String clicked = options[index].toString();
                    return InkWell(
                      onTap: () {
                        if (filled_list_local.contains("$clicked")) {
                          filled_list.remove("$clicked");
                          setState(() => filled_list_local.remove("$clicked"));
                        } else {
                          filled_list.add("$clicked");
                          setState(() => filled_list_local.add("$clicked"));
                        }
                        filled = filled_list;
                        print(filled_list);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            filled_list_local.contains("$clicked")
                                ? Icon(
                                    Icons.check_box,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              options[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
        break;
      case "radiobuttons":
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            margin: new EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                ListView.builder(
                  itemCount: options.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String clicked = options[index].toString();
                    return InkWell(
                      onTap: () {
                        if (filled_list_local.contains("$clicked")) {
                          filled_list.remove("$clicked");
                          setState(() => filled_list_local.remove("$clicked"));
                        } else {
                          if (filled_list_local.length == 1 ||
                              filled_list.length == 1) {
                            filled_list.clear();
                            setState(() => filled_list_local.clear());
                            filled_list.add("$clicked");
                            setState(() => filled_list_local.add("$clicked"));
                          } else {
                            filled_list.add("$clicked");
                            setState(() => filled_list_local.add("$clicked"));
                          }
                        }
                        filled = filled_list;
                        print(filled_list);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            filled_list_local.contains("$clicked")
                                ? Icon(
                                    Icons.radio_button_checked,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  )
                                : Icon(
                                    Icons.radio_button_off,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              options[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
        break;
      case "date":
        return Container(
          margin: new EdgeInsets.symmetric(vertical: 8),
          child: new DateTimeField(
            onChanged: (value) {
              filled = value.toString();
            },
            controller: controller,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
            ),
            cursorColor: Theme.of(context).textTheme.caption.color,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: title,
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
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
        );
        break;
      case "link":
        return Container(
          margin: new EdgeInsets.symmetric(vertical: 8),
          child: new TextField(
            onChanged: (value) {
              filled = value;
            },
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
                hintText: title),
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

class RegistrationForm extends StatefulWidget {
  final int index;
  final List data;
  RegistrationForm(this.index, this.data);
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with TickerProviderStateMixin {
  String token = "", id = "", email = "", college_id = "";
  // List<dynamic> filled_data = [];
  List<Field> form_data = [];
  String title = "", field = "", option = "";
  ScrollController scrollController;
  List<DynamicWidgetItem> listDynamic = [];
  Map<String, dynamic> data = {};

  register(UserDetails userdetails, Events event) async {
    data["Name"] = userdetails.name.toString();
    data["Userame"] = userdetails.username.toString();
    data["Email"] = userdetails.email.toString();
    data["College"] = userdetails.college_name.toString();
    listDynamic.forEach((widget) {
      print("");
      print(widget.title);
      print(widget.filled);
      data[widget.title.toString()] = widget.filled;
    });
    print(data);

    http.Response response = await http.post(
      '${Url.URL}/api/event/register?id=${event.id}',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, Object>{'data': data}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      context.read<EventsRepository>().refreshData();
      Navigator.pushNamed(context, Routes.info_page,
          arguments: {'index': widget.index});
    }
  }

  @override
  void initState() {
    getPref();
    for (final item in widget.data) {
      try {
        this.setState(() => form_data.add(
              Field(
                title: item['title'],
                field: item['field'],
                options: item['options'],
              ),
            ));
      } catch (_) {
        print("Error");
      }
    }
    for (final item in form_data) {
      try {
        print(item);
        print(item.title);
        this.setState(() => listDynamic
            .add(new DynamicWidgetItem(item.title, item.field, item.options)));
      } catch (_) {
        print("Error");
      }
    }

    super.initState();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      id = preferences.getString("id");
      email = preferences.getString("email");
      college_id = preferences.getString("college_id");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().getEvents(widget.index);
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: CardPage1.body(
                  title: "Fill Form",
                  body: RowLayout(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          //physics: ClampingScrollPhysics(),
                          itemCount: listDynamic.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                listDynamic[index],
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            );
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 150,
                          height: 50,
                          margin: EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                              color: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .color
                                  .withOpacity(0.3),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                register(_userdetails, _event);
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
