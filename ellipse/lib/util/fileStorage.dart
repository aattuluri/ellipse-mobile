import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> _getLocalFile(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  print('${dir.path}');
  return File('${dir.path}/$filename');
}

Future<File> saveItems(String data, String filename) async {
  try {
    final file = await _getLocalFile('$filename');
    return file.writeAsString(data);
  } catch (e) {
    return Future.error('Error during save');
  }
}

Future<String> readFile(String filename) async {
  try {
    final file = await _getLocalFile('$filename');
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
  } catch (e) {
    // If encountering an error, return 0.
    return null;
  }
}
/*
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    print('${dir.path}');
    return File('${dir.path}/events.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<List<Events>> loadItems() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
    final todos = json.map<Events>((item) => Events.fromJson(item)).toList();

    return todos;
  }

  Future<File> saveItems(events) async {
    try {
      final file = await _getLocalFile();
      //final map = events.map((event) => event.toJson()).toList();
      //final json = jsonEncode(map);
      print("file");
      return file.writeAsString(events);
    } catch (e) {
      return Future.error('Error during save');
    }
  }

  Future<DateTime> lastModified() async {
    final file = await _getLocalFile();
    return file.lastModified();
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
  */
