import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> loginUser(String userId, String userPw) async {
  final response = await http.post(
    Uri.parse(
        'https://smartlampserver-kafop.run.goorm.site:8080/api/authenticate'),
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

  if (response.statusCode == 200) {
    print("success");
    return response.body;
  } else {
    throw Exception('Failed to login user');
  }
}
