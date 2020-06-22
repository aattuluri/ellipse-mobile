import 'package:flutter/material.dart';
import '../../../components/colors.dart';
import '../../../components/neumorphic_components/widgets.dart';
import '../../../components/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';

class PreferencesBottomSheet extends StatefulWidget {
  @override
  _PreferencesBottomSheetState createState() => _PreferencesBottomSheetState();
}

class _PreferencesBottomSheetState extends State<PreferencesBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, viewModel, _) {
      return Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          color: CustomColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 7),
            FlatButton(
              child: Icon(
                Icons.expand_more,
                color: CustomColors.icon,
                size: 60,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 5),
            Center(
              child: NeumorphicButton(
                onTap: () {
                  setState(() {
                    viewModel.darkMode = !viewModel.darkMode;
                  });
                  Navigator.of(context).pop();
                },
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        viewModel.darkMode
                            ? Icons.brightness_high
                            : Icons.brightness_low,
                        color: CustomColors.icon,
                      ),
                      SizedBox(width: 20),
                      Text(
                        viewModel.darkMode ? "LightTheme" : "DarkTheme",
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
