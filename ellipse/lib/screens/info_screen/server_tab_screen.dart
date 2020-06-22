import '../../components/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/tab_interface.dart';

class ServerTab extends TabInterface {
  ServerTab(String titleName) : super(titleName);

  @override
  _ServerTabState createState() => _ServerTabState();
}

class _ServerTabState extends State<ServerTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (content, viewModel, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: <Widget>[],
        ),
      );
    });
  }
}
