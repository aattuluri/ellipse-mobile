import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../widgets/index.dart';

class DynamicWidgetItem extends StatelessWidget {
  final String title, field;
  final List<dynamic> options;

  DynamicWidgetItem(this.title, this.field, this.options);

  TextEditingController controller = new TextEditingController();
  dynamic filled;
  bool readOnly = false;
  List<String> filled_list = [];
  List<String> filled_list_local = [];
  String _selected_option;
  String data;
  @override
  Widget build(BuildContext context) {
    if (title == "Name") {
      controller.text = prefName;
      readOnly = true;
    } else if (title == "Email") {
      controller.text = prefEmail;
      readOnly = true;
    } else if (title == "College") {
      controller.text = prefCollegeName;
      readOnly = true;
    } else {}
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
            readOnly: readOnly,
            enableInteractiveSelection: true,
            maxLines: 1,
            decoration: new InputDecoration(
                labelText: title,
                border: OutlineInputBorder(),
                hintText: title),
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
                labelText: title,
                border: OutlineInputBorder(),
                hintText: title),
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
                    border: OutlineInputBorder(), labelText: title),
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
          child: DateTimePicker(
            type: DateTimePickerType.dateTime,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: title,
              hintText: title,
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
            onChanged: (value) {
              filled = value.toString();
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
                labelText: title,
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
  final String eventId;
  final List data;
  RegistrationForm(this.eventId, this.data);
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool formFilled = false;
  List<Field> form_data = [];
  String title = "", field = "", option = "";
  ScrollController scrollController;
  List<DynamicWidgetItem> listDynamic = [];
  Map<String, dynamic> data = {};

  register(UserDetails userdetails, Events event) async {
    listDynamic.forEach((widget) {
      data[widget.title.toString()] = widget.filled;
    });
    data["Name"] = userdetails.name;
    data["Email"] = userdetails.email;
    if (data.containsKey('College')) {
      data["College"] = userdetails.collegeName;
    } else {}
    print(data);
    var response = await httpPostWithHeaders(
      '${Url.URL}/api/event/register?id=${event.eventId}',
      jsonEncode(<String, Object>{'data': data}),
    );
    if (response.statusCode == 200) {
      context.read<EventsRepository>().init();
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(true);
      messageDialog(context, "Registered Successfully");
    }
  }

  @override
  void initState() {
    loadPref();
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Events _event =
        context.watch<EventsRepository>().event(widget.eventId);
    final UserDetails _userdetails =
        context.watch<UserDetailsRepository>().getUserDetails(0);
    return isLoading
        ? LoaderCircular('Registering')
        : Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CardPage.body(
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
                          Acceptance(
                              'By registering for the event,I accept the ',
                              false),
                          RButton('Register', 13, () {
                            for (var i = 0; i <= listDynamic.length - 1; i++) {
                              print(listDynamic[i].title);
                              print(listDynamic[i].filled);
                              if (
                                  //listDynamic[i].field != "radiobuttons" &&
                                  listDynamic[i].field != "checkboxes" &&
                                      listDynamic[i].title != "Email" &&
                                      listDynamic[i].title != "Name" &&
                                      listDynamic[i].title != "College" &&
                                      (listDynamic[i].filled == '' ||
                                          listDynamic[i].filled == null ||
                                          listDynamic[i]
                                                  .filled
                                                  .toString()
                                                  .length ==
                                              0)) {
                                messageDialog(
                                    context,
                                    '${listDynamic[i].title}' +
                                        " " +
                                        'should be filled');
                                setState(() {
                                  formFilled = false;
                                });
                                break;
                              } else if (listDynamic[i].field ==
                                  "radiobuttons") {
                                List<String> flist = listDynamic[i].filled;
                                if (flist.isEmpty) {
                                  messageDialog(
                                      context,
                                      '${listDynamic[i].title}' +
                                          " " +
                                          'should be filled');
                                  setState(() {
                                    formFilled = false;
                                  });
                                  break;
                                }
                              } else {
                                setState(() {
                                  formFilled = true;
                                });
                              }
                            }
                            setState(() {});
                            print(formFilled);
                            if (formFilled) {
                              setState(() {
                                isLoading = true;
                              });
                              register(_userdetails, _event);
                            } else {}
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
