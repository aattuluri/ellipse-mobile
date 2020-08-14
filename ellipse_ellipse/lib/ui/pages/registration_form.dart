import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:row_collection/row_collection.dart';
import '../widgets/index.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:core';
import '../../models/index.dart';
import '../widgets/index.dart';
import '../../repositories/index.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DynamicWidgetItem extends StatefulWidget {
  final String title, field;
  final List<dynamic> options;
  DynamicWidgetItem(this.title, this.field, this.options);
  @override
  State createState() => new DynamicWidgetItemState();
}

class DynamicWidgetItemState extends State<DynamicWidgetItem> {
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
      case "short_answer":
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

class RegistrationForm extends StatefulWidget {
  final List data;
  RegistrationForm(this.data);
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with TickerProviderStateMixin {
  List<Field> form_data = [];
  String title = "", field = "", option = "";
  ScrollController scrollController;
  List<DynamicWidgetItem> listDynamic = [];
  @override
  void initState() {
    for (final item in widget.data) {
      this.setState(() => form_data.add(
            Field(
              title: item['title'],
              field: item['field'],
              options: item['options'],
            ),
          ));
    }
    for (final item in form_data) {
      print(item);
      print(item.title);
      this.setState(() => listDynamic
          .add(new DynamicWidgetItem(item.title, item.field, item.options)));
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
        /* appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            "Event Registration",
            style: TextStyle(fontSize: 19.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [],
          centerTitle: true,
        ),
        */
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
                          // scrollDirection: Axis.vertical,
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
                              onPressed: () async {}),
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
