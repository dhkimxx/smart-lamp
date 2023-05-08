import 'dart:convert';

import 'package:client/models/unit_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> putUserInfo(String userInfo) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.put(
    Uri.parse('$baseUrl/api/user'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: userInfo,
  );
  if (response.statusCode == 201) {
    print("Succeed to put user ${response.statusCode}");
  } else {
    print("Failed to put user ${response.statusCode}");
    throw Exception('Failed to put user ${response.statusCode}');
  }
}

Future<void> deleteUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.delete(
    Uri.parse('$baseUrl/api/unit'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: unit.toJson(),
  );

  if (response.statusCode == 200) {
    print("Succeeded to delete unit ${response.statusCode}");
  } else {
    print("Failed to delete unit ${response.statusCode}");
    throw Exception('Failed to delete unit ${response.statusCode}');
  }
}

Future<void> postUnitInfo(UnitModel unit) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.post(
    Uri.parse('$baseUrl/api/unit'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: unit.toJson(),
  );

  if (response.statusCode == 201) {
    print("Succeeded to post unit ${response.statusCode}");
  } else {
    print("Failed to post unit ${response.statusCode}");
    throw Exception('Failed to post unit ${response.statusCode}');
  }
}

Future<String> getUnitInfo(String unitCode) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final response = await http.get(Uri.parse('$baseUrl/api/unit/$unitCode'));

  if (response.statusCode == 200) {
    print("Succeeded to get unit ${response.statusCode}");
    return utf8.decode(response.bodyBytes);
  } else {
    print("Failed to get unit ${response.statusCode}");
    throw Exception('Failed to get unit ${response.statusCode}');
  }
}
