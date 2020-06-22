import 'package:shared_preferences/shared_preferences.dart';

import '../../components/colors.dart';
import '../../components/neumorphic_components/neumorphic_container.dart';
import '../../components/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/tab_interface.dart';

class EventTab extends TabInterface {
  EventTab(String titleName) : super(titleName);

  @override
  _GeneralTabState createState() => _GeneralTabState();
}

class _GeneralTabState extends State<EventTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String eveid = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      eveid = preferences.getString("eveid");
    });
    print("$eveid");
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Stack(
            children: <Widget>[
              NeumorphicContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 300,
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: 15,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        eveid,
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '2 HOURS',
                        style: TextStyle(
                          fontSize: 13,
                          color: CustomColors.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
