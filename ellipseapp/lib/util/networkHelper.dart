import 'package:http/http.dart' as http;

import '../providers/index.dart';

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
  /*
  var response = await httpPostWithHeaders(
                      '${Url.URL}/api/event/create_team',
                      jsonEncode(<String, dynamic>{
                        'event_id': widget.event_.id,
                        'team_name': _nameController.text,
                        'desc': _descriptionController.text
                      }),
                    );
  */
}

Future<http.Response> httpPostWithoutHeaders(String url, dynamic body) async {
  http.Response response = await http.post(
    url,
    body: body,
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
  /*
  var response = await httpPostWithoutHeaders(
                      '${Url.URL}/api/event/create_team',
                      {'email': email},
                    );
  */
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
  /*
  var response = await httpGetWithHeaders(
        "${Url.URL}/api/event/get_user_registration?id=$event_id");
  */
}

Future<http.Response> httpGetWithoutHeaders(String url) async {
  http.Response response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response;
  /*
  var response = await httpGetWithoutHeaders(
        "${Url.URL}/api/event/get_user_registration?id=$event_id");
  */
}
