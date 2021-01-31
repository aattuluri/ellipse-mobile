import 'package:EllipseApp/providers/searchProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  SearchAppBar({this.hintText, this.onChanged});
  @override
  State createState() => new SearchAppBarState();
}

class SearchAppBarState extends State<SearchAppBar> {
  TextEditingController textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, search, child) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        autofocus: true,
                        controller: textController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                        onChanged: (value) {
                          widget.onChanged(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        textController.clear();
                        widget.onChanged(textController.text);
                      },
                      child: Icon(Icons.close)),
                ],
              ),
            ),
          ),
        ),
      );
      /* TextField(
        autofocus: true,
        controller: textController,
        cursorColor: Theme.of(context).textTheme.caption.color,
        onChanged: (value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).cardColor,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          border: InputBorder.none,
          hintText: 'Search',
          suffixIcon: InkWell(
            onTap: () {
              textController.clear();
              widget.onChanged(textController.text);
            },
            child: Icon(
              Icons.clear,
              color: Theme.of(context).textTheme.caption.color,
              size: 27,
            ),
          ),
          hintStyle: TextStyle(
              color: Theme.of(context).textTheme.caption.color, fontSize: 23),
        ),
        style: TextStyle(
            color: Theme.of(context).textTheme.caption.color, fontSize: 23.0),
      );*/
    });
  }
}
