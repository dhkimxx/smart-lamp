import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> loginUser(String userId, String userPw) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/authenticate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'userPw': userPw,
    }),
  );

  if (response.statusCode == 200) {
    print("login success ${response.statusCode}");
    return response.body;
  } else {
    throw Exception('Failed to login user ${response.statusCode}');
  }
}
