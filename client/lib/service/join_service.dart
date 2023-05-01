import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> joinUser(String userId, String userPw) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/api/users'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'userPw': userPw,
      // 'authenticated': 'false',
    }),
  );
  print("${response.statusCode}");

  if (response.statusCode == 201) {
    print("join success");
    return response.body;
  } else {
    throw Exception('Failed to join user');
  }
}
