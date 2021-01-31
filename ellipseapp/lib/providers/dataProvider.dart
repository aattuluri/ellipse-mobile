import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  List<String> get filters => _filters;
  List<String> _filters = ["Offline", "Online", "Free", "Paid"];
  void updateFilters(List<String> filtersList) {
    _filters = filtersList;
    notifyListeners();
  }
}
