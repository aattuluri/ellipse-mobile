
import 'dart:core';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../providers/index.dart';


Future<http.Response> httpPostFile(File _file, String url, String key) async {
  loadPref();
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $prefToken",
  };
  final mimeTypeData =
      lookupMimeType(_file.path, headerBytes: [0xFF, 0xD8]).split('/');
  // Intilize the multipart request
  final uploadRequest = http.MultipartRequest('POST', Uri.parse('$url'));
  uploadRequest.headers.addAll(headers);
  // Attach the file in the request
  final file = await http.MultipartFile.fromPath('$key', _file.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  // Explicitly pass the extension of the image with request body
  // Since image_picker has some bugs due which it mixes up
  // image extension with file name like this filenamejpge
  // Which creates some problem at the server side to manage
  // or verify the file extension
  uploadRequest.files.add(file);
  final streamedResponse = await uploadRequest.send();
  http.Response response = await http.Response.fromStream(streamedResponse);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
}

Future<http.Response> httpPostWithHeaders(String url, dynamic body) async {
  loadPref();
  http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $prefToken'
    },
    body: body,
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
}

Future<http.Response> httpPostWithoutHeaders(String url, dynamic body) async {
  http.Response response = await http.post(
    url,
    body: body,
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
}

Future<http.Response> httpGetWithHeaders(String url) async {
  loadPref();
  http.Response response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $prefToken'
  });
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
}

Future<http.Response> httpGetWithoutHeaders(String url) async {
  http.Response response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
}
