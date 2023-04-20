import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8080/api/authenticate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'password': password,
      // 'authenticated': 'false',
    }),
  );
  print("${response.statusCode}");

  if (response.statusCode == 200) {
    print("success");
    return response.body;
  } else {
    throw Exception('Failed to login user');
  }
}
