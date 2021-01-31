import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  String _searchText = '';

  String get searchText => _searchText;
  void changeSearchText(String text) {
    _searchText = text;
    print(text);
    notifyListeners();
  }

  void reset() {
    _searchText = '';
    notifyListeners();
  }
}
