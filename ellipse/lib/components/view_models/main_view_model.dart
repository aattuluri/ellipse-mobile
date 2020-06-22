import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../../models/mode_item_model.dart';

enum ModeStatus {
  notStarted,
  running,
  paused,
}

class MainViewModel with ChangeNotifier {
  List<ModeItemModel> nodes = const [
    ModeItemModel(
      name: 'CodeChef',
      minutes: 1,
      color: Color.fromRGBO(253, 60, 53, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 32,
      color: Color.fromRGBO(61, 111, 252, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 24,
      color: Color.fromRGBO(50, 197, 253, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 12,
      color: Color.fromRGBO(253, 133, 53, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 1,
      color: Color.fromRGBO(253, 60, 53, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 32,
      color: Color.fromRGBO(61, 111, 252, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 24,
      color: Color.fromRGBO(50, 197, 253, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 12,
      color: Color.fromRGBO(253, 133, 53, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 1,
      color: Color.fromRGBO(253, 60, 53, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 32,
      color: Color.fromRGBO(61, 111, 252, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 24,
      color: Color.fromRGBO(50, 197, 253, 1),
    ),
    ModeItemModel(
      name: 'CodeChef',
      minutes: 12,
      color: Color.fromRGBO(253, 133, 53, 1),
    ),
  ];

  ModeItemModel get selectedMode => _selectedMode;
  ModeStatus get modeStatus => _modeStatus;

  ModeItemModel _selectedMode;
  ModeStatus _modeStatus = ModeStatus.notStarted;
}
