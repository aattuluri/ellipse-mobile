import 'package:flutter/material.dart';

import '../../util/index.dart';

void showDropdownSearchDialog(
    {BuildContext context,
    Object items,
    bool addEnabled,
    Function(String, String) onChanged}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 100),
            curve: Curves.bounceIn,
            child: SearchDialog(
              hintText: 'Search',
              items: items,
              addEnabled: addEnabled,
              onChanged: (key, value) {
                onChanged(key, value);
              },
            ),
          ));
}

class SearchDialog extends StatefulWidget {
  final String hintText;
  final Object items;
  final bool addEnabled;
  final Function(String, String) onChanged;
  SearchDialog({this.hintText, this.items, this.addEnabled, this.onChanged});
  @override
  State createState() => new SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  String _searchText = "";
  String addFieldText;
  Map<String, dynamic> itemsData = {};
  List<String> keys;
  List<dynamic> values;
  final TextEditingController _searchQuery = new TextEditingController();
  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    _SearchListState();
    itemsData = widget.items;
    keys = itemsData.keys.toList();
    values = itemsData.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          color: Theme.of(context).cardColor,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchQuery,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (widget.addEnabled) ...[
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  cursorColor:
                                      Theme.of(context).textTheme.caption.color,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Add Text"),
                                  onChanged: (value) {
                                    setState(() {
                                      addFieldText = value;
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        if (!addFieldText.isNullOrEmpty()) {
                                          widget.onChanged(
                                              addFieldText, addFieldText);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Ok'))
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ]
                ],
              ),
              Expanded(
                child: ListView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (var i = 0; i < values.length; i++) ...[
                        if (values[i]
                            .toString()
                            .toLowerCase()
                            .contains(_searchText.toLowerCase().trim())) ...[
                          ListTile(
                            title: Text(
                              values[i].toString(),
                              maxLines: 2,
                            ),
                            onTap: () {
                              widget.onChanged(
                                  keys[i].toString(), values[i].toString());
                              Navigator.pop(context);
                            },
                          )
                        ]
                      ]
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
