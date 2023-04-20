import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://your-spring-boot-server.com/login'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to login user');
  }
}
