import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> joinUser(String userId, String userPw, String userName) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/user'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'userPw': userPw,
      'userName': userName,
    }),
  );

  if (response.statusCode == 201) {
    print("join success ${response.statusCode}");
  } else {
    print("Failed to join ${response.statusCode}");
    throw Exception('Failed to join user ${response.statusCode}');
  }
}
